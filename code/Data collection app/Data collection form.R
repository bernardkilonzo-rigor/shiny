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
        label = "Service Name",
        choices = c("Deposit", "Withdraw", "Card Service", "Customer Care", "Forex")
      ),
      
      # Rating Scale 1–5
      sliderInput(
        inputId = "rating_5",
        label = "Rating (1 to 5)",
        min = 1,
        max = 5,
        value = 3
      ),
      
      # Rating Scale 1–10
      sliderInput(
        inputId = "rating_10",
        label = "Rating (1 to 10)",
        min = 1,
        max = 10,
        value = 5
      ),
      
      # Feedback
      textAreaInput(
        inputId = "feedback",
        label = "Feedback",
        placeholder = "Share your experience..."
      ),
      
      # Contact Details
      textInput(
        inputId = "contact",
        label = "Contact Details",
        placeholder = "Email or phone number"
      ),
      
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      h3("Submitted Information"),
      verbatimTextOutput("results")
    )
  )
)
  
#define server logic
server <-
  

  
#run the application
