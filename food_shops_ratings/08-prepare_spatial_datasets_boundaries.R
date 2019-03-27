#########################################################################
# UK FOOD HYGIENE RATING - Prepare Geographical Datasets and Boundaries #
#########################################################################

### POSTCODES LOOKUPS -----------------------------------------------------------------------------------------------------------

# load packages
pkgs <- c('data.table', 'fst')
lapply(pkgs, require, char = TRUE)

# download postcodes zip file
# check url for latest file @ http://geoportal.statistics.gov.uk/datasets?q=ONS+Postcode+Directory+(ONSPD)+zip&sort_by=updated_at
tmp <- tempfile()
download.file('https://www.arcgis.com/sharing/rest/content/items/abd42fce1e944431b4f24881b5bb048d/data', tmp)

# unzip file
unzip(tmp, exdir = 'tmpdir')
pc <- dir('tmpdir', recursive = TRUE, full.names = TRUE)

# read biggest csv file
pc <- fread(
    pc[which.max(file.size(pc))], 
    select = c(
           'pcd', 'osgrdind', 'doterm', 'long', 'lat', 
           'oa11', 'lsoa11', 'msoa11', 'oslaua', 'oscty', 'rgn', 'ctry', 'osward', 'wz11', 'ccg', 
           'imd', 'oac11'
    ),
    col.names = c(
            'postcode', 'osgrdind', 'is_active', 'x_lon', 'y_lat',
            'OA', 'LSOA', 'MSOA', 'LAD', 'CTY', 'RGN', 'CTRY', 'WARD', 'WPZ', 'CCG',
            'IMD', 'OAC'
    ), na.string = ''
)

# delete zip and unzipped files
unlink(tmp)
unlink('tmpdir', recursive = TRUE)

# eliminates postcodes without grid reference (osgrdind == 9, deletes also GI/IM), then reorder by OA and postcode
pc <- pc[osgrdind < 9][, osgrdind := NULL]

# recode is_active as binary
pc[, is_active := ifelse(is.na(is_active), 1, 0)]

# recode all characters as factors
cols <- colnames(pc)
cols <- cols[which(names(pc) == 'OA'):length(cols)]
pc[, (cols) := lapply(.SD, factor), .SDcols = cols]

# save results in fst format 
write.fst(pc, './food_shops_ratings/data/postcodes')

# clean env
rm(list = ls())
gc()

### LOCAL AUTHORITIES BOUNDARIES ------------------------------------------------------------------------------------------------

# load packages
pkgs <- c('rgdal')
lapply(pkgs, require, char = TRUE)

# download boundaries zip file (if problems with ONS website run instead the commented line below)
tmp <- tempfile()
download.file('https://opendata.arcgis.com/datasets/9a7623846f074dc6b51b48c59deada13_0.zip?outSR=%7B%22wkid%22%3A27700%2C%22latestWkid%22%3A27700%7D', tmp)
# tmp <- './food_shops_ratings/downloads/Local_Authority_Districts_December_2018_Boundaries_UK_BGC.zip'

# unzip file and read included files names
unzip(tmp, exdir = 'tmpdir')
bnd <- dir('tmpdir', recursive = TRUE, full.names = TRUE)

# load ONS boundaries
bnd <- readOGR('./tmpdir', unique(basename(tools::file_path_sans_ext(bnd))))

# delete zip and unzipped files
unlink(tmp)
unlink('tmpdir', recursive = TRUE)

# check the projection, the total number of features, and read the field to keep as future id; in this case: "WZ11CD"
length(bnd)   # ==> 391
summary(bnd)  # ==> lad18cd

# transform the shapefile projection to WGS84 
bnd <- spTransform(bnd, CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'))

# keep in the data slot only the ONS Output Area id, renaming it as 'id'
bnd <- bnd[, 'lad18cd']
colnames(bnd@data) <- c('id')

# reassign the polygon IDs
bnd <- spChFIDs(bnd, as.character(bnd$id))

# check the CRS has changed correctely, and the data slot has shrink to only the ID
summary(bnd)

# count polygons by country; it should return the following result (for 2011 census): E 326, W 22 S 32, N 11 (UK: 391) 
table(substr(bnd@data$id, 1, 1))

# save to disk first as a shapefile, then as a RDS
if(file.exists('./food_shops_ratings/boundaries/LAD.shp')) 
    file.remove(paste0('./food_shops_ratings/boundaries/LAD.', c('shp', 'prj', 'dbf', 'shx')))
writeOGR(bnd, dsn = './food_shops_ratings/boundaries', layer = 'LAD', driver = 'ESRI Shapefile')
saveRDS(bnd, './food_shops_ratings/boundaries/LAD')

# clean env
rm(list = ls())
gc()

### WORKPLACE ZONES BOUNDARIES --------------------------------------------------------------------------------------------------

# load packages
pkgs <- c('rgdal')
lapply(pkgs, require, char = TRUE)

# download boundaries zip file (if problems with CDRC website run instead the commented line below)
tmp <- tempfile()
download.file('https://data.cdrc.ac.uk/dataset/81079026-78d9-4149-9945-d424fc94ed85/resource/673cddb5-6e7d-4a37-beba-1bf74261895c/download/wz2011ukbgcv2.zip', tmp)
# tmp <- './food_shops_ratings/downloads/wz2011ukbgcv2.zip'

# unzip file
unzip(tmp, exdir = 'tmpdir')
bnd <- dir('tmpdir', recursive = TRUE, full.names = TRUE)

# load ONS boundaries
bnd <- readOGR('./tmpdir', unique(basename(tools::file_path_sans_ext(bnd))))

# delete zip and unzipped files
unlink(tmp)
unlink('tmpdir', recursive = TRUE)

# check the projection, the total number of features, and read the field to keep as future id; in this case: "WZ11CD"
length(bnd)   # ==> 60709
summary(bnd)  # ==> WZ11CD

# transform the shapefile projection to WGS84 
bnd <- spTransform(bnd, CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'))

# keep in the data slot only the ONS Output Area id, renaming it as 'id'
bnd <- bnd[, 'WZ11CD']
colnames(bnd@data) <- c('id')

# reassign the polygon IDs
bnd <- spChFIDs(bnd, as.character(bnd$id))

# check the CRS has changed correctely, and the data slot has shrink to only the ID
summary(bnd)

# count polygons by country; it should return the following result (for 2011 census): E 50,868, W 1,756 S 5,375, N 2,710 (UK: 60,709) 
table(substr(bnd@data$id, 1, 1))

# if you need to "simplify" the polygons for a quicker management, change the percentage in the following line and run it
bnd <- ms_simplify(bnd, keep = 0.20, keep_shapes = TRUE)

# save to disk first as a shapefile, then as a RDS
if(file.exists('./food_shops_ratings/boundaries/WPZ.shp')) 
    file.remove(paste0('./food_shops_ratings/boundaries/WPZ.', c('shp', 'prj', 'dbf', 'shx')))
writeOGR(bnd, dsn = './food_shops_ratings/boundaries', layer = 'WPZ', driver = 'ESRI Shapefile')
saveRDS(bnd, './food_shops_ratings/boundaries/WPZ')

# clean env
rm(list = ls())
gc()
