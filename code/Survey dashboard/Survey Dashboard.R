setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Survey dashboard")
#load libraries
library(shiny)
library(bslib)
library(janitor)

#load data set
survey_data <-read.csv("https://raw.githubusercontent.com/bernardkilonzo-rigor/dataviz/main/data/Survey%20Data.csv")%>%
  clean_names()

#define ui
ui <- page_navbar(
  title = "Survey Analysis Dashboard",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  # Demographic Tab
  nav_panel(
    title = "Demographic Dashboard",
    page_fillable(
      # 1st row: 3 cards for demographic overview
      layout_columns(
        col_widths = c(4, 4, 4),
        card(
          card_header(),
          card_body()
        ),
        card(
          card_header(),
          card_body()
        ),
        card(
          card_header(),
          card_body()
        )
      ),
      
      # 2nd row: 2 larger cards
      layout_columns(
        col_widths = c(6, 6),
        card(
          card_header(),
          card_body()
        ),
        card(
          card_header(),
          card_body()
        )
      ),
      
      # 3rd row: 1 full-width card
      layout_columns(
        col_widths = 12,
        card(
          card_header(),
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
      # 1st row: 4 metric cards
      layout_columns(
        col_widths = c(3, 3, 3, 3),
        card(
          card_header(),
          card_body()
        ),
        card(
          card_header(),
          card_body()
        ),
        card(
          card_header(),
          card_body()
        ),
        card(
          card_header(),
          card_body()
        )
      ),
      
      # 2nd row: 3 visualization cards
      layout_columns(
        col_widths = c(4, 4, 4),
        card(
          card_header(),
          card_body()
        ),
        card(
          card_header(),
          card_body()
        ),
        card(
          card_header(),
          card_body()
        )
      ),
      
      # 3rd row: 2 detailed analysis cards
      layout_columns(
        col_widths = c(6, 6),
        card(
          card_header(),
          card_body()
        ),
        card(
          card_header(),
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



