setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Average Surface Temperature Dashboard")

#load libraries
library(shiny)
library(bslib)
library(tidyverse)
library(janitor)
library(ggridges)

#load data set
surface_temperature<-read_csv("https://raw.githubusercontent.com/bernardkilonzo-rigor/dataviz/main/data/global%20surface%20temperature.csv")

#pivoting data set
surface_temperature<-surface_temperature%>%
  pivot_longer(cols = -c(Entity,Code, Month),
               names_to = "Year",
               values_to = "Temp")

#rounding-off values & computing month names
surface_temperature<-surface_temperature%>%
  mutate(tempr = round(Temp,3))%>%
  mutate(mon = month.name[Month])

#ordering months
surface_temperature$mon<-factor(surface_temperature$mon, levels = month.name)

#define ui
ui <- page_navbar(
  title = "Average Surface Temperatures",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  nav_panel(
    NULL, #hides tab label
    page_fillable(
      #1st row: 2 cards
      layout_columns(
        col_widths = c(3,9),
        card(
          # ---- Paragraph 1 ----
          p("Paragraph"),
        
        # ---- Filter Input ----
        selectInput(
          inputId = "region",
          label = "Select Region",
          choices = c("Nairobi", "Mombasa", "Kisumu","Nakuru","Eldoret"),
          width = "100%"
        ),
        
        # ----- Paragraph 2 -----
        p(
          "test"
        )
        ),
        card()
      )
    )
  )
)

#define server
server <- function(input, output, session) {
  
}


#run application
shinyApp(ui = ui, server = server)
