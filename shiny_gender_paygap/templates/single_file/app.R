# Calls for packages and objects common to both ui and server
library(shiny)


# Define the UI for the app ----
ui <- fluidPage(

    # App title ----
    titlePanel('My App Title'),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
    
      # Sidebar panel to be filled with input controls ----
      sidebarPanel(
      
          # Input: Slider for the number of bins ----
          sliderInput(inputId = "bins", 
              label = "Number of bins:",
              min = 1,
              max = 50,
              value = 30
          )
          
      ),
    
      # Main panel for displaying outputs ----
      mainPanel(
      
          # Output: Placeholder that will be filled with the object built in the SERVER side ----
          plotOutput(outputId = 'my_plot')
          
      )
    
    )
  
)

# Define server logic required to build the objects to fill the placeholder(s) defined in the UI ----
server <- function(input, output) {

    # Ancillary code necessary to build more than one output object
    varname <- reactive({
      
    })
  
    # Generates the output to be placed in the space called "my_plot" built in the UI part
    # It is "reactive" by definition, and therefore should be automatically re-executed when inputs (input$bins) change
    output$my_plot <- renderPlot({
        # If this code uses reactive objects, they need to be followed by (empty) parenthesis as in a normal function call
      
    })

}

# Launch the app
shinyApp(ui = ui, server = server)
