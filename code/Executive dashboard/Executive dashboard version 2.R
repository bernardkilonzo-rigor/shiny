setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Executive dashboard")

#load libraries
library(tidyverse)
library(shiny)
library(bslib)
library(janitor)

#load data set
Finance_data <- read.csv("https://raw.githubusercontent.com/bernardkilonzo-rigor/dataviz/refs/heads/main/data/Financial%20Data_v2.csv", check.names = FALSE)%>%
  clean_names()%>%
  mutate(net_profit_margin_percent = parse_number(net_profit_margin_percent)/100,
         year = year(dmy(date)))

#define ui
ui <- page_navbar(
  title = "Executive Dashboard",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  # Add custom CSS for larger toggle button
  tags$head(
    tags$style(HTML("
                    
      .navbar-brand {
        font-size: 32px !important;
        font-weight: bold !important;
      }
      
      .form-switch .form-check-input {
        width: 80px !important;
        height: 40px !important;
        background-color: white !important;
        border: 2px solid #ccc !important;
      }
      .form-switch .form-check-input:checked {
        background-color: #e9ecef !important;
        border: 2px solid #ccc !important;
      }
      .form-switch .form-check-input::after {
        width: 36px !important;
        height: 36px !important;
        background-color: #0d6efd !important;
      }
      .year-toggle-label {
        font-size: 18px;
        font-weight: bold;
        color: white !important;
      }
    "))
  ),
  
  # Add year toggle to navbar
  nav_spacer(),
  nav_item(
    div(
      style = "display: flex; align-items: center; gap: 15px; padding: 8px;",
      tags$span("2024", class = "year-toggle-label"),
      input_switch(
        id = "year_toggle",
        label = NULL,
        value = FALSE,
        width = "80px"
      ),
      tags$span("2025", class = "year-toggle-label")
    )
  ),
  
  nav_panel(
    NULL, #hides tab label
    page_fillable(
      #1st row: 4 cards
      layout_columns(
        col_widths = c(4,4,4),
        value_box(
            title = "Income",
            value = textOutput("income"),
            showcase = bsicons::bs_icon("pie-chart-fill"),
            theme = value_box_theme(bg = "#ffffff", fg = "#bfb304")
          ),
        
        value_box(
            title = "Gross Profit",
            value = textOutput("gross_profit"),
            showcase = bsicons::bs_icon("bar-chart-fill"),
            theme = value_box_theme(bg = "#ffffff", fg = "#72874e")
          ),
        
        value_box(
            title = "Net Profit",
            value = textOutput("net_profit"),
            showcase = bsicons::bs_icon("graph-up"),
            theme = value_box_theme(bg = "#ffffff", fg = "#486f85")
          )
        ),
      
      #2nd row: 3 cards
      layout_columns(
        col_widths = c(4,4,4),
        value_box(
            title = "Operating Profit",
            value = textOutput("operating_profit"),
            showcase = bsicons::bs_icon("clipboard-data"),
            theme = value_box_theme(bg = "#ffffff", fg = "#023742")
          ),
        
        value_box(
            title = "Expenses",
            value = textOutput("expenses"),
            showcase = bsicons::bs_icon("coin"),
            theme = value_box_theme(bg = "#ffffff", fg = "#a68b03")
          ),
        
        value_box(
            title = "Total Operating Expenses",
            value = textOutput("total_operating_expenses"),
            showcase = bsicons::bs_icon("currency-exchange"),
            theme = value_box_theme(bg = "#ffffff", fg = "#453947")
          )
        ),
      
      #3rd row: 2 cards
      layout_columns(
        col_widths = c(4,4,4),
        value_box(
            title = "Cost of Goods Sold",
            value = textOutput("cost_of_goods_sold"),
            showcase = bsicons::bs_icon("currency-dollar"),
            theme = value_box_theme(bg = "#ffffff", fg = "#b06458")
          ),
        
        value_box(
            title = "Net Profit Margin",
            value = textOutput("net_profit_margin"),
            showcase = bsicons::bs_icon("highlights"),
            theme = value_box_theme(bg = "#ffffff", fg = "#7b8b8c")
          ),
        
        value_box(
            title = "Taxes",
            value = textOutput("taxes"),
            showcase = bsicons::bs_icon("cash-coin"),
            theme = value_box_theme(bg = "#ffffff", fg = "#c28861")
          )
        )
      )
   )
)


#define server
server <- function(input, output, session){
  
  #reactive data filtering
  filtered_data <- reactive({
    # Toggle returns FALSE for 2024, TRUE for 2025
    selected_year <- ifelse(input$year_toggle, 2025, 2024)
    
    Finance_data %>%
      filter(year == selected_year)
    
  })
  
  # Display selected year
  output$selected_year_display <- renderText({
    selected_year <- ifelse(input$year_toggle, 2025, 2024)
    paste("Showing performance for:", selected_year)
  })
  
  #calculating sums for each indicator
  output$income <- renderText({
    format(sum(filtered_data()$"income"), big.mark = ",")
  })
  
  output$gross_profit <- renderText({
    format(sum(filtered_data()$"gross_profit"), big.mark = ",")
  })
  
  output$net_profit <- renderText({
    format(sum(filtered_data()$"net_profit"), big.mark = ",")
  })
  
  output$operating_profit <- renderText({
    format(sum(filtered_data()$"operating_profit_ebit"), big.mark = ",")
  })
  
  output$expenses <- renderText({
    format(sum(filtered_data()$"expenses"), big.mark = ",")
  })
  
  output$total_operating_expenses <- renderText({
    format(sum(filtered_data()$"total_operating_expenses"), big.mark = ",")
  })
  
  output$cost_of_goods_sold <- renderText({
    format(sum(filtered_data()$"cost_of_goods_sold"), big.mark = ",")
  })
  
  output$net_profit_margin <- renderText({
    scales::percent(
      mean(filtered_data()$"net_profit_margin_percent"), accuracy = 0.1
    )
  })
  
  output$taxes <- renderText({
    format(sum(filtered_data()$"taxes"), big.mark = ",")
  })
}

#run the application
shinyApp(ui = ui, server = server)