setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Executive dashboard")

#load libraries
library(tidyverse)
library(shiny)
library(bslib)
library(janitor)

#load data set
Finance_data <- read.csv("https://raw.githubusercontent.com/bernardkilonzo-rigor/dataviz/refs/heads/main/data/Financial%20Data_v2.csv", check.names = FALSE)%>%
  clean_names()%>%
  mutate(net_profit_margin_percent = parse_number(net_profit_margin_percent)/100)

#define ui
ui <- page_navbar(
  title = "Executive Dashboard",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
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
            theme = "primary"
          ),
        
        value_box(
            title = "Gross Profit",
            value = textOutput("gross_profit"),
            showcase = bsicons::bs_icon("bar-chart-fill"),
            theme = "warning"
          ),
        
        value_box(
            title = "Net Profit",
            value = textOutput("net_profit"),
            showcase = bsicons::bs_icon("graph-up"),
            theme = "info"
          )
        ),
      
      #2nd row: 3 cards
      layout_columns(
        col_widths = c(4,4,4),
        value_box(
            title = "Operating Profit",
            value = textOutput("operating_profit"),
            showcase = bsicons::bs_icon("clipboard-data"),
            theme = "warning"
          ),
        
        value_box(
            title = "Expenses",
            value = textOutput("expenses"),
            showcase = bsicons::bs_icon("coin"),
            theme = "primary"
          ),
        
        value_box(
            title = "Total Operating Expenses",
            value = textOutput("total_operating_expenses"),
            showcase = bsicons::bs_icon("currency-exchange"),
            theme = "danger"
          )
        ),
      
      #3rd row: 2 cards
      layout_columns(
        col_widths = c(4,4,4),
        value_box(
            title = "Cost of Goods Sold",
            value = textOutput("cost_of_goods_sold"),
            showcase = bsicons::bs_icon("currency-dollar"),
            theme = "danger"
          ),
        
        value_box(
            title = "Net Profit Margin",
            value = textOutput("net_profit_margin"),
            showcase = bsicons::bs_icon("highlights"),
            theme = "dark"
          ),
        
        value_box(
            title = "Taxes",
            value = textOutput("taxes"),
            showcase = bsicons::bs_icon("cash-coin"),
            theme = "success"
          )
        )
      )
   )
)


#define server
server <- function(input, output, session){
  
  #reactive data filtering
  filtered_data <- reactive({
    data <-  Finance_data
    
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