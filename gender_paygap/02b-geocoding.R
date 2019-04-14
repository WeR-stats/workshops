#########################################
# UK GENDER PAY GAP - GEOCODE COMPANIES #
#########################################
# This step requires an API key that is available to anyone opening a billing account with the Google Maps platform
# As of 14-Mar-2019, the first $200 dollar accrued every month are free of charge

# load packages
pkgs <- c('data.table', 'mapsapi')
invisible(lapply(pkgs, require, character.only = TRUE))

# set constants
data_path <- './gender_paygap/data'
gm_key <- ''

# load dataset
if(file.exists(file.path(data_path, 'dts_geo.csv'))){
    gdts <- fread(file.path(data_path, 'dts_geo.csv'))
} else {
    gdts <- fread(file.path(data_path, 'dts.csv'), select = c('company_name', 'address', 'datefield'))
    gdts <- gdts[order(company_name, -datefield)][, datefield := NULL][, .SD[1], company_name]
    gdts[, `:=`(gaddress = NA_character_, x_lon = NA_real_, y_lat = NA_real_)]
}

# query google maps api for missing coordinates
for(idx in 1:nrow(gdts)){
    if(is.na(gdts[idx, x_lon])){
        adr <- gdts[idx, address]
        message('Geocoding company <', gdts[idx, company_name], '>, ', idx, ' out of ', nrow(gdts))
        tryCatch({
            lnlt <- mp_geocode(adr, region = 'uk', key = gm_key)
            lnlt <- mp_get_points(lnlt)
            gdts[idx, `:=`(gaddress = unlist(lnlt$address_google), x_lon = unlist(lnlt$pnt)[1], y_lat = unlist(lnlt$pnt)[2])]
        }, error = function(err) err)
    }
}

# test ....
# library(leaflet)
# library(htmltools)
# build_poly_label <- function(y){
#     HTML(paste0(
#         '<hr>',
#             '<b>Company</b>: ', y$company_name, '<br>',
#             '<b>Address gov.uk</b>: ', y$address, '<br>',
#             '<b>Address google</b>: ', y$gaddress, '<br>',
#         '<hr>'
#     ))
# }
# y <- gdts[!is.na(gaddress)]
# leaflet() %>%
#     addTiles() %>%
#     addMarkers(
#         data = y,
#         lng = ~x_lon, lat = ~y_lat,
#         label = lapply(1:nrow(y), function(x) build_poly_label(gdts[x]))
#     )

# extract postcode
gdts[, gaddress := gsub(', UK|, United Kingdom', '', gaddress)]
gdts[
    lengths(regmatches(gaddress, gregexpr(' ', gaddress))) == 2,
    gpostcode := sub('.*? (.+)', '\\1', gaddress)
]
gdts[    lengths(regmatches(gaddress, gregexpr(' ', gaddress))) > 2, gpostcode := paste0( 
            sub('.*\\s.*\\s', '', sub(' [^ ]+$', '', gaddress)), 
            sub('.*\\s.*\\s', '', gaddress)
)]
gdts[!grepl('[[:digit:]][[:alpha:]][[:alpha:]]$', gpostcode), gpostcode := NA]
gdts <- gdts[!is.na(gpostcode),  
    gpostcode := toupper(paste0(
        substr( paste0( substr( gpostcode, 1, nchar(gpostcode) - 3), '  '), 1, 4),
        substring(gpostcode, nchar(gpostcode) - 2)
    ))
]

# set correct missing value
gdts[gpostcode == '', `:=`(gaddress = NA, gpostcode = NA)]

# save datasets into data directory
fwrite(gdts[order(company_name)], file.path(data_path, 'dts_geo.csv'), row.names = FALSE)

## Clean and Exit ---------------------------------------------------------------------------------------------------------------
rm(list = ls())
gc()
