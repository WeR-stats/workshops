#############################################
# SHINYAPP TEMPLATE * MULTIPLE FILES * ui.R #
#############################################

# Define the UI for the app ----
ui <- fluidPage(theme = shinytheme("paper"),
    
    # comment the following once chosen the theme
    # shinythemes::themeSelector(),
    
    # app title
    titlePanel('UK Gender Paygap'),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
    
        # Sidebar panel to be filled with input controls ----
        sidebarPanel(
        
            # 
            radioGroupButtons('cbo_year', 'YEAR:',  choices = sort(unique(dts$datefield)), status = 'primary', selected = max(dts$datefield)),

            # 
            pickerInput('cbo_geo_type', 
                'GEOGRAPHY:', 
                choices = cols_geo,
                selected = 'LAD', 
                multiple = FALSE,
                options = list(size = 9, `actions-box` = TRUE, `live-search` = FALSE, `header` = 'Select ONE item only')
            ),
            
            # 
            uiOutput('ui_geo_area'),

            # 
            pickerInput('cbo_size', 
                'SIZE:', 
                choices = sizes,
                multiple = TRUE,
                options = list(size = 6, `actions-box` = TRUE, `live-search` = FALSE, `header` = 'Select one or more item(s)')
            ),
          
            # 
            pickerInput('cbo_section', 
                'SECTION:', 
                choices = sections,
                multiple = TRUE,
                options = list(size = 10, `actions-box` = TRUE, `live-search` = FALSE, `header` = 'Select one or more item(s)')
            ),
          
            hr(),
            
            # METRIC
            pickerInput('cbo_metric', 
                'METRIC:', 
                choices = metrics,
                multiple = FALSE,
                options = list(size = 10, `actions-box` = FALSE, `live-search` = TRUE, `header` = 'Select ONE item only')
            )
          
      ),
    
      # Main panel for displaying outputs ----
      mainPanel(
      
          # Output: Placeholder that will be filled with the object built in the SERVER side ----
          plotOutput(outputId = 'my_plot')
          
      )
    
    )
  
)
