############################################
# UK GENDER PAY GAP - DATA MAPS CHOROPLETH #
############################################

# LOAD PACKAGES -----------------------------------------------------------------------------------------------------------------
message('Loading packages...')
pkgs <- c('classInt', 'data.table', 'fst', 'htmlwidgets', 'htmltools', 'kableExtra', 'knitr', 'leaflet', 'leaflet.extras', 'rgdal', 'rgeos', 'sp')
invisible(lapply(pkgs, require, character.only = TRUE))

# PRELIMINARIES -----------------------------------------------------------------------------------------------------------------
message('Set contants, functions, parameters...')

# set constants
data_path <- './gender_paygap/data'
geo_path <- '../uk_geography/datasets'
bnd_path <- '../uk_geography/boundaries/'
cols_geo <- c('LSOA', 'MSOA', 'LAD', 'CTY', 'RGN', 'CTRY', 'WARD', 'PCON', 'CCG')

# define functions
get_legend <- function(Y, brks_lim, n_brks) {
    lbl_brks <- format(round(brks_lim, 3), nsmall = 1)
    lbl_text <- sapply(1:n_brks,
        function(x)
            paste0(
                lbl_brks[x], ' - ', lbl_brks[x + 1],
                ' (', length(Y[Y >= as.numeric(gsub(',', '', lbl_brks[x])) & Y < as.numeric(gsub(',', '', lbl_brks[x + 1])) ] ), ')'
            )
    )
}
build_poly_label <- function(x, y, has_values = TRUE){
    if(has_values){
        out <- paste0(
            '<hr>',
                '<b>', area_code, '</b>: ', y$name[x], '<br>',
                '<b>Region</b>: ', y$region[x], '<br>', 
                '<b>Pay Gap</b>: ', round(y$paygap[x], 2), '%<br>',
                '<b>Total Companies</b>: ', format(y$n_companies[x], big.mark = ','), '<br>',
                '<b>Population</b>: ', format(y$population[x], big.mark = ','), '<br>',
                '<b>Households</b>: ', format(y$households[x], big.mark = ','), '<br>',
            '<hr>'
        )
    } else {
        
    }
    HTML(out)
}
build_poly_popup <- function(x){
    tbl <- y.pp[X == x, .(cut, N, pct)]
    setnames(tbl, c('Pay Gap', 'Companies Count', 'Percentage'))
    y <- kable(tbl) %>%
            kable_styling(
                bootstrap_options = c('striped', 'hover', 'condensed', 'responsive'), 
                font_size = 12, 
                full_width = FALSE
            )
    if(nrow(tbl) > 15) y <- y %>% scroll_box(height = '300px')
    HTML(paste0(
        '<strong><font size="+1">
        Distribution of Companies by Pay Gap <br>',
#        'in ', poly_name, ' <em>', x, '</em></font></strong><br>',
        y
    ))
}

# set parameters
dte <- 2018
# area_code <- 'LAD'
# has_parent <- FALSE
area_code <- 'MSOA'
has_parent <- TRUE
parent_code <- 'E12000008'
mtc_num <- 'n_companies'
mtc_den <- 'population'
mtc_name <- 'Density (%)'
bsz <- 6         # BORDER Width (pixels)
bcl <- '#727272' # BORDER Colour
btp <- 5         # BORDER Transparency (1-10)
hcl <- 'white'   # HIGHLIGHT BORDER Colour
hsz <- 8         # HIGHLIGHT BORDER Width (pixels)
ftp <- 7         # FILL Transparency (1-10)
smt <- 1         # smoothFactor
n_brks <- 9
class.method <- 'pretty'
## - 'Fixed' = 'fixed',                  need an additional argument fixedBreaks that lists the n+1 values to be used
## - 'Equal Intervals' = 'equal',        the range of the variable is divided into n part of equal space
## - 'Quantiles' = 'quantile',           each class contains (more or less) the same amount of values
## - 'Pretty Integers' = 'pretty',       sequence of about ‘n+1’ equally spaced ‘round’ values which cover the range of the values in ‘x’. The values are chosen so that they are 1, 2 or 5 times a power of 10.
## - 'Natural Breaks' = 'jenks',         seeks to reduce the variance within classes and maximize the variance between classes
## - 'Hierarchical Cluster' = 'hclust',  Cluster with short distance
## - 'K-means Cluster' = 'kmeans'        Cluster with low variance and similar size
fixed_brks <- seq(0, 5, 0.5)
use_palette <- FALSE
# pal_pkg <- '
pal_name <- 'BrBG'
rev_pal <- TRUE
map_colours <- c('#0AC75F', '#ECFF59', '#CC9710')

# LOAD DATA ---------------------------------------------------------------------------------------------------------------------
message('loading data...')
dts <- read.fst(file.path(data_path, 'dts'), as.data.table = TRUE)
dts <- dts[!is.na(x_lon) & datefield == 2018]
sic <- fread(file.path(data_path, 'sic.csv'))
sections <- fread(file.path(data_path, 'sections.csv'))
vars <- fread(file.path(data_path, 'vars.csv'))
oas <- read.fst(file.path(geo_path, 'output_areas'), as.data.table = TRUE)
lcn <- read.fst(file.path(geo_path, 'locations'), as.data.table = TRUE)
census <- read.fst(file.path(data_path, 'census'), as.data.table = TRUE)
oas <- oas[census[, .(OA, population = KS1010001, households = KS1050001)], on = 'OA']

# clear dataset from potential non-geo records
dts <- dts[!is.na(x_lon)]

# clear dataset from potential non-geo records
dts <- dts[datefield == dte]

# select dataset, and calc metric
pg <- 'DMdH'
y <- dts[, .(n_companies = .N, paygap = mean(get(pg), na.rm = TRUE)), .(X = get(area_code))][!is.na(X)]

