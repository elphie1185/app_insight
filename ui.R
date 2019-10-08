# Add theme
dashboardPage(
  skin = "black",
  dashboardHeader(title = span("App Insights", 
                               style = "color: black; font-size: 36px; font-weight: bold"), 
                  titleWidth = "400px"),
  
  dashboardSidebar(
    fluidRow(
      br(), br(), br(),
      checkboxGroupInput("Gender",
                         "Gender",
                         choices = c("M", "F", "U"),
                         selected = c("M", "F", "U"),
                         inline = TRUE)
    ),
    br(), br(), br(),
    fluidRow(
      checkboxGroupInput("Account",
                         "Type of Accounts",
                         choices = c("Current", "Credit Card", 
                                     "Savings", "Other"), 
                         selected = c("Current", "Credit Card", 
                                      "Savings", "Other"))
    )
    
  ),
  
  dashboardBody(
    tabBox(title =  "Select Visualisation",
           width = 12,
           
# ==============================================================================
#
# Tab 1 - USERS
#
# ==============================================================================
           
    tabPanel("Users Overview and Behaviour",
             fluidRow(
               column(6,
                      plotOutput("number_of_accounts")
                      ),
                      column(6,
                             plotOutput("number_of_transactions")
                      )
               ),
             fluidRow(
                      column(6,
                             plotOutput("number_of_logins")
                      ),
                      column(6,
                             plotOutput("users_no_account")
                      )
              )
    ),
           
# ==============================================================================
#
# Tab 2 -Institutions
#
# ==============================================================================
           
    tabPanel("Activity per Institution",
             fluidRow(
               column(3, 
                      selectInput(inputId = "institution_chosen",
                                  label = "Chose your Institutions",
                                  choices = unique(account$financial_institution),
                                  selected = "Barclays",
                                  multiple = TRUE)
               ),
               column(9,
                      plotOutput("institution", height = 750)
               )
             )
    ),
    
           
# ==============================================================================
#
# Tab 3 - Logins Overtime
#
# ==============================================================================
           
    tabPanel("Logins Overtime",
             fluidRow(
               column(4,
                      sliderInput(inputId = "duration",
                                  label = "Time of interest (days)",
                                  value = c(0, 60),
                                  min = 0, max = 3000)
              ),
              column(4,
                     selectInput(inputId = "x_value",
                                 label = "X axis Value",
                                 choices = c("time_from_reg", 
                                             "time_from_account_creation"),
                                 selected = "time_from_account_creation")
              ), 
              column(4, 
                     checkboxGroupInput("age",
                                        "Age Range",
                                        choices = c("Unknown", "<16", 
                                                    "16 to 24", "25 to 29", 
                                                    "30 to 39", "40 to 49", 
                                                    "50 to 59", "60 to 64",
                                                    "65+"), 
                                        selected = c("Unknown", "<16", 
                                                     "16 to 24", "25 to 29", 
                                                     "30 to 39", "40 to 49", 
                                                     "50 to 59", "60 to 64",
                                                     "65+"), 
                                        inline = TRUE))
            ), 
             fluidRow(
               column(12,
                      plotOutput("logs_overtime", height = 750)
                )
              )
          )
           
    )
  )
)



