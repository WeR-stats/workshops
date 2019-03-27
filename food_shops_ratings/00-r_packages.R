pkgs <- c(
    # data I/O and wrangling 
    'data.table', 'fst', 'htmltools', 'rvest', 'XML',
    # data display
    'DT', 'formattable', 'rhandsontable', 'rpivotTable', 
    'flextable', 'htmlTable', 'knitr', 'kableExtra', 'huxtable', 'pixiedust', 'basictabler',
    # data visualization
    'ggplot2', 'ggiraph', 'ggspatial', 'ggthemes', 'tmap',
    'htmlwidgets', 'leaflet', 'leaflet.extras', 'rbokeh', 'mapview',
    'RColorBrewer', 'scico', 'viridis',
     'classInt', 'scales',
    # data presentation
    'rmarkdown', 'shiny', 'shinyjs', 'shinyWidgets',
    # spatial tools
    'dggridR', 'rgdal', 'rgeos', 'rmapshaper', 'sp'
)
pkgs.not <- pkgs[!sapply(pkgs, require, char = TRUE)]
if(length(pkgs.not) > 0) install.packages(pkgs.not)
lapply(pkgs, require, char = TRUE)
