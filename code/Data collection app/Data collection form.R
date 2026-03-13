setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Data collection app")

#load libraries
library(shiny)

#define ui
ui <- fluidPage(
  
  titlePanel("Customer Feedback Form"),
  
  sidebarLayout(
    sidebarPanel(
      
      # Service Name
      selectInput(
        inputId = "service_name",
        label = "What service were you seeking?",
        choices = c("Deposit", "Withdraw", "Card Service", "Customer Care", "Forex")
      ),
      
      # Rating Scale 1–5
      radioButtons(
        inputId = "rating_5",
        label = "On a scale of 1-5 with five being the highest, how would you rate your overall satisfaction with the service you received?",
        choices = c(
          "Very Satisfied" = 1,
          "Satisfied" = 2,
          "Neutral" = 3,
          "Dissatisfied" = 4,
          "Very Dissatisfied" = 5
        )
      ),
      
      # Rating Scale 1–10
      sliderInput(
        inputId = "rating_10",
        label = "How likely are you to recommend the branch to a friend or colleague? (1 being Very Unlikely and 10 being Very Likely.",
        min = 1,
        max = 10,
        value = 5
      ),
      
      # Feedback
      textAreaInput(
        inputId = "feedback",
        label = "What can we do to improve our service delivery?",
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
)
  
#define server logic
server <- function(input, output, session) {
  
  observeEvent(input$submit, {
    
    #create a one-row data frame from inputs
    new_entry <- data.frame(
        Service_Name = input$service_name,
        Rating_1_to_5 = input$rating_5,
        Rating_1_to_10 = input$rating_10,
        Feedback = input$feedback,
        Contact = input$contact,
        Timestamp = Sys.time(),
        stringsAsFactors = FALSE
      )
    
    #save to CSV (append if file exists)
    file_path <- "feedback_data.csv"
    
    if (!file.exists(file_path)){
      write.csv(new_entry, file_path, row.names = FALSE)
    } else {
      write.table(new_entry, file_path, append = TRUE,
                  sep = ",", col.names = FALSE, row.names = FALSE)
    }
    
    #display submitted info
    output$results <- renderPrint({
      new_entry
    })
    
    #confirmation message
    
    output$save_status <- renderText(
      "Your feedback has been saved successfully"
    )
 })
}

#run the application
shinyApp(ui, server)