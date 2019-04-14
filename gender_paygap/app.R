#################################################
# UK FOOD HYGIENE RATING - DYNAMIC DATA DISPLAY #
#################################################

# load packages
pkgs <- c('classInt', 'data.table', 'DT', 'fst', 'RColorBrewer', 'shinyWidgets')
invisible(lapply(pkgs, require, character.only = TRUE))

# set constants
data_path <- './data'

# define functions
create_table <- function(lad_ids){
        y <- dcast(shops[lad_id %in% lad_ids ], sector~ratingn)
        ym <- shops[, .(avg = mean(ratingn, na.rm = TRUE)), sector]
        y <- ym[y, on = 'sector']
        setorder(y, 'sector')
        y <- cbind(y, rowSums(y[, as.character(0:5), with = FALSE]) )
            
        dt <- datatable( 
                y, 
                rownames = FALSE ,
                colnames = c('Sector', 'Rating', 0:5, 'Total'),
                selection = 'none',
                class = 'cell-border nowrap',
                extensions = c('Buttons', 'FixedColumns', 'Scroller'),
                options = list(
                    scrollX = TRUE,
                    scrollY = 800,
                    scroller = TRUE,
                    fixedColumns = list(leftColumns = 1),
                    searchHighlight = TRUE,
                    buttons = c('copy', 'csv', 'print'),
                    ordering = TRUE,
                    columnDefs = list(list(className = 'dt-center', targets = 1)),
                    deferRender = TRUE,
                        initComplete = JS(
                            "function(settings, json) {",
                                "$(this.api().table().header()).css({
                                    'text-align': 'center',
                                    'background-color': '#000000', 
                                    'color': '#F2FF00',
                                    'font-size': '130%'
                                });",
                            "}"
                        ),
                    dom = 'Biftp'
                ) 
            ) 
        
        n_cls <- 9
        v_cls <- classIntervals(y$avg, n_cls)[[2]][2:n_cls]
        dt <- dt %>% 
                formatStyle('avg', 
                    `font-weight` = '600',
                    backgroundColor = styleInterval(v_cls , brewer.pal(9, 'OrRd')),
                    color = styleInterval( v_cls, c(rep('black', 6), rep('white', 3))) 
                )
        dt <- dt %>% formatCurrency('avg', '', digits = 3) %>% formatCurrency(as.character(0:5), '', digits = 0)
        bars_col <- c('orangered', 'darkorange', 'gold', 'paleturquoise', 'lightskyblue', 'palegreen')
        for(idx in as.character(0:5))
            dt <- dt %>% 
                formatStyle(idx,
                   background = styleColorBar( y[, get(idx)], bars_col[as.numeric(idx) + 1] ),
                   backgroundSize = '90% 75%',
                   backgroundRepeat = 'no-repeat',
                   backgroundPosition = 'center'
                )
        
        dt
}

# load data
lads <- fread(file.path(data_path, 'lads.csv'))
shops <- read.fst(file.path(data_path, 'shops'), as.data.table = TRUE)
shops <- shops[as.numeric(rating) <= 6, ratingn := as.numeric(rating) - 1]
oas <- read.fst(file.path(data_path, 'output_areas'), as.data.table = TRUE)
lcn <- read.fst(file.path(data_path, 'locations'), as.data.table = TRUE)

#create list for input control
y <- lads[, .(lad_id, name)][order(name)]
lst_lads <- as.list(sort(y$lad_id))
names(lst_lads) <- paste(y$name)

# Define UI for dataset viewer app ----
ui <- fluidPage(

  # App title ----
  titlePanel("Food Shop Rating"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Selector for choosing dataset ----
        pickerInput(
                inputId = 'cbo_lads', 
                label = 'Local Authority:',
                choices = lst_lads,
                multiple = TRUE, 
                options = list(size = 15, `actions-box` = TRUE, `live-search` = TRUE, `header` = 'Select one or more items')
        )

    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: HTML table with requested number of observations ----
      dataTableOutput('out_tbl')

    )
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {

  output$out_tbl <- renderDataTable({
    create_table(input$cbo_lads)
  })

}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
