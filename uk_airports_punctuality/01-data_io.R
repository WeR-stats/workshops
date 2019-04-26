######################################
# UK AIRPORTS PUNCTUALITY - DATA I/O #
######################################

## PREPARATION ------------------------------------------------------------------------------------------------------------------

# load packages
pkgs <- c('data.table', 'rvest')
invisible(lapply(pkgs, require, character.only = TRUE))

# set constants
data_path <- './uk_airports_punctuality/data'
url_home <- 'https://www.caa.co.uk'
url_pref <- paste0(url_home, '/Data-and-analysis/UK-aviation-market/Flight-reliability/Datasets/Punctuality-data/Punctuality-statistics-')

# load data
vars <- fread(file.path(data_path, 'vars.csv'))

## MAIN DATASET -----------------------------------------------------------------------------------------------------------------

# create empty dataset
dts <- setnames( data.table(matrix(nrow = 0, ncol = nrow(vars))), vars$code)

# download data
for(x in 1990:2018){

    # read list of files
    fnames <- read_html(paste0(url_pref, x)) %>%
                html_nodes('#ctl00_cphBody_dzMain_uxColumnDisplay_ctl00_uxControlColumn_ctl01_uxWidgetHost_uxUpdatePanel a') %>% 
                html_attr('href')
    
    # separates "good" ones
    fnames <- fnames[grepl('arr|dep', tolower(fnames))]

    # read all files, and bind them in dataset
    for(fn in fnames){
        y <- fread(paste0(url_home, fn), select = vars$name, col.names = vars$code, na.strings = '')
        dts <- rbindlist(list( dts, y ))
    }

}

# convert to factor
cols <- vars[type == 'f', code]
dts[, (cols) := lapply(.SD, factor), .SDcols = cols]

# find total flights, then convert percent into counting
dts[, n_flights := n_matched + n_unmatched + n_cancelled]

# save final dataset

## Clean and Exit ---------------------------------------------------------------------------------------------------------------
rm(list = ls())
gc()

