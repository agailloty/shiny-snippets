# This scripts intends to show you how to get data from user input in Shiny
# Axel-Cleris Gailloty - 01/07/2020

library(shiny)
library(shinyjs)

ui <- fluidPage(
  shinyjs::useShinyjs(),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      div(
        id = "userForm",
        textInput("yourName", "Full name"),
        numericInput("yourAge", label = "Your age", min = 1, value = NA),
        radioButtons("knowShiny", choices = c("Yes", "No", "Kind of"), label = "Do you know Shiny"),
        sliderInput("yearsUseR", label = "Years using R", min = 0, max = 50, value = 0),
        checkboxInput("neverUsedR", label = "Never used R before", value = FALSE),
        actionButton("submitForm", label = "Submit", class = "btn-success")
      )
    ),
    mainPanel(
      tableOutput("filledForm")
    )
  )
)

srv <- function(input, output) {

  output$questionnaire <- renderUI({
    fieldsToFill
  })
  
  observeEvent(input$submitForm, {
    fieldsIDs <- c("yourName", "yourAge", "knowShiny", "yearsUseR", "neverUsedR")
    data <- reactive(sapply(fieldsIDs, function(x) input[[x]]))
    df <- as.data.frame(t(data())
    )
    colnames(df) <- c("Name", "Age", "Know Shiny ?", "Years Using R", "Don't know R")
    if ("responses" %in% ls()) {
      responses <<- rbind(responses, df)
      output$filledForm <- renderTable(responses)
    } else {
      responses <<- df
      output$filledForm <- renderTable(responses)
    }
    reset(id = "userForm")
  })
}

shinyApp(ui, srv)
