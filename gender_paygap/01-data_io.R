################################
# UK GENDER PAY GAP - DATA I/O #
################################

## PREPARATION ------------------------------------------------------------------------------------------------------------------

# load packages
pkgs <- c('data.table', 'rvest')
invisible(lapply(pkgs, require, character.only = TRUE))

# set constants
data_path <- './gender_paygap/data'
dates <- c(2017, 2018, 2019)
cols = c(
    'company', 'address', 'company_id', 'sic', 
    'DMH', 'DMdH', 'DMB', 'DMdB', 'BPM', 'BPF', 'Q1M', 'Q1F', 'Q2M', 'Q2F', 'Q3M', 'Q3F', 'Q4M', 'Q4F',
    'size', 'datefield'
)

## MAIN DATASET -----------------------------------------------------------------------------------------------------------------

# create empty dataset
dts <- setnames( data.table(matrix(nrow = 0, ncol = length(cols))), cols)

# download data
for(x in dates){

    # download data file
    y <- fread(
            paste0('https://gender-pay-gap.service.gov.uk/Viewing/download-data?year=', x), 
            select = c(1:18, 21), 
            col.names = cols[1:(length(cols) - 1)],
            na.strings = ''
    )
    
    # add datefield to dataset
    y[, datefield := x]
    
    # NULL bonus gap if at least sex havn't had any bonus
    y[BPM == 0 | BPF == 0, `:=`(DMB = NA, DMdB = NA)]
    
    # NULL values if at least one of them is more than 100 (women can't be paid less than 100% than men) 
    y[DMH >= 100 | DMdH >= 100, `:=`(DMH = NA, DMdH = NA, DMB = NA, DMdB = NA)]
    
    # add to dataset
    dts <- rbindlist(list( dts, y ))
    
}

# find missing sic for included company_id
ms <- dts[is.na(sic) & !is.na(company_id), company_id]
cntr <- 1
for(m in ms){
    message('Processing company <', m, '>, ', cntr, ' out of ', length(ms))
    tryCatch(
        {
            sc <- read_html(paste0('https://beta.companieshouse.gov.uk/company/', m)) %>%
                        html_nodes('#sic0') %>% 
                        html_text() %>% 
                        sub('(.*)-.*', '\\1', .) %>% 
                        trimws()
            if(length(sc) > 0) dts[company_id == m, sic := sc]
        }, 
        error = function(e){ cat('Company Not Found!\n') }
    )
    cntr <- cntr + 1
}

# save datasets into data directory
fwrite(dts[order(-datefield, company)], file.path(data_path, 'dts01.csv'), row.names = FALSE)

## SIC codes -----------------------------------------------------------------------------------------------------------------

# download [SIC codes](https://en.wikipedia.org/wiki/Standard_Industrial_Classification)
sic <- read_html('http://resources.companieshouse.gov.uk/sic/') %>%
            html_nodes('td , strong') %>%
            html_text() %>%
            trimws() %>%
            matrix(ncol = 2, byrow = TRUE) %>%
            as.data.table() %>% 
            setnames(c('sic_code', 'description'))

# extract sections
sic[, section := shift(description, type = 'lead')]
sic[, section := paste0(substring(sic_code, nchar(sic_code)), '] ', section) ]
sic[, section := section[1], cumsum(grepl('Section', sic_code))]
sections <- unique(sic[, .(description = section)])
sections[, section := substr(description, 1, 1)]
sic[, section := substr(section, 1, 1)]
sic <- sic[nchar(sic_code) == 5]

# save as csv
fwrite(sic, file.path(data_path, 'sic.csv'))
fwrite(sections, file.path(data_path, 'sections.csv'))

## VARS helper table ------------------------------------------------------------------------------------------------------------

vars <- data.frame(
    'var_id' = c(
        'DMH', 'DMdH', 'DMB', 'DMdB', 
        'BPM', 'BPF', 
        'Q1M', 'Q1F', 'Q2M', 'Q2F', 'Q3M', 'Q3F', 'Q4M', 'Q4F'
    ),
    'name'   = c(
        'DiffMeanHourlyPercent', 'DiffMedianHourlyPercent', 'DiffMeanBonusPercent', 'DiffMedianBonusPercent', 
        'MaleBonusPercent', 'FemaleBonusPercent',
        'MaleLowerQuartile', 'FemaleLowerQuartile', 'MaleLowerMiddleQuartile', 'FemaleLowerMiddleQuartile',
        'MaleUpperMiddleQuartile', 'FemaleUpperMiddleQuartile', 'MaleTopQuartile', 'FemaleTopQuartile'
    ),
    'description' = c(
        'Gender Hourly Pay Gap: Mean',
        'Gender Hourly Pay Gap: Median',
        'Gender Bonus Pay Gap: Mean',
        'Gender Bonus Pay Gap: Median',
        'Proportion Men receiving Bonus',
        'Proportion Women receiving Bonus',
        'Proportion Men Lower Quartile: 0-25%',
        'Proportion Women Lower Quartile: 0-25%',
        'Proportion Men Lower Middle Quartile: 25-50%',
        'Proportion Women Lower Middle Quartile: 25-50%',
        'Proportion Men Upper Middle Quartile: 50-75%',
        'Proportion Women Upper Middle Quartile: 50-75%',
        'Proportion Men Top Quartile: 75-100%',
        'Proportion Women Top Quartile: 75-100%'
     )
 )
fwrite(vars, file.path(data_path, 'vars.csv'))

## Clean and Exit ---------------------------------------------------------------------------------------------------------------
rm(list = ls())
gc()

