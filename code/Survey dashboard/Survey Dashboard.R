setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Survey dashboard")
#load libraries
library(shiny)
library(bslib)
library(janitor)

#load data set
survey_data <-read.csv("https://raw.githubusercontent.com/bernardkilonzo-rigor/dataviz/main/data/Survey%20Data.csv")%>%
  clean_names()

#define ui
ui <- fluidPage(
  
)


#define server
server <- function(input, output, session){
  
}


#run application
shinyApp(ui = ui, server = server)



