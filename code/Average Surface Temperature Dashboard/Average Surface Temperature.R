setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Average Surface Temperature Dashboard")

#load libraries
library(shiny)
library(bslib)
library(tidyverse)
library(janitor)
library(ggridges)
library(plotly)

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
  title = "Global Surface Temperatures (1950 - 2024)",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  nav_panel(
    NULL, #hides tab label
    page_fillable(
      #1st row: 2 cards
      layout_columns(
        col_widths = c(3,9),
        card(
          # ---- Paragraph 1 ----
          p("The planet's average surface temperature has risen about 2 degrees Fahrenheit (1 degrees Celsius) since the late 19th century, a change driven largely by increased carbon dioxide emissions into the atmosphere and other human activities."),
        
        # ---- Filter Input ----
        selectInput(
          inputId = "Entity",
          label = "Select Country",
          choices = c("All", unique(surface_temperature$Entity)),
          selected = "Russia",
          width = "100%"
        ),
        
        # ----- Paragraph 2 -----
        p(
          "This visualization highlights global surface temperature patterns from 1950 to 2024, revealing how temperatures shift from January through December. Use the filter to explore the average surface temperature for each country and compare trends across regions."
        )
        ),
        card(
          card_header("Average Surface Temperatures"),
          card_body(
            plotOutput(
              "Temperature_plot"
            )
          )
        )
      )
    )
  )
)

#define server
server <- function(input, output, session) {
  
  #reactive data filtering
  filtered_data <- reactive({
    surface_temperature%>%
      filter(Entity == surface_temperature$Entity)
   })
  
  #creating the plot
  output$Temperature_plot <- renderPlot(
    
    surface_temperature%>%
      ggplot(aes(x = tempr, y = mon, fill = stat(x)))+
      geom_density_ridges_gradient(color = "gray50",linewidth = 0.4)+
      scale_fill_gradient2(low = "#1565c0", mid = "#D3DBE7", high = "#c62828", midpoint = 0)+
      labs(caption = "Data Source: NASA/GISS",
           y ="Month", x = "Average surface temperature (in degrees Celsius)",
           fill = "Temp")+
      theme(panel.grid = element_line(color = "#ececec", linewidth = 0.1),
            panel.background = element_rect(fill = "#fdfbfb"),
            axis.ticks = element_blank(),
            plot.title = element_text(family = "sans",face = "bold"),
            plot.subtitle = element_text(family = "sans",face = "italic"),
            plot.caption = element_text(family = "mono",face = "italic")
      )
  )
  
}
  
#run application
shinyApp(ui = ui, server = server)
