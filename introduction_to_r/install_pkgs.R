pkgs <- c('data.table', 'dplyr', 'gapminder', 'ggplot2', 'ggthemes', 'jsonlite', 'nycflights13', 'RColorBrewer', 'readr', 'readxl', 'sqldf')
install.packages(pkgs)
lapply(pkgs, require, char = TRUE)
