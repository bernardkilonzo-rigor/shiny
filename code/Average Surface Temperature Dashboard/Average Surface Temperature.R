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
  title = tags$strong("Global Surface Temperatures (1950 - 2024)"),
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  nav_panel(
    NULL, #hides tab label
    page_fillable(
      #1st row: 2 cards
      layout_columns(
        col_widths = c(3,9),
        card(
          # ---- Paragraph 1 ----
          p("This visualization highlights global surface temperature patterns from 1950 to 2024, revealing how temperatures shift from January through December. Use the filter to explore the average surface temperature for each country and compare trends across regions."),
        
        # ---- Filter Input ----
        selectInput(
          inputId = "Entity",
          label = "Select Country",
          choices = c(unique(surface_temperature$Entity)),
          selected = "Russia",
          width = "100%"
        ),
        
        # ----- Paragraph 2 -----
        p(
          "NASA/GISS Global Surface Temperatures refers to the GISS Surface Temperature Analysis (GISTEMP), a long‑running scientific dataset that tracks how Earth’s surface temperatures have changed over time. It is produced by NASA’s Goddard Institute for Space Studies (GISS) and is one of the world’s primary references for understanding global warming trends."
        )
        ),
        card(
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
    surface_temperature %>%
      filter(Entity == input$Entity)
  })
  
  #creating the plot
  output$Temperature_plot <- renderPlot({
    
    filtered_data()%>%
      ggplot(aes(x = tempr, y = mon, fill = stat(x)))+
      geom_density_ridges_gradient(color = "gray50",linewidth = 0.4)+
      scale_fill_gradient2(low = "#1565c0", mid = "#D3DBE7", high = "#c62828", midpoint = 0)+
      labs(caption = "Data Source: NASA/GISS",
           y ="Month", x = "Average surface temperature (in degrees Celsius)",
           fill = "Temp")+
      theme(panel.grid = element_line(color = "#ececec", linewidth = 0.1),
            panel.background = element_rect(fill = "#fdfbfb"),
            axis.ticks = element_blank(),
            axis.text = element_text(size = 14),
            axis.title = element_text(size = 16),
            legend.text = element_text(size = 12),
            legend.title = element_text(size = 14),
            plot.caption = element_text(family = "mono",face = "italic", size = 14)
      )
  })
  
}
  
#run application
shinyApp(ui = ui, server = server)
