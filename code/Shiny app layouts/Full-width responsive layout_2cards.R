setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Shiny app layouts")

#load libraries
library(shiny)
library(bslib)

ui <- page_navbar(
  title = "Executive Sales Dashboard",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  nav_panel(
    NULL, #hides tab label
  page_fillable(
  #1st row: 2 cards
  layout_columns(
    col_widths = c(3,9),
    card(
      # ---- Paragraph 1 ----
      p("At Rigor Data Solutions, we support you unleash the true power of your data and automate internal processes through modern business intelligence and analytics solutions. Our projects are designed, developed, and deployed by experienced professionals who are tested and certified in their respective fields.
        With almost a decade of unparalleled experience in building data analytics and visualization solutions, we bring expertise, professionalism, and passion for turning complexity into clarity."),
      
      # ---- Filter Input ----
      selectInput(
        inputId = "region",
        label = "Select Region",
        choices = c("Nairobi", "Mombasa", "Kisumu","Nakuru","Eldoret"),
        width = "100%"
      ),
      
      # ----- Paragraph 2 -----
      p(
        "At Rigor Data Solutions, we prioritize quality above all else. Our commitment is to deliver exceptional results that exceed your expectations. View some of our sample visualization below."
      )
    ),
    card()
  )
)
)
)

#define server
server <- function(input, output, session){
  
}

#run the application
shinyApp(ui = ui, server = server)