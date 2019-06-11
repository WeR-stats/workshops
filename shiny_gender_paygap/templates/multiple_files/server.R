#################################################
# SHINYAPP TEMPLATE * MULTIPLE FILES * server.R #
#################################################

# Define server logic required to build the objects to fill the placeholder(s) defined in the UI ----
server <- function(input, output) {

### DYNAMIC CONTROLS --------------------------------------------------------------------------------------------------------------------------------

# Select area depending on chosen geo type
output$ui_geo_area <- renderUI({
    if(length(input$cbo_geo_type) == 0) return()
    pickerInput('cbo_geo_area', 
        toupper(names(cols_geo)[which(cols_geo == input$cbo_geo_type)]), 
        choices = get_geo_areas(input$cbo_geo_type), 
        selected = 'None', 
        multiple = TRUE,
        options = list(size = 15, `actions-box` = TRUE, `live-search` = TRUE, `header` = 'Select one or more item(s)')
    )
})
    
    
    
    
    
    # Ancillary code necessary to build more than one output object
    varname <- reactive({
      
    })
  
    # Generates the output to be placed in the space called "my_plot" built in the UI part
    # It is "reactive" by definition, and therefore should be automatically re-executed when inputs (input$bins) change
    output$my_plot <- renderPlot({
        # If this code uses reactive objects, they need to be followed by (empty) parenthesis as in a normal function call
      
    })

}
