setwd("C:\\Users\\berna\\OneDrive\\Desktop\\Production\\shiny\\code\\Shiny app layouts")

#load libraries
library(shiny)
library(bslib)

#define ui
ui <- page_navbar(
  title = div(
    img(src = "https://static.wixstatic.com/media/e16c6a_9e0ce1add1bb4b6685e7ee2d45ed3509~mv2_d_7500_7500_s_4_2.png/v1/crop/x_1175,y_3213,w_5200,h_1013/fill/w_610,h_100,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/Original.png", 
        height = "40px", style = "margin-right: 10px;"),
    "Executive Dashboard"
  ),
  
  #spacer to push navigation items
  nav_spacer(),
  
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
  ),
  
  #spacer to push navigation items
  nav_spacer(),
  #custom theme with dark navigation bar
  theme = bs_theme(
    bootswatch = "flatly",
    primary = "#000000",
    navbar_bg = "#000000",
    navbar_fg = "white",
    navbar_hover_color = "gray40"
  ),
)
  
#define server
server <- function(input, output, session){
  
}
  
#run the application
shinyApp(ui = ui, server = server)
