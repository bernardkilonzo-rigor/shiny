setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Shiny app layouts")
#load libraries
library(shiny)
library(bslib)

#define ui
ui <- page_navbar(
  title = "Executive Sales Dashboard",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  # Demographic Tab
  nav_panel(
    title = "Demographic Dashboard",
    page_fillable(
      # 1st row: 3 cards for demographic overview
      layout_columns(
        col_widths = c(4, 4, 4),
        card(
          card_header("Age Distribution"),
          card_body("Visualization for age demographics will go here")
        ),
        card(
          card_header("Gender Breakdown"),
          card_body("Visualization for gender demographics will go here")
        ),
        card(
          card_header("Location Distribution"),
          card_body("Visualization for location demographics will go here")
        )
      ),
      
      # 2nd row: 2 larger cards
      layout_columns(
        col_widths = c(6, 6),
        card(
          card_header("Income Levels"),
          card_body("Visualization for income level distribution will go here")
        ),
        card(
          card_header("Education Background"),
          card_body("Visualization for education demographics will go here")
        )
      ),
      
      # 3rd row: 1 full-width card
      layout_columns(
        col_widths = 12,
        card(
          card_header("Detailed Demographic Table"),
          card_body("Detailed demographic data table will go here")
        )
      )
    )
  ),
  
  # Survey Dashboard Tab
  nav_panel(
    title = "Survey Dashboard",
    page_fillable(
      # 1st row: 4 metric cards
      layout_columns(
        col_widths = c(3, 3, 3, 3),
        card(
          card_header("Response Rate"),
          card_body("Total response rate metric will go here")
        ),
        card(
          card_header("Satisfaction Score"),
          card_body("Average satisfaction score will go here")
        ),
        card(
          card_header("Total Responses"),
          card_body("Number of responses will go here")
        ),
        card(
          card_header("Completion Rate"),
          card_body("Survey completion rate will go here")
        )
      ),
      
      # 2nd row: 3 visualization cards
      layout_columns(
        col_widths = c(4, 4, 4),
        card(
          card_header("Question Responses"),
          card_body("Visualization for key question responses will go here")
        ),
        card(
          card_header("Sentiment Analysis"),
          card_body("Sentiment analysis chart will go here")
        ),
        card(
          card_header("Time Trends"),
          card_body("Response trends over time will go here")
        )
      ),
      
      # 3rd row: 2 detailed analysis cards
      layout_columns(
        col_widths = c(6, 6),
        card(
          card_header("Cross-tabulation Analysis"),
          card_body("Cross-tab analysis visualization will go here")
        ),
        card(
          card_header("Open-ended Responses"),
          card_body("Word cloud or text analysis will go here")
        )
      )
    )
  )
)

#define server
server <- function(input, output, session){
  # Server logic for demographic visualizations will go here
  
  # Server logic for survey dashboard visualizations will go here
}

#run the application
shinyApp(ui = ui, server = server)