# This script intends to show you how to trigger a download without explicitly clicking the
# download button
# Axel-Cleris Gailloty - 01/07/2020


library(shiny)
library(shinyjs) 

ui <- fluidPage(
  # Tell Shiny to use shinyjs
  shinyjs::useShinyjs(), 
  
  sidebarLayout(
    sidebarPanel(
      
    )
  )
)

srv <- function(input, output, session ) {
  
}

shinyApp(ui, srv)