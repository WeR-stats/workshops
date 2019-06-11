### Calls for packages and objects common to both ui and server -----------------------------------------------------------------

# load packages ------
pkgs <- c(
    # DATA WRANGLING, UTILITIES
    'classInt', 'data.table', 'fst', 'htmltools', 'scales',
    'bcrypt', 'crosstalk', 'htmltools', 'htmlwidgets',
    # DATA DISPLAY
    'DT', 'extrafont', 'formattable', 'kableExtra', 'rhandsontable', 'rpivotTable',
    # DATA VIZ
    'ggplot2', 'geofacet', 'GGally', 'ggiraph', 'ggmosaic', 'ggparallel', 'ggrepel', 'ggridges', 'ggthemes',
    'dygraphs', 'echarts4r', 'plotly', 'rbokeh', 'scatterD3', 'trelliscopejs', 'wordcloud2',
    'leaflet', 'leaflet.extras', 'leaflet.opacity', 'mapview', 'tmap',
    'Cairo', 'dichromat', 'extrafont', 'RColorBrewer', 'scico', 'viridis', 'wesanderson',
    # SHINY
    'shiny', 'rmarkdown', 'shinycssloaders', 'shinycustomloader', 'shinyjqui', 'shinyjs', 'shinyWidgets',
    'bs4Dash', 'flexdashboard', 'shinydashboard',
    'bsplus', 'colourpicker', 'fontawesome', 'rintrojs', 'shinymaterial', 'shinythemes'
)
lapply(pkgs, require, char = TRUE)


# load data ------
data_path <- '../../data'
dts <- read_fst(file.path(data_path, 'dataset'), as.data.table = TRUE)
mtcs <- fread(file.path(data_path, 'metrics.csv'))
lcn <- read_fst(file.path(data_path, 'locations'), as.data.table = TRUE)
bnd <- readRDS(file.path(data_path, 'boundaries'))

### Define the UI for the app ---------------------------------------------------------------------------------------------------
ui <- fluidPage(

    # App title ----
    titlePanel('UK Gender Paygap'),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
    
      # Sidebar panel to be filled with input controls ----
      sidebarPanel(
      
          # Input: Slider for the number of bins ----

      ),
    
      # Main panel for displaying outputs ----
      mainPanel(
      
          # Output: Placeholder that will be filled with the object built in the SERVER side ----------------
          plotOutput(outputId = 'my_plot')
          
      )
    
    )
  
)

### Define server logic required to build the objects to fill the placeholder(s) defined in the UI ------------------------------
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
