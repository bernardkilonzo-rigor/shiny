setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Executive dashboard")

#load libraries
library(shiny)
library(bslib)
library(tidyverse)
library(janitor)

#load data set
Finance_data <- read.csv("https://raw.githubusercontent.com/bernardkilonzo-rigor/dataviz/refs/heads/main/data/Financial%20Data_v2.csv", check.names = FALSE)%>%
  clean_names()%>%
  mutate(net_profit_margin_percent = parse_number(net_profit_margin_percent)/100,
         year = year(dmy(date)))

#define ui
ui <- fluidPage(
  
)
  

#define server
server <- function(input, output, session){
  
}
  

  
#run the application
shinyApp(ui = ui, server = server)
