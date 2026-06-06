setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Survey dashboard")
#load libraries
library(shiny)
library(bslib)
library(janitor)
library(tidyverse)
library(plotly)
library(paletteer)
library(sf)
library(leaflet)
library(rnaturalearth)

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
            plotOutput(
              "gender_plot",
              height = "250px"
            )
          )
        ),
        card(
          card_header("Employment Status"),
          card_body(
            plotOutput(
              "employment_plot",
              height = "250px"
            )
          )
        )
        ),
      
      # right column (with merged cards)
        card(
          card_header("Location Analysis"),
          card_body(
            leafletOutput(
              "map",
              height = "250px"
            )
          )
        )
      ),
      
      # 3rd row: 3 cards
      layout_columns(
        col_widths = c(4,4,4),
        card(
          card_header("Level of Qualification"),
          card_body(
            plotOutput(
              "highest_qualifications",
              height = "250px"
            )
          )
        ),
        card(
          card_header("Age Group"),
          card_body(
            plotOutput(
              "age_group_plot",
              height = "250px"
            )
          )
        ),
        card(
          card_header("Income Level"),
          card_body(
            plotOutput(
              "income_level",
              height = "250px"
            )
          )
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
          card_body(
            plotOutput(
              "acquisition_channel",
              width = "250px"
            )
          )
        ),
        card(
          card_header("% completed the course"),
          card_body(
            plotOutput(
              "course_complete",
              width = "250px"
            )
          )
        ),
        card(
          card_header("Most helpful content"),
          card_body(
            plotOutput(
              "helpful_content",
              width = "250px"
            )
          )
        )
      ),
      
      # 2nd row: 3 visualization cards
      layout_columns(
        col_widths = c(4, 4, 4),
        card(
          card_header("Level of satisfaction"),
          card_body(
            plotOutput(
              "satisfaction",
              width = "250px"
            )
          )
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
  output$gender_plot <- renderPlot({
    
    #aggregating count by gender
    gender_count <- filtered_data()%>%
      group_by(gender)%>%
      summarise(count = n_distinct(respondent_s_id))
    
    #create pie chart
    pie_chart <- gender_count%>%
      ggplot(aes(x = "", y = count, fill = gender))+
      geom_col(color = "white")+
      geom_text(aes(label = count), position = position_stack(vjust = 0.5))+
      coord_polar(theta = "y")+
      scale_fill_paletteer_d("wesanderson::Chevalier1")+
      theme_void()
    
    pie_chart
  
  })
    
    #employment status count
    output$employment_plot <- renderPlot({
      
      #aggregating count by gender
      employment_count <- filtered_data()%>%
        group_by(employment_status)%>%
        summarise(count = n_distinct(respondent_s_id))
      
      #ordering employment_status by count
      employment_count$employment_status <-reorder(employment_count$employment_status,
                                                   employment_count$count)
      
      #create bar chart
      employment_chart <- employment_count%>%
        ggplot(aes(y = employment_status, x = count))+
        geom_bar(stat = "identity", fill = "gray40")+
        geom_text(aes(label = count), position = position_stack(vjust = 1.08))+
        theme(
          panel.background = element_blank(),
          axis.title = element_blank(),
          axis.text = element_text(family = "serif",size = 12, color = "gray30"),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank()
        )
      
      employment_chart
    
  })
    
    #age_group count (frequency)
    output$age_group_plot <- renderPlot({
      
      #age_group_count
      age_group_count <- filtered_data()%>%
        group_by(age_group)%>%
        summarise(count = n_distinct(respondent_s_id))
      
      #ordering age_group by count
      age_group_count$age_group <- reorder(age_group_count$age_group,
                                           age_group_count$count)
      
      age_group_chart <- age_group_count%>%
        ggplot(aes(y = age_group, x = count))+
        geom_bar(stat = "identity", fill = "gray40")+
        geom_text(aes(label = count), position = position_stack(vjust = 1.08))+
        theme(panel.background = element_blank(),
              axis.title = element_blank(),
              axis.text = element_text(family = "serif",size = 12, color = "gray30"),
              axis.text.x = element_blank(),
              axis.ticks.x = element_blank()
              )
      
      age_group_chart
      
    })
    
    #highest qualification count
    output$highest_qualifications <- renderPlot({
      
      #creating bar chart on qualification
      qualification_count <- filtered_data()%>%
        group_by(highest_qualifications)%>%
        summarise(count = n_distinct(respondent_s_id))
      
      #reordering highest qualifications by count
      qualification_count$highest_qualifications <- reorder(qualification_count$highest_qualifications,
                                                            qualification_count$count)
      #qualifications plot
      qualification_plot <- qualification_count%>%
        ggplot(aes(y = highest_qualifications, x = count))+
        geom_bar(stat = "identity", fill = "gray40")+
        geom_text(aes(label = count), position = position_stack(vjust = 1.08))+
        theme(
          panel.background = element_blank(),
          axis.title = element_blank(),
          axis.text = element_text(family = "serif",size = 12, color = "gray30"),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank()
        )
      
      qualification_plot
      
    })
    
    #income level count
    output$income_level <- renderPlot({
      
      #income_level count
      income_count <- filtered_data()%>%
        group_by(income_level)%>%
        summarise(count = n_distinct(respondent_s_id))
      
      #reordering income_level by count
      income_count$income_level <- reorder(income_count$income_level,
                                           income_count$count)
      
      #creating plot on income_level frequency
      income_bar <- income_count%>%
        ggplot(aes(y = income_level, x = count))+
        geom_bar(stat = "identity", fill = "gray40")+
        geom_text(aes(label = count), position = position_stack(vjust = 1.08))+
        theme(
          panel.background = element_blank(),
          axis.title = element_blank(),
          axis.text = element_text(family = "serif",size = 12, color = "gray30"),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank()
        )
      
      income_bar
      
    })
    
    #mapping frequency (count) by country
    output$map <- renderLeaflet({
      
      #summarizing frequency by country
      country_freq<- survey_data%>%
        group_by(country)%>%
        summarise(count = n_distinct(respondent_s_id))
      
      #loading world polygons as sf
      world <- ne_countries(scale = "medium", returnclass = "sf")
      
      #joining frequency to world data
      world_freq <- world%>%
        left_join(country_freq, by = c("name"="country"))
      
      #computing centroids for bubble placement
      world_freq_centroids <- st_centroid(world_freq)
      
      #Creating bubble map in leaflet
      freq_map <- leaflet(world_sales_centroids) %>%
        addTiles() %>%
        addCircleMarkers(
          radius = ~sqrt(count) * 3,   # bubble size
          color = "brown",
          fillColor = "gold",
          fillOpacity = 0.7,
          weight = 1,
          popup = ~paste0("<b>", name, "</b><br>count: ", count)
        )
      
      freq_map
      
    })
    
    #Analyzing Quiz1 (customer acquisition channel)
    output$acquisition_channel <- renderPlot({
      #frequency by channel
      channel_count <- filtered_data2()%>%
        group_by(q1)%>%
        summarise(count = n_distinct(respondent_s_id))
      
      #reordering channel type by count
      channel_count$q1 <- reorder(channel_count$q1,
                                  channel_count$count)
      
      #creating plot on acquisition channel frequency
      channel_bar <- channel_count%>%
        ggplot(aes(y = q1, x = count))+
        geom_bar(stat = "identity", fill = "gray40")+
        geom_text(aes(label = count), position = position_stack(vjust = 1.08))+
        theme(
          panel.background = element_blank(),
          axis.title = element_blank(),
          axis.text = element_text(family = "serif",size = 12, color = "gray30"),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank()
        )
      
      channel_bar
      
    })
    
    #computing proportion of course complete
    output$course_complete <- renderPlot({
      
      #computing frequencies
      course_freq <- filtered_data2()%>%
        filter(Quiz_group == "Q2")%>%
        group_by(Quiz, Responses)%>%
        summarise(count = n_distinct(respondent_s_id))
      
      #creating plot
      course_completion_plot <- course_freq%>%
        ggplot(aes(y = Quiz, x = count, fill = Responses))+
        geom_bar(stat = "identity", position = "stack")+
        theme_minimal()
      
      course_completion_plot
      
    })
    
    #Computing the most helpful content
    output$helpful_content <- renderPlot({
      #computing frequency by content type
      content_freq <- filtered_data2() %>%
        filter(Quiz_group == "Q5")%>%
        group_by(Responses)%>%
        summarise(count = n_distinct(respondent_s_id))
      
      #Ordering frequency in descending order by response
      content_freq$Responses <- reorder(content_freq$Responses,
                                      content_freq$count)
      
      #creating the plot
      content_plot <- content_freq%>%
        ggplot(aes(y = Responses, x = count))+
        geom_bar(stat = "identity")+
        theme_minimal()
      
      content_plot
      
    })
    
    #visualizing level of satisfaction
    output$satisfaction <- renderPlot({
      #computing proportions by rating
      satisfaction_prop <- filtered_data2()%>%
        filter(Quiz_group == "Q3")%>%
        group_by(Quiz, Responses)%>%
        summarise(count = n_distinct(respondent_s_id))%>%
        mutate(percent = count/sum(count))
      
      #visualizing proportions of ratings
      satisfaction_chart <- satisfaction_prop%>%
        ggplot(aes(y = Quiz, x = percent, fill = Responses))+
        geom_bar(stat = "identity", position = "stack")+
        theme_minimal()
      
      satisfaction_chart
      
    })
    
    #visualizing material quality
    output$material_quality <- renderPlot({
      #computing proportions (ratings by material)
      prop_material <- filtered_data2()%>%
        filter(Quiz_group == "Q4")%>%
        group_by(Quiz, Responses)%>%
        summarise(count = n_distinct(respondent_s_id))%>%
        mutate(percent = count/sum(count))
      
      #visualizing proportions of ratings by material
      material_chart <- prop_material%>%
        ggplot(aes(y = Quiz, x = percent, fill = Responses))+
        geom_bar(stat = "identity", position = "stack")+
        theme_minimal()
      
      material_chart
      
    })
    
}


#run application
shinyApp(ui = ui, server = server)