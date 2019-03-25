# load packages
pkg <- c('data.table', 'fst')
invisible(lapply(pkg, require, character.only = TRUE))

# load datasets
data_path <- file.path(Sys.getenv('PUB_PATH'), 'datasets', 'geography', 'uk')
oas <- read.fst(
        file.path(data_path, 'output_areas'), 
        columns = c('OA', 'LSOA', 'MSOA', 'LAD',  'CTY',  'RGN',  'CTRY', 'WARD', 'CCG'),
        as.data.table = TRUE
)
wpz <- read.fst(file.path(data_path, 'workplace_zones'), as.data.table = TRUE)
lcn <- read.fst(
        file.path(data_path, 'locations'), 
        columns = c('OA', 'LSOA', 'MSOA', 'LAD',  'CTY',  'RGN',  'CTRY', 'WARD', 'CCG'),
        as.data.table = TRUE
)
pc <- read.fst(file.path(data_path, 'postcodes'), columns = c('postcode', 'OA', 'WPZ'), as.data.table = TRUE)


# save datasets
write.fst(pc,  './food_shops_ratings/data/postcodes')
write.fst(oas, './food_shops_ratings/data/output_areas')
write.fst(wpz, './food_shops_ratings/data/workplace_zones')
write.fst(lcn, './food_shops_ratings/data/locations')

# clean env
rm(list = ls())
gc()
