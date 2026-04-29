setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Executive dashboard")

#load libraries
library(shiny)
library(bslib)

#load data set
Finance_data <- read.csv("https://raw.githubusercontent.com/bernardkilonzo-rigor/dataviz/refs/heads/main/data/Financial%20Data.csv")

#define ui
ui <- page_navbar(
  title = "Executive Sales Dashboard",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  nav_panel(
    NULL, #hides tab label
    page_fillable(
      #1st row: 4 cards
      layout_columns(
        col_widths = c(4,4,4),
        card(),card(),card()
      ),
      
      #2nd row: 3 cards
      layout_columns(
        col_widths = c(4,4,4),
        card(),card(),card()
      ),
      
      #3rd row: 2 cards
      layout_columns(
        col_widths = c(4,4,4),
        card(),card(),card()
      )
    )
  )
)

#define server
server <- function(input, output, session){
  
}

#run the application
shinyApp(ui = ui, server = server)