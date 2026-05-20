setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Survey dashboard")
#load libraries
library(shiny)
library(bslib)
library(janitor)
library(tidyverse)

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
          card_body()
        ),
        card(
          card_header("Employment Status"),
          card_body()
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
  
}


#run application
shinyApp(ui = ui, server = server)



