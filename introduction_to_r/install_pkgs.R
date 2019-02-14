pkgs <- c(
    # datasets
    'gapminder', 'nycflights13',
    # data I/O
    'readr', 'readxl',
    # data manipulation
    'scales', 'xts',
    # data wrangling
    'data.table', 'dplyr', 'jsonlite', 'sqldf', 'tidyr',
    # data display
    'kableExtra', 'knitr',
    # data visualization
    'dygraphs', 'ggplot2', 'ggthemes', 'htmlwidgets', 'leaflet', 'RColorBrewer', 'viridis',
    # tools and utilities
    'htmltools'
)
pkgs.not <- pkgs[!sapply(pkgs, require, char = TRUE)]
if(length(pkgs.not) > 0) install.packages(pkgs.not)
lapply(pkgs, require, char = TRUE)
