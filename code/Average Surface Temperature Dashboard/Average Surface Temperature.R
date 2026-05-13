setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Average Surface Temperature Dashboard")

#load libraries
library(shiny)
library(bslib)
library(tidyverse)
library(janitor)
library(ggridges)

#load data set
surface_temperature<-read_csv("https://raw.githubusercontent.com/bernardkilonzo-rigor/dataviz/main/data/global%20surface%20temperature.csv")


#define ui
ui <- fluidPage(
  
)

#define server
server <- function(input, output, session) {
  
}


#run application
shinyApp(ui = ui, server = server)
