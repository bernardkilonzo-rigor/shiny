setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Superstore dashboard")
library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(plotly)
library(lubridate)

#load data set
superstore<-read.csv("https://raw.githubusercontent.com/bernardkilonzo-rigor/dataviz/main/data/Sample%20-%20Superstore.csv")
superstore$Order.Date<-as.Date(superstore$Order.Date, format = "%d/%m/%Y")

# Define UI
ui <- page_navbar(
  title = div(
    img(src = "https://static.wixstatic.com/media/e16c6a_9e0ce1add1bb4b6685e7ee2d45ed3509~mv2_d_7500_7500_s_4_2.png/v1/crop/x_1175,y_3213,w_5200,h_1013/fill/w_610,h_100,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/Original.png", 
        height = "40px", style = "margin-right: 10px;"),
    "SALES OVERVIEW"
  ),
  
  # Spacer to center the tabs
  nav_spacer(),
  
  # First tab in the center
  nav_panel(
    title = "",
      page_sidebar(
    sidebar = sidebar(
      title = "Filters",
      dateRangeInput(
        "Order.Date",
        "Select Order Date",
        start = min(superstore$Order.Date),
        end = max(superstore$Order.Date),
        format = "M-yy",
        separator = "to"
      ),
      selectInput(
        "Category",
        "Select Category",
        choices = c("All",unique(superstore$Category)),
        selected = "All"
      ),
      selectInput(
        "Segment",
        "Select Segment",
        choices = c("All", unique(superstore$Segment)),
        selected = "All"
      ),
      selectInput(
        "Region",
        "Select Region",
        choices = c("All", unique(superstore$Region)),
        selected = "All"
      )
      ),
    #1st row cards
    layout_columns(
      col_widths = c(4,4,4),
      value_box(
        title = "Total Sales",
        value = tags$div(textOutput("total_sales"),style = "font-size: 150%;"),
        showcase = icon("dollar-sign"),
        theme = "text-info"
      ),
      value_box(
        title = "Number of Orders",
        value = tags$div(textOutput("total_orders"), style = "font-size: 150%;"),
        showcase = icon("cart-shopping"),
        theme = "text-warning"
      ),
      value_box(
        title = "AOV",
        value = tags$div(textOutput("aov"), style = "font-size: 150%;"),
        showcase = icon("sack-dollar"),
        theme = "text-success"
      )
    ),
    
    #2nd row  cards
    layout_columns(
      col_widths = c(8,4),
      card(card_header("Daily Sales"),
           card_body(plotlyOutput("daily_sales",
                                  height = "250px")
           )),
      
      card(card_header("Top 5 Sub.Categories"),
           card_body(plotlyOutput("top_five",
                                  height = "250px")
           ))
    ),
    
    #3rd row card
    layout_columns(
      col_widths = 12,
      card(card_header("Top Five Customers"),
           card_body(tableOutput("top_customers")
           ))
    )
  )),
  
  # Spacer to push information icon to the right
  nav_spacer(),
  
  # Information icon positioned on the far right
  nav_item(
    tags$a(
      icon("info-circle"),
      href = "#",
      onclick = "alert('At Rigor Data Solutions, we support you unleash the true power of your data and automate internal processes through modern business intelligence and analytics solutions. Our projects are designed, developed, and deployed by experienced professionals who are tested and certified in their respective fields. With almost a decade of unparalleled experience in building data analytics and visualization solutions, we bring expertise, professionalism, and passion for turning complexity into clarity.');",
      style = "color: #ffffff; font-size: 18px; padding: 8px;",
      title = "App Information"
    )
  ),
  
  # Custom theme with dark navigation bar
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly",
    # Customize navbar colors
    navbar_bg = "#000000",  # Dark blue-gray background
    navbar_fg = "#ffffff",  # White text
    primary = "#3498db"     # Blue accent color
  )
)

# Define server logic
server <- function(input, output, session) {
  
  #Reactive data filtering
  
  filtered_data<- reactive({
    data<-superstore
    
    #Filtering by Order Date
    if (!is.null(input$Order.Date)) {
      data <- data[data$Order.Date >= input$Order.Date[1] & data$Order.Date <= input$Order.Date[2], ]
    }
    
    #Filtering by Category
    if (!"All" %in% input$Category && !is.null(input$Category)) {
      data <- data[data$Category %in% input$Category, ]
    }
    
    #Filtering by Segment
    if (!"All" %in% input$Segment && !is.null(input$Segment)) {
      data <- data[data$Segment %in% input$Segment, ]
    }
    
    #Filtering by Region
    if (!"All" %in% input$Region && !is.null(input$Region)) {
      data <- data[data$Region %in% input$Region, ]
    }
    
    return(data)
  })
  
  # Value box outputs
  output$total_sales <- renderText({
    paste0("$", format(round(sum(filtered_data()$Sales)), big.mark = ","))
  })
  
  output$total_orders<- renderText({
    format(n_distinct(filtered_data()$Order.ID), big.mark =",")
  })
  
  output$aov <-renderText({
    paste0("$", format(round(sum(filtered_data()$Sales)/n_distinct(filtered_data()$Order.ID)), big.mark = ","))
  })
  
  #create area chart
  output$daily_sales <- renderPlotly({
    
    area_chart<-filtered_data()%>%
      mutate(day = day(Order.Date))%>%
      group_by(day)%>%
      summarise(sales =round(sum(Sales),0))%>%
      ggplot(aes(x = day, y = sales, text =paste("Day","",day,":", sales), group = 1))+
      geom_area(stat = "identity", color ="steelblue", fill ="lightblue",linewidth =0.3)+
      labs(x = "Day", y = "Sales")+
      theme(panel.background = element_blank(),
            axis.title = element_text(family = "serif", size = 10, color = "gray30"),
            axis.text = element_text(family = "serif", size = 9, color = "gray30"))
    
    #convert to plotly chart
    ggplotly(area_chart, tooltip = "text")
    
    })
  
  #create top 5 sub-categories by sales
  output$top_five <- renderPlotly({
    #aggregating sales to select the top sub-categories
    top_n<-filtered_data()%>%
      group_by(Sub.Category)%>%
      summarise(tot_sales = round(sum(Sales),0))%>%
      arrange(desc(tot_sales))%>%
      slice_head(n =5)
    
    #create the plot
    bar_plot<-top_n%>%
      ggplot(aes(y = reorder(Sub.Category, tot_sales), x =tot_sales, text =paste(Sub.Category,":", tot_sales)))+
      geom_bar(stat ="identity", fill ="#3ac7ab", width = 0.6)+
      theme(panel.background = element_blank(),
            axis.text.x = element_blank(),
            axis.title.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.title.y = element_blank())
    
    #convert to plotly chart
    ggplotly(bar_plot, tooltip = "text")
    
  })
  
  output$top_customers <- renderTable({
    filtered_data()%>%
      group_by(Customer.Name,State,City)%>%
      summarise(
        Sales = sum(Sales),
        Profit = sum(Profit),
        Quantity = sum(Quantity),
      Avg.Discount = mean(Discount),
        Orders = n_distinct(Order.ID),
        .groups = "drop"
      )%>%
      arrange(desc(Sales))%>%
      slice_head( n = 5)
  })
}

# Run the application
shinyApp(ui = ui, server = server)