# add other variables for labeling
y <- lcn[type == area_code, .(location_id, name)][y, on = c(location_id = 'X')]
yr <- unique(lcn[type == 'RGN', .(location_id, name)][oas[, .(X = get(area_code), RGN)], on = c(location_id = 'RGN')][, .(X, region = name)])
y <- yr[y, on = c(X = 'location_id')]
y <- oas[, .(population = sum(population), households = sum(households)), .(X = get(area_code))][y, on = 'X']

# create dataset for popups
y.pp <- dts[, .N, .(X = get(area_code), cut(get(pg), seq(-100, 100, 20), ordered_result = TRUE))][!is.na(X)][, pct := N / sum(N), X][order(X, cut)]

# LOAD GEOGRAPHY ----------------------------------------------------------------------------------------------------------------
message('loading geography...')
bnd <- readRDS(file.path(bnd_path, area_code))
bnd <- merge(bnd, y, by.x = 'id', by.y = 'X')

# in case LSOA, MSOA or WPZ, please select a parent region to subset
if(has_parent)
    bnd <- subset(bnd, bnd@data$id %in% unique(oas[RGN == parent_code, get(area_code)]))

# build palette for polygons
brks_poly <- 
    if(class.method == 'fixed'){
        classIntervals( bnd[['paygap']], n = 11, style = 'fixed', fixedBreaks = fixed_brks)
    } else {
        classIntervals(bnd[['paygap']], n_brks, class.method)
    }
col_codes <- 
    if(use_palette){
        yc <-
            if(n_brks > brewer.pal.info[pal_name, 'maxcolors']){
                colorRampPalette(brewer.pal(brewer.pal.info[pal_name, 'maxcolors'], pal_name))(n_brks)
            } else {
                brewer.pal(n_brks, pal_name)
            }
        if(rev_pal) yc <- rev(yc)
        yc
    } else {
        colorRampPalette(c(map_colours[1], map_colours[2], map_colours[3]))(n_brks)
    }
pal_poly <- findColours(brks_poly, col_codes)

# MAP 1st LAYER -----------------------------------------------------------------------------------------------------------------
message('Build the initial map...')
mp <- leaflet(options = leafletOptions(minZoom = 6)) %>%
        addMapPane(name = "polygons", zIndex = 410) %>% 
        addMapPane(name = "hexbins", zIndex = 420) %>% # higher zIndex rendered on top
        # center and zoom
        fitBounds(bnd@bbox[1], bnd@bbox[2], bnd@bbox[3], bnd@bbox[4]) %>%
        # add maptiles
    	addProviderTiles(providers$OpenStreetMap.Mapnik, group = 'OSM Mapnik') %>%
    	addProviderTiles(providers$OpenStreetMap.BlackAndWhite, group = 'OSM B&W') %>%
    	addProviderTiles(providers$Stamen.Toner, group = 'Stamen Toner') %>%
    	addProviderTiles(providers$Stamen.TonerLite, group = 'Stamen Toner Lite') %>% 
    	addProviderTiles(providers$Hydda.Full, group = 'Hydda Full') %>%
    	addProviderTiles(providers$Hydda.Base, group = 'Hydda Base') %>% 
        # add map reset button 
        addResetMapButton()

# ADD POLYGONS ------------------------------------------------------------------------------------------------------------------
message('Adding Polygons...')
mp <- mp %>% 
	addPolygons(
		data = bnd,
        stroke = TRUE,
        color = bcl,
        opacity = 1 - as.numeric(btp) / 10,
        weight = as.integer(bsz) / 10,
        smoothFactor = smt,
        fill = TRUE,
		fillColor = pal_poly, 
        fillOpacity = 1 - as.numeric(ftp) / 10,
        highlightOptions = highlightOptions(
            color = hcl,
            weight = as.integer(hsz),
            opacity = 1,
            bringToFront = TRUE
        ),
        label = lapply(1:nrow(bnd), build_poly_label, bnd),
    	labelOptions = labelOptions(
    		textsize = '12px',
    		direction = 'right',
    		sticky = FALSE,
    		offset = c(80, -50),
    		style = list('font-weight' = 'normal', 'padding' = '2px 6px')
    	),
 		popup = lapply(bnd$id, build_poly_popup),
 		popupOptions = popupOptions(minWidth = 440)
	)

# ADD LEGEND --------------------------------------------------------------------------------------------------------------------
message('Adding Legend...')
mp <- mp %>%
	addLegend(
        colors = col_codes,
        labels = get_legend(bnd[['paygap']], brks_poly$brks, n_brks),
		position = 'bottomright',
        title = "Average Pay Gap",
		opacity = 0.8
	)

# ADD LAYER CONTROL -------------------------------------------------------------------------------------------------------------
message('Adding Layer Control...')
mp <- mp %>%
	addLayersControl(
		baseGroups = c('OSM Mapnik', 'OSM B&W', 'Stamen Toner', 'Stamen Toner Lite', 'Hydda Full', 'Hydda Base'),
		options = layersControlOptions(collapsed = TRUE)
	)
	    
# ADD TITLE ---------------------------------------------------------------------------------------------------------------------
message('Adding Title...')
mp <- mp %>%
	addControl(
		tags$div(HTML(paste0('<p style="font-size:20px;padding:10px 5px 10px 10px;margin:0px;background-color:#F7E816;">', 
		paste('Distribution of Pay Gap by', area_code, if(has_parent){paste('for', lcn[location_id == parent_code, name])}),
		'</p>'))), 
		position = 'bottomleft'
	)

# SHOW MAP ----------------------------------------------------------------------------------------------------------------------
message('Showing Map...')
print(mp)
