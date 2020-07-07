library(shiny)
 
ui <- navbarPage(
  id = "Navig",
  "Test app",
  tabPanel("Home",
           fluidRow(
             column(1, ""),
             column(10,includeMarkdown("README.md")),
             column(1, "")
           )
           ),
  tabPanel("Contribute", 
           uiOutput("LoggedUser"))
)
Logged <- FALSE

userData <- data.frame(
  username = c("user1", "user2"),
  password = c("1234", "0123"),
  name = c("The App Admin", "A simple User"),
  admin = c(TRUE, FALSE),
  stringsAsFactors = FALSE
)

server <- function(input, output, session) {
  userLogin <- function (username, passwd, userData) {
    # HOLDER 
    User <- vector(mode = "list")
    
    # Combine  all user usernames and passwords to be a unique key
    # from the user data
    trueCredentials <- paste0(userData$username, userData$password)
    # Do the same for the user input
    userInput <- paste0(username, passwd)
    
    # Check if user exists 
    if (userInput %in% trueCredentials) {
      # Filter out the user data
      userInfo <- subset(userData, paste0(username, password) == userInput)
      User["exists"] = TRUE
      User["title"] = userInfo$name
      
      if (User$exists & userInfo$admin) {
        User["isAdmin"] = TRUE
      } else {
        User["isAdmin"] = FALSE
      }
    } else {
      User["exists"] = FALSE
    }
    
    return(User)
    
  }
  
  dataModal1 <- function() {
    modalDialog(
      helpText((strong(h3("Authentication"))), br()),
      wellPanel(
        textInput("username", "Username :"),
        passwordInput("userpasswd", "Password :")
      ),
      footer = fluidRow(
        column(
          6, "If you can't access, please contact us to have access !",
          em(strong("somemail@gmail.com"))
        ),
        column(
          3,
          modalButton("Close")
        ),
        column(
          3,
          actionButton("submitLogin", "Log In", class = "btn-primary")
        )
      ),
      fade = FALSE
    )
  }
  
  auth <- observe({
    if (isFALSE(Logged) & (input$Navig == "Contribute")) {
      showModal(dataModal1())
    }
  })
  
  observeEvent(input$submitLogin, {
    user <- userLogin(input$username, input$userpasswd, userData)
    if (user$exists) {
      Logged <- TRUE
      print(user)
      auth$suspend()
      removeModal()
      
      if (user$exists & !user$isAdmin) {
        output$LoggedUser <- renderUI({
          div(
            h2(paste("You are logged as", user$title)),
            actionButton("logout", "Log out"),
            tabPanel("Your space", 
                     "Here's what you will see.")
          )
        })
      } else if (user$exists & user$isAdmin) {
        # Code for admin users
        output$LoggedUser <-  renderUI({
            div(
          h2(paste("You are logged as", user$title)),
          actionButton("logout", "Log out"),
          tabsetPanel(
            tabPanel("Your space", 
                   "Here's what you will see."),
            tabPanel("What you can see as admin")
        )
        )
        })
      }
    }
  })
  
  observeEvent(input$logout, {
    Logged <- FALSE
    auth$resume()
    session$reload()
  })
}

shinyApp(ui, server)