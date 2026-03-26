setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Data collection app")

#load libraries
library(shiny)
library(DBI)
library(RSQLite)
library(dplyr)

# Helper functions for validation
is_valid_email <- function(x) {
  grepl("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", x)
}

is_valid_phone <- function(x) {
  # Accepts digits, spaces, +, -, parentheses; must contain at least 7 digits
  cleaned <- gsub("[^0-9]", "", x)
  nchar(cleaned) >= 7
}

#define ui
ui <- fluidPage(
  
  titlePanel("Customer Feedback Form"),
  
  tabsetPanel(
    # Tab 1: Feedback form
    tabPanel("Submit Feedback",
  
  sidebarLayout(
    sidebarPanel(
      
      # Service Name
      radioButtons(
        inputId = "service_name",
        label = "What service were you seeking?**",
        choices = c("Deposit", "Withdraw", "Card Service", "Customer Care", "Forex"),
        selected = character(0)
      ),
      
      # Rating Scale 1–5
      radioButtons(
        inputId = "rating_5",
        label = "On a scale of 1-5 with five being the highest, how would you rate your overall satisfaction with the service you received?**",
        choices = c(
          "Very Satisfied" = 5,
          "Satisfied" = 4,
          "Neutral" = 3,
          "Dissatisfied" = 2,
          "Very Dissatisfied" = 1
        ),
        selected = character(0)
      ),
      
      # Rating Scale 1–10
      sliderInput(
        inputId = "rating_10",
        label = "How likely are you to recommend the branch to a friend or colleague? (1 being Very Unlikely and 10 being Very Likely.**",
        min = 1,
        max = 10,
        value = 1
      ),
      
      # Feedback
      textAreaInput(
        inputId = "feedback",
        label = "What can we do to improve our service delivery?**",
        placeholder = "Enter your answer..."
      ),
      
      # Contact Details
      textInput(
        inputId = "contact",
        label = "Please share your phone number or email address so that we can contact you.",
        placeholder = "Enter your email or phone number..."
      ),
      
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      h3("Submitted Information"),
      verbatimTextOutput("results"),
      textOutput("save_status")
    )
  )
    ),
  # Tab 2: Data Viewer
  tabPanel("View Submissions",
           h3("All Feedback Records"),
           dataTableOutput("table_view")
           )
    )
  )

# Define server logic
server <- function(input, output, session) {
  
  # Initialize SQLite database
  db_path <- "feedback_data.sqlite"
  conn <- dbConnect(RSQLite::SQLite(), db_path)
  
  # Create table if it doesn't exist
  dbExecute(conn, "
    CREATE TABLE IF NOT EXISTS feedback (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      Session_ID TEXT,
      Service_Name TEXT,
      Rating_1_to_5 INTEGER,
      Rating_1_to_10 INTEGER,
      Feedback TEXT,
      Contact TEXT,
      Timestamp TEXT
    )
  ")
  
  # Handle form submission
  observeEvent(input$submit, {
    
    if (is.null(input$service_name) || input$service_name == "") {
      showNotification("Please select a service.", type = "error")
      return()
    }
    
    if (length(input$rating_5) == 0) {
      showNotification("Please select a rating (1–5).", type = "error")
      return()
    }
    
    if (is.na(input$rating_10)) {
      showNotification("Please select a rating (1–10).", type = "error")
      return()
    }
    
    if (input$feedback == "") {
      showNotification("Please provide feedback.", type = "error")
      return()
    }
    
    #optional contact validation
    if (input$contact != "") {
      valid_email <- is_valid_email(input$contact)
      valid_phone <- is_valid_phone(input$contact)
      
      if (!(valid_email || valid_phone)) {
        showNotification("Please enter a valid email or phone number.", type = "error")
        return()
      }
    }
    
    #create a one-row data frame from inputs
    new_entry <- data.frame(
      Session_ID = session$token,
      Service_Name = input$service_name,
      Rating_1_to_5 = input$rating_5,
      Rating_1_to_10 = input$rating_10,
      Feedback = input$feedback,
      Contact = input$contact,
      Timestamp = as.character(Sys.time()),
      stringsAsFactors = FALSE
    )
    
    # Insert into SQLite
    dbWriteTable(
      conn,
      name = "feedback",
      value = new_entry,
      append = TRUE,
      row.names = FALSE
    )
    
    # Display submitted info
    output$results <- renderPrint({
      new_entry
    })
    
    # Confirmation message
    
    output$save_status <- renderText(
      "Your feedback has been saved successfully"
    )
    
    # Reset form
    updateRadioButtons(session, "service_name", selected = character(0))
    updateRadioButtons(session, "rating_5", selected = character(0))
    updateSliderInput(session, "rating_10", value = 1)
    updateTextAreaInput(session, "feedback", value = "")
    updateTextInput(session, "contact", value = "")
    
  })
  
  # Data view tab
  output$table_view <- renderDataTable({
    dbReadTable(conn, "feedback") %>% arrange(desc(id))
  })
  
  # Close DB connection when session ends
  session$onSessionEnded(function() {
    dbDisconnect(conn)
  })
  
}

#run the application
shinyApp(ui, server)
