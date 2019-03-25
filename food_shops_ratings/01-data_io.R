#####################################
# UK FOOD HYGIENE RATING - DATA I/O #
#####################################
# source data main page: http://ratings.food.gov.uk/open-data
# example URL for LAD XXX: http://ratings.food.gov.uk/OpenDataFiles/FHRSXXXen-GB.xml

# load packages
pkgs <- c('data.table', 'fst', 'rvest', 'XML')
invisible(lapply(pkgs, require, character.only = TRUE))

# download metadata about Local Authorities
# - text for the first three columns ('name', 'updated_at', 'tot_shops'), link for the last one (url)
# - delete Welsh duplicates (cy in url)
lads <- read_html('http://ratings.food.gov.uk/open-data')
lads <- cbind(
            lads %>%
                html_nodes('td:nth-child(1) , td:nth-child(2) , td:nth-child(3)') %>% 
                html_text() %>% 
                matrix(byrow = TRUE, ncol = 3),
            lads %>%
                html_nodes('#openDataStatic a') %>%
                html_attr('href') %>% 
                matrix()
    ) %>% 
    as.data.table() %>% 
    setnames(c('name', 'updated_at', 'tot_shops', 'url')) %>% 
    subset(!grepl('cy', url)) %>% 
    setorder(url)

# clean and transform
lads[, `:=`(
    name = trimws(name),
    updated_at = as.Date(substr(trimws(updated_at), 1, 10), '%d/%m/%Y'),
    tot_shops = as.numeric(gsub('[^0-9]', '', tot_shops)),
    lad_id = gsub('[^0-9]', '', url)
)]

# delete non-ONS lad
lads <- lads[!lad_id %in% c(626, 648)]

# create empty structure to contain data about shops
cols <- c(
  'lad_id', 'shop_id', 'shop_ladid', 'name', 'sector', 'sector_id', 'postcode', 
  'rating', 'updated_at', 'score_H', 'score_S', 'score_C', 'x_lon', 'y_lat'
)
shops <- setnames( data.table(matrix(nrow = 0, ncol = length(cols))), cols)

# download shops data, keeping only the required fields
message('Processing local authorities...')
tmp <- tempfile()
for(idx in 1:nrow(lads)){
    message('Downloading file n. ', idx, ' out of ', nrow(lads))
    download.file(lads[idx, url], destfile = tmp)
    message('Processing...')
    y <- xmlToList(xmlTreeParse(tmp))[[2]]
    if(!is.null(dim(y))){
        message('uh-oh... XML file for lad with id ', lads[idx, lad_id], ' has an error... :`-(')
        next
    }
    message('Adding ', length(y), ' records...')
    shops <- rbindlist(list(
                        shops,
                        as.data.table(cbind(
                            lapply(y, '[[', 'LocalAuthorityCode'), 
                            lapply(y, '[[', 'FHRSID'), 
                            lapply(y, '[[', 'LocalAuthorityBusinessID'), 
                            lapply(y, '[[', 'BusinessName'),
                            lapply(y, '[[', 'BusinessType'), 
                            lapply(y, '[[', 'BusinessTypeID'),
                            lapply(y, '[[', 'PostCode'),
                            lapply(y, '[[', 'RatingValue'),
                            lapply(y, '[[', 'RatingDate'),
                            lapply(lapply(y, '[[', 'Scores'), '[[', 'Hygiene'),
                            lapply(lapply(y, '[[', 'Scores'), '[[', 'Structural'),
                            lapply(lapply(y, '[[', 'Scores'), '[[', 'ConfidenceInManagement'),
                            lapply(lapply(y, '[[', 'Geocode'), '[[', 'Longitude'),
                            lapply(lapply(y, '[[', 'Geocode'), '[[', 'Latitude')
                        ), row.names = FALSE)
    ))
    message('DONE! Total count of records so far: ', dim(shops)[1])
}
unlink(tmp)

message('Giving structure to dataset...')
shops <- data.table(cbind.data.frame(
            lapply(shops, 
                   function(x) 
                        unlist(lapply(x, 
                                      function(y) 
                                          ifelse(is.null(unlist(y)), NA, y) 
                        )) 
            ), 
            stringsAsFactors = FALSE 
         ))

# save datasets
fwrite(lads, './food_shops_ratings/data/lads_pre.csv')
write.fst(shops, './food_shops_ratings/data/shops_pre')

# y <- XML::xmlToList(XML::xmlTreeParse(xml2::read_xml('https://ratings.food.gov.uk/open-data-resources/lookupData/ScoreDescriptors.xml')))
# data.table(matrix(unlist(y$scoreDescriptors), ncol = 6, byrow = TRUE))
ratings <- data.table(
    index = c( rep('rating', 12), rep(c('score_H', 'score_S'), each = 6), rep(c('score_C'), 5) ),
    name = c( rep('rating', 12), rep(c('Hygiene', 'Structural'), each = 6), rep(c('Confidence'), 5) ),
    value = c(0:5, 7:9, 11:13, rep(seq(0, 25, 5), 2), 0, 5, 10, 20, 30),
    description = c(
        'Urgent improvement is required', 'Major improvement is necessary', 'Some improvement is necessary',
          'Hygiene standards are generally satisfactory', 'Hygiene standards are good', 'Hygiene standards are very good',
          'Awaiting Inspection', 'Awaiting Publication', 'Exempt', 'Pass And Eat Safe', 'Pass', 'Improvement Required', 
        'Very Good', 'Good', 'Generally satisfactory', 'Improvement necessary', 'Major improvement necessary', 'Urgent improvement necessary',
        'Very Good', 'Good', 'Generally satisfactory', 'Improvement necessary', 'Major improvement necessary', 'Urgent improvement necessary',
        'Very Good', 'Good', 'Generally satisfactory', 'Major improvement necessary', 'Urgent improvement necessary'
    )
)
fwrite(ratings, './food_shops_ratings/data/ratings.csv')

# clean and exit
rm(list = ls())
gc()
