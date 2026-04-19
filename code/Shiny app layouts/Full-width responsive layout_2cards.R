setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Shiny app layouts")

#load libraries
library(shiny)
library(bslib)

ui <- page_fillable(
  #1st row: 2 cards
  layout_columns(
    col_widths = c(3,9),
    card(),card()
  )
)

#define server
server <- function(input, output, session){
  
}

#run the application
shinyApp(ui = ui, server = server)