setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Shiny app layouts")

#load libraries
library(shiny)
library(bslib)

#define ui
ui <- page_sidebar(
  sidebar = sidebar(
    title = "Filters"
  ),
  #main content
  layout_columns(
    col_widths = c(4,4,4),
    card(),card(),card()
  ),
  layout_columns(
    col_widths = c(6,6),
    card(),card()
  ),
  layout_columns(
    col_widths = 12,
    card()
  )
)
  
  
#define server
server <- function(input, output, session){
  
}
  
#run the application
shinyApp(ui = ui, server = server)
