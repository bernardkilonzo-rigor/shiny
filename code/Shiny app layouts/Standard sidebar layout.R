setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Shiny app layouts")

#load libraries
library(shiny)
library(bslib)

#define ui
ui <- page_navbar(
  title = "My Dashboard",
  theme = bs_theme(
    bootswatch = "flatly",
    primary = "#000000",
    navbar_bg = "#000000",
    navbar_fg = "white",
    navbar_hover_color = "#e8f0fe"
  ),
  
  # ---- NAV ITEMS ----
  nav("Dashboard",
      page_sidebar(
        sidebar = sidebar(
          title = "Filters"
        ),
        collapsible = FALSE,
        
        # main content
        layout_columns(
          col_widths = c(3,3,3,3),
          card(), card(), card(), card()
        ),
        layout_columns(
          col_widths = c(4,4,4),
          card(), card(), card()
        ),
        layout_columns(
          col_widths = c(6,6),
          card(), card()
        )
      )
  ),
  
  nav("Reports",
      card(
        full_screen = TRUE,
        card_header("Reports Section"),
        "Add report content here"
      )
  ),
  
  nav("Settings",
      card(
        full_screen = TRUE,
        card_header("Settings"),
        "Settings content goes here"
      )
  )
)
  
#define server
server <- function(input, output, session){
  
}
  
#run the application
shinyApp(ui = ui, server = server)
