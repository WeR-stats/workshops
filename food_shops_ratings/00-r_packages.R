pkgs <- c(
    # data I/O
    'fst', 'rvest', 'XML',
    # data manipulation and wrangling
    'classInt', 'data.table', 'scales',
    # data display
    'DT', 'kableExtra', 'knitr',
    # data visualization
    'ggplot2', 'ggiraph', 'ggspatial', 'ggthemes', 'htmlwidgets', 'leaflet', 'leaflet.extras', 'rbokeh', 'RColorBrewer', 'scico', 'tmap', 'viridis',
    # data presentation
    'rmarkdown', 'shiny',
    # tools and utilities
    'htmltools', 'rgdal', 'rgeos', 'rmapshaper', 'sp'
)
pkgs.not <- pkgs[!sapply(pkgs, require, char = TRUE)]
if(length(pkgs.not) > 0) install.packages(pkgs.not)
lapply(pkgs, require, char = TRUE)
