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
        "Your app settings allow users to customize their experience by choosing the theme (light, dark, or system), selecting the preferred language, setting a default landing page, and resetting the app to its original state; configuring data options such as selecting the data source, enabling auto‑refresh, uploading CSV or Excel files, and applying automatic data cleaning; adjusting user preferences like default region, date range, chart type, and visibility of advanced options; optimizing performance through caching, row limits, plot quality, and async loading; managing access with user roles, password protection, API keys, and visibility of sensitive metrics; controlling notifications including email alerts, thresholds, daily summaries, and sound cues; personalizing appearance through card density, font size, sidebar position, and scrollbars; defining reporting defaults such as export format, logo inclusion, theme, and page size; and configuring AI features like enabling summaries, selecting the model type, adjusting temperature and token limits, and uploading documents for knowledge‑based responses."
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
