########################################################
# SHINYAPP TEMPLATE * MULTIPLE DIRS * LOGIN - ui_lgn.R #
########################################################

tabPanel('LOGIN', icon = icon('user'),

    fluidRow(
        column(3,
            wellPanel(
                
                tags$h3('Please sign in...'), class = 'well-lgn',
                
                # if USER$Logged == FALSE: Enter Credentials for access, TRUE: hide 
                textInput('lgn_usr', 'USER NAME:', value = '', placeholder = 'enter your user name here...'),
                passwordInput('lgn_pwd', 'PASSWORD:', value = '', placeholder = 'enter your password here...'),
                
                # If USER$Logged == TRUE: Display which user name is connected, FALSE: hide
                textInput('lgn_txt', '', ''),
                
                # Button for log in/out. If user/pwd are correct: show all tabs, change venue lists, move to TABLES
                actionButton('lgn_btn', 'ACCESS DATA', icon = icon('key'))
                
            ),
            
            offset = 4
        )
    )
    
)
