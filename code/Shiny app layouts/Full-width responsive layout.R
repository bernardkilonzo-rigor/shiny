setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Shiny app layouts")

#load libraries
library(shiny)
library(bslib)

#define ui
ui <- page_fillable(
  #1st row: 4 cards
  layout_columns(
    col_widths = c(3,3,3,3),
    card(),card(),card(),card()
  ),
  
  #2nd row: 3 cards
  layout_columns(
    col_widths = c(4,4,4),
    card(),card(),card()
  ),
  
  #3rd row: 2 cards
  layout_columns(
    col_widths = c(6,6),
    card(),card()
  )
)

#define server
server <- function(input, output, session){
  
}

#run the application
shinyApp(ui = ui, server = server)