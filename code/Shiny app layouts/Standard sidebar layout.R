setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Shiny app layouts")

#load libraries
library(shiny)
library(bslib)

#define ui
ui <- fluidPage()
  
  
#define server
server < - function(input, output, session){
  
}
  

#run the application
shinyApp(ui = ui, server = server)
