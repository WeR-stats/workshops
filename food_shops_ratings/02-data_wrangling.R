###########################################
# UK FOOD HYGIENE RATING - DATA WRANGLING #
###########################################

# load packages
pkgs <- c('data.table', 'fst')
invisible(lapply(pkgs, require, character.only = TRUE))

# set constants
data_path <- './food_shops_ratings/data'

# load data
lads <- fread(file.path(data_path, 'lads_pre.csv'))
shops <- read.fst(file.path(data_path, 'shops_pre'), as.data.table = TRUE)

# Checking missing values by variable
sapply(names(shops), function(x) shops[is.na(get(x)), .N])

# Cleaning and recoding postcodes to 7-chars form
shops[, postcode := gsub(' ', '', postcode)]
shops[!grepl("[[:digit:]][[:alpha:]][[:alpha:]]$", postcode), postcode := NA]
shops[nchar(postcode) < 5 | nchar(postcode) > 7, postcode := NA]
shops[nchar(postcode) == 5, postcode := paste0(substr(postcode, 1, 2), '  ', substring(postcode, 3))]
shops[nchar(postcode) == 6, postcode := paste(substr(postcode, 1, 3), substring(postcode, 4))]

# Recoding text ratings as numeric
shops[, rating := tolower(gsub(' ', '', rating))]
shops[rating == 'awaitinginspection', rating := '7']
shops[rating == 'awaitingpublication', rating := '8']
shops[rating == 'exempt', rating := '9']
shops[rating == 'passandeatsafe', rating := '13']
shops[rating == 'pass', rating := '12']
shops[rating == 'improvementrequired', rating := '11']

# Casting "updated_at" as "Date" and "rating" as "numeric"
shops[, `:=`( updated_at = as.Date(updated_at), rating = as.numeric(rating) )]

# Add an updated field formated in different way
shops[, updated_at_fmt := format(updated_at, '%d %b %Y')]

# Preparing dataset for sectors
setkey(shops, sector_id)
dts <- shops[, .N, .(sector_id, name = sector, rating = rating)][order(sector_id, rating)]
dts <- dcast.data.table(dts, sector_id + name ~ paste0('R', ifelse(rating < 10, '0', ''), rating), fill = 0)
dts <- dts[shops[, .(tot_shops = .N), sector_id]]
fwrite(dts, file.path(data_path, 'sectors.csv'), row.names = FALSE)

# Preparing dataset for lads
lads[, url := NULL]
setkey(shops, lad_id)
dts <- shops[, .N, .(lad_id, rating)][order(lad_id, rating)]
dts <- dcast.data.table(dts, lad_id ~ paste0('R', ifelse(rating < 10, '0', ''), rating), fill = 0)
lads <- dts[, lad_id := as.numeric(lad_id)][lads, on = 'lad_id']
setcolorder(lads, c('lad_id', 'name', 'updated_at', 'tot_shops'))

# The below link should be checked every now and then: https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=NAC_LAD
# Adding lads ONS code using file from Open Geography Portal
ons <- fread('https://opendata.arcgis.com/datasets/17eb563791b648f9a7025ca408bb09c6_0.csv')
setnames(ons, 1:2, c('lad_ons', 'name'))
ons <- ons[, 1:2]
ons[, name := gsub(' City', '', name)][, name := gsub('-', ' ', name)][, name := tolower(name)]
lads[, name_ori := name][, name := gsub(' City', '', name)][, name := gsub('-', ' ', name)][, name := tolower(name)]
lkp <- data.table(
    name_ori = c(
        'Anglesey', 'Blackburn', 'Bristol', 'City of London Corporation', 'Comhairle nan Eilean Siar (Western Isles)', 
        'Durham', 'East Suffolk', 'Edinburgh (City of)', 'Herefordshire', 'Hull City', 'South Buckinghamshire',
        'St Helens', 'Telford and Wrekin Council'
    ),
    name = c(
        'isle of anglesey', 'blackburn with darwen', 'bristol, of', 'city of london', 'na h eileanan siar', 
        'county durham', 'suffolk coastal', 'city of edinburgh', 'herefordshire, county of', 'kingston upon hull, of', 'south bucks', 
        'st. helens', 'telford and wrekin'
    )
)
lads[name_ori %in% lkp[, name_ori], name := lkp[.SD[['name_ori']], .(name), on = 'name_ori'] ]
lads <- ons[lads, on = 'name'][, name := name_ori][, name_ori := NULL]

# Adding ONS Regions using file from Open Geography Portal
ons <- fread('https://opendata.arcgis.com/datasets/0c3a9643cc7c4015bb80751aad1d2594_0.csv')
ons <- ons[, c(1, 3, 4)]
setnames(ons, c('lad_ons', 'rgn_code', 'rgn_name'))
lads <- ons[lads, on = 'lad_ons']
setcolorder(lads, c('lad_id', 'lad_ons', 'name', 'rgn_code', 'rgn_name'))
fwrite(lads, file.path(data_path, 'lads.csv'), row.names = FALSE)

# convert to numeric
cols <- c('lad_id', 'shop_id', 'sector_id', 'rating', 'score_H', 'score_S', 'score_C', 'x_lon', 'y_lat')
shops[, (cols) := lapply(.SD, as.numeric), .SDcols = cols]

# add OA and WPZ to shops
pc <- read.fst(file.path(data_path, 'pc'), as.data.table = TRUE)
shops <- pc[shops, on = 'postcode']

# Checking missing values again
sapply(names(shops), function(x) shops[is.na(get(x)), .N])

# some postcode are wrong: should we try to find at least the correct OA/WPZ using shops coordinates and area polygons?
y <- shops[is.na(OA) & !is.na(postcode)]

# convert to factor
cols <- c('postcode', 'OA', 'WPZ', 'sector')
shops[, (cols) := lapply(.SD, factor), .SDcols = cols]

# convert ratings to ordered factors
cols <- c('rating', 'score_H', 'score_S', 'score_C')
shops[, (cols) := lapply(.SD, factor, ordered = TRUE), .SDcols = cols]
for(cl in cols) levels(shops[[cl]]) <- ratings[index == cl, description]

# should we clean names? like capitilizing first letter each words? But not for all words...
shops[, name := gsub('(?<=\\b)([a-z])', '\\U\\1', tolower(name), perl = TRUE)]
shops[, name := gsub('Ltd|Ltd.|Limited', 'LTD', name)]
shops[, name := gsub('Llc', 'LLC', name)]
shops[, name := gsub('Plc|P.L.C.', 'PLC', name)]

# save shops dataset in binary format with index by lad
setorderv(shops, c('lad_id', 'sector', 'name'))
y <- shops[, .N, lad_id]
y[, n2 := cumsum(N)][, n1 := shift(n2, 1L, type = 'lag') + 1][is.na(n1), n1 := 1]
setcolorder(y, c('lad_id', 'N', 'n1', 'n2'))
write.fst(y, file.path(data_path, 'shops.idx'))
write.fst(shops, file.path(data_path, 'shops'))

# Cleaning
rm(list = ls())
gc()
    
