######################################
# UK GENDER PAY GAP - DATA WRANGLING #
######################################

## PREPARATION ------------------------------------------------------------------------------------------------------------------

# load packages
pkgs <- c('data.table', 'fst')
invisible(lapply(pkgs, require, character.only = TRUE))

# set constants
data_path <- './gender_paygap/data'
geo_path <- '../uk_geography/datasets'
bnd_path <- '../uk_geography/boundaries/'
geo_cols <- c('LSOA', 'MSOA', 'LAD', 'CTY', 'RGN', 'CTRY', 'WARD', 'PCON', 'CCG')

## CLEAN MAIN DATASET -----------------------------------------------------------------------------------------------------------

# load dataset
dts <- fread(file.path(data_path, 'dts01.csv'), na.strings = c('', 'Not Provided'))

# add company_name for displaying, then clean it
dts[, company_name := trimws(gsub('"', '', company)) ]
dts[, company_name := trimws(gsub('  ', ' ', company_name)) ]
dts[, company_name := gsub('(?<=\\b)([a-z])', '\\U\\1', tolower(company_name), perl = TRUE)]
dts[, company_name := gsub('Ltd|Ltd.|Limited', 'LTD', company_name)]
dts[, company_name := gsub('Llc', 'LLC', company_name)]
dts[, company_name := gsub('Public LTD Company|Plc|P.L.C.', 'PLC', company_name)]
dts[, company_name := gsub('Uk|(UK)|U.K.', 'UK', company_name)]
dts[, company_name := gsub('Gb', 'GB', company_name)]
dts[, company_name := gsub('Nhs', 'NHS', company_name)]
dts[, company_name := gsub('\\(The\\)|"', '', company_name)]
dts[, company_name := gsub('N H S', 'NHS', company_name)]
dts[, company_name := trimws(company_name) ]
dts[, company_name := gsub("\\sThe\\w*$", "", company_name)]
dts[, company_name := trimws(gsub('  ', ' ', company_name)) ]

# move backwards change in names 
dates <- sort(unique(dts$datefield), dec = TRUE)
for(yn in dates[1:(length(dates) -  1)]){
    # 
    cnp <- dts[datefield == yn - 1, .(cnp_id = company_id, cnp_name = company_name) ] 
    # 
    cnn <- dts[datefield == yn, .(company_id, company_name) ]           
    # 
    y <- cnn[company_id %in% cnp$cnp_id][!is.na(company_id)]
    # 
    y <- cnp[y, on = c(cnp_id = 'company_id')][cnp_name != company_name][, .(company_id = cnp_id, company_name)]
    # update 
    dts[
        datefield == (yn - 1) & company_id %in% y[, company_id], 
        company_name := y[.SD[['company_id']], .(company_name), on = 'company_id']
    ]
}

# add comma to size where missing
dts[, size := gsub('1000', '1,000', size)][, size := gsub('4999', '4,999', size)][, size := gsub('5000', '5,000', size)]

# extract and clean postcode
dts[, postcode := trimws(sub('^.*,(.*)$', '\\1', address))]
dts[, postcode := gsub(' ', '', postcode)]
dts[!grepl("[[:digit:]][[:alpha:]][[:alpha:]]$", postcode), postcode := NA]
dts <- dts[!is.na(postcode),  
    postcode:= toupper(paste0(
        substr( paste0( substr( postcode, 1, nchar(postcode) - 3), '  '), 1, 4),
        substring(postcode, nchar(postcode) - 2)
    ))
]

# clean sic
dts[, sic := gsub('\r\n', '', trimws(sub('^1,(.*)', '\\1', sic)))]
dts[, sic := gsub('[^0-9\\,]', '', sic)]

# recode single SIC=1 as 84110
dts[sic == '1', sic := '84110']

# create table with all sics connected to all companies
companies_sic <- dts[!is.na(sic), .(rep(company_name, sapply(strsplit(sic, split = ','), length)), unlist(strsplit(sic, split = ',')) )]
setnames(companies_sic, c('company_name', 'sic'))
companies_sic <- unique(companies_sic)[, sic := as.numeric(sic)][order(company_name, sic)]

# add section
sic <- fread(file.path(data_path, 'sic.csv'))
companies_sic <- sic[companies_sic, on = c(sic_code = 'sic')]
setcolorder(companies_sic, 'company_name')

# save companies_sic as csv
fwrite(companies_sic, file.path(data_path, 'companies_sic.csv'), row.names = FALSE)

# add section to main dataset
sct <- fread(file.path(data_path, 'sections.csv'))
sct[, `:=`(section = factor(section), dsection = factor(description))]
y <- companies_sic[, .N, .(section, company_name)][order(section, company_name, -N)][, .SD[1], company_name][, N := NULL]
y <- sct[, .(section, dsection)][y, on = 'section']
dts <- dts[y, on = 'company_name']

# define order for columns
cols <- c(
    'datefield', 'company', 'company_name', 'company_id',  'sic', 'section', 'dsection', 'size', 
    'address', 'x_lon', 'y_lat', 'postcode'
)

# add coordinates, clean address and possibly missing postcodes from Google Maps
if(file.exists(file.path(data_path, 'dts_geo.csv'))){
    gdts <- fread(file.path(data_path, 'dts_geo.csv'), drop = 'address')
    dts <- gdts[dts, on = 'company_name']
    dts[is.na(postcode), postcode := gpostcode][, gpostcode := NULL]
    cols <- c(cols, 'gaddress')
}

# check coordinates with UK bounding box:
bnd <- readRDS(file.path(bnd_path, 'CTRY'))
y <- bnd@bbox
dts[x_lon < y[1, 1] | x_lon > y[1, 2] | y_lat < y[2, 1] | y_lat > y[2, 2], `:=`(x_lon = NA, y_lat = NA)]

# manual postcodes and coordinates fixing
dts[grepl('Ashford.*Trust', company), postcode := 'KT160PZ']
dts[company_id == '04923718', postcode := 'NP113EH']
dts[company_id == '02543224', postcode := 'CF336BZ']
dts[company_id == '02269560', postcode := 'SS0 9HR']
dts[company_id == '02215564', postcode := 'EC4A3TR']
dts[company_id == '00615334', postcode := 'BN274BW']
dts[company_id == '02607362', postcode := 'ST189QE']

# add OA and WPZ
pc <- read.fst(file.path(geo_path, 'postcodes'), as.data.table = TRUE)
dts <- pc[, .(postcode, OA, WPZ, pc_x = x_lon, pc_y = y_lat)][dts, on = 'postcode']

# add postcode centroid to missing coordinates
dts[is.na(x_lon), `:=`(x_lon = pc_x, y_lat = pc_y)][, `:=`(pc_x = NULL, pc_y = NULL)]
dts <- dts[!is.na(x_lon)]
dts <- dts[!is.na(OA)]

# add other areas
oas <- read.fst(file.path(geo_path, 'output_areas'), as.data.table = TRUE)
dts <- oas[dts, on = 'OA']

# reorder columns
setcolorder(dts, cols)

# save datasets as csv
fwrite(dts[order(-datefield, CTRY, company_name)], file.path(data_path, 'dts.csv'), row.names = FALSE)

# recode for R scripts
cls <- c('Less than 250', '250 to 499', '500 to 999', '1,000 to 4,999', '5,000 to 19,999', '20,000 or more')
dts[, size := factor(size, levels = cls, ordered = TRUE)]

# save datasets as fst
write.fst(dts[order(-datefield, CTRY, company_name)], file.path(data_path, 'dts'))

## Clean and Exit ---------------------------------------------------------------------------------------------------------------
rm(list = ls())
gc()
    
