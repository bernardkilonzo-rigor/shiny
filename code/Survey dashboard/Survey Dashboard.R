setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Survey dashboard")
#load libraries
library(shiny)
library(bslib)
library(janitor)
library(tidyverse)
library(plotly)
library(paletteer)

#load data set
survey_data <-read.csv("https://raw.githubusercontent.com/bernardkilonzo-rigor/dataviz/main/data/Survey%20Data.csv")%>%
  clean_names()

#manipulating data (pivoting & grouping)
survey_data <- survey_data%>%
  pivot_longer(cols = c(q2a:q5_6), names_to = "Quiz", values_to = "Responses")%>%
  pivot_longer(cols = c(q6a:q6e), names_to = "Q6", values_to = "Values")%>%
  mutate(Quiz_group = 
           case_when(
             str_detect(Quiz, "^q2") ~ "Q2",
             str_detect(Quiz, "^q3") ~ "Q3",
             str_detect(Quiz, "^q4") ~ "Q4",
             str_detect(Quiz, "^q5") ~ "Q5",
             TRUE ~ "Others"
           ))

#define ui
ui <- page_navbar(
  title = "Survey Analysis Dashboard",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  # Demographic Tab
  nav_panel(
    title = "Demographic Dashboard",
    page_fillable(
      # left column
      layout_columns(
        col_widths = c(4, 8),
        row_heights = c(1,1),
        #left column with two stacked cards
        layout_columns(
          col_widths = 12,
          row_heights = c(1,1),
        card(
          card_header("Gender"),
          card_body(
            plotlyOutput(
              "gender_plot",
              height = "250px"
            )
          )
        ),
        card(
          card_header("Employment Status"),
          card_body(
            "employment_plot"
          )
        )
        ),
      
      # right column (with merged cards)
        card(
          card_header("Location Analysis"),
          card_body()
        )
      ),
      
      # 3rd row: 3 cards
      layout_columns(
        col_widths = c(4,4,4),
        card(
          card_header("Level of Qualification"),
          card_body()
        ),
        card(
          card_header("Age Group"),
          card_body()
        ),
        card(
          card_header("Income Level"),
          card_body()
        )
      )
    )
  ),
  
  # Survey Dashboard Tab
  nav_panel(
    title = "Survey Dashboard",
    page_sidebar(
      sidebar = sidebar(
        title = "Filters",
        open = "closed", #sidebar is hidden by default
        
        #Country filter
        selectInput(
          "country",
          "Select Country",
          choices = c("All", unique(survey_data$country))
        ),
        
        #Income level filter
        selectInput(
          "income_level",
          "Select Income",
          choices = c("All", unique(survey_data$income_level))
        ),
        
        #Education filter
        selectInput(
          "highest_qualifications",
          "Select Education",
          choices = c("All", unique(survey_data$highest_qualifications))
        ),
        
        #Gender filter
        selectInput(
          "gender",
          "Select Gender",
          choices = c("All", unique(survey_data$gender))
        ),
        
        #Employment filter
        selectInput(
          "employment_status",
          "Select Employment",
          choices = c("All", unique(survey_data$employment_status))
        ),
        
        #Age group filter
        selectInput(
          "age_group",
          "Select Age_Group",
          choices = c("All", unique(survey_data$age_group))
        )
        
      ),
      
      # Main content area
      # 1st row: 3 visualization cards
      layout_columns(
        col_widths = c(4, 4, 4),
        card(
          card_header("Customer acquisition channels"),
          card_body()
        ),
        card(
          card_header("% completed the course"),
          card_body()
        ),
        card(
          card_header("Most helpful content"),
          card_body()
        )
      ),
      
      # 2nd row: 3 visualization cards
      layout_columns(
        col_widths = c(4, 4, 4),
        card(
          card_header("Level of satisfaction"),
          card_body()
        ),
        card(
          card_header("Overall quality of materials"),
          card_body()
        ),
        card(
          card_header("Net Promoter Score (NPS)"),
          card_body()
        )
      )
    )
  )
)

#define server
server <- function(input, output, session){
  #reactive data 1
  filtered_data <- reactive({
    data <- survey_data
  })
  
  #reactive data 2 (with filters)
  filtered_data2 <- reactive({
    data <- survey_data
    
    #Filtering by Country
    if (!"All" %in% input$country && !is.null(input$country)) {
      data <- data[data$country %in% input$country, ]
    }
    
    #Filtering by Gender
    if (!"All" %in% input$gender && !is.null(input$gender)) {
      data <- data[data$gender %in% input$gender, ]
    }
    
    #Filtering by Income Level
    if (!"All" %in% input$income_level && !is.null(input$income_level)) {
      data <- data[data$income_level %in% input$income_level, ]
    }
    
    #Filtering by Highest Qualifications
    if (!"All" %in% input$highest_qualifications && !is.null(input$highest_qualification)) {
      data <- data[data$highest_qualification %in% input$highest_qualification, ]
    }
    
    #Filtering by Employment Status
    if (!"All" %in% input$employment_status && !is.null(input$employment_status)) {
      data <- data[data$employment_status %in% input$employment_status, ]
    }
    
    #Filtering by Age Group
    if (!"All" %in% input$age_group && !is.null(input$age_group)) {
      data <- data[data$age_group %in% input$age_group, ]
    }
    
    return(data)
    
  })
  
  #Gender count
  output$gender_plot <- renderPlotly({
    
    #aggregating count by gender
    gender_count <- filtered_data()%>%
      group_by(gender)%>%
      summarise(count = n_distinct(respondent_s_id))
    
    #create pie chart
    pie_chart <- gender_count%>%
      ggplot(aes(x = "", y = count, fill = gender))+
      geom_col(color = "white")+
      coord_polar(theta = "y")+
      scale_fill_paletteer_d("wesanderson::Chevalier1")+
      theme_void()
    
    #convert to plotly
    ggplotly(pie_chart)
  })
    
    #employment status count
    output$employment_plot <- renderPlotly({
      
      #aggregating count by gender
      employment_count <- filtered_data()%>%
        group_by(employment_status)%>%
        summarise(count = n_distinct(respondent_s_id))
      
      #create bar chart
      employment_chart <- employment_count%>%
        ggplot(aes(y = employment_status, x = count))+
        geom_bar(stat = "identity", fill = employment_status)+
        scale_fill_paletteer_d("wesanderson::Chevalier1")+
        theme_void()
      
      #convert to plotly
      ggplotly(employment_chart)
    
  })
}


#run application
shinyApp(ui = ui, server = server)