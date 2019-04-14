######################################
# UK GENDER PAY GAP - Hexbin Mapping #
######################################

# LOAD PACKAGES -----------------------------------------------------------------------------------------------------------------
message('Loading packages...')
pkgs <- c('data.table', 'dggridR', 'fst', 'ggplot2', 'ggspatial', 'htmlwidgets', 'htmltools', 'leaflet', 'leaflet.extras', 'rgdal', 'rgeos', 'sp')
invisible(lapply(pkgs, require, character.only = TRUE))

# LOAD DATA ---------------------------------------------------------------------------------------------------------------------
message('loading data...')
lads <- fread('./food_shops_ratings/data/lads.csv')
sectors <- fread('./food_shops_ratings/data/sectors.csv')
ratings <- fread('./food_shops_ratings/data/ratings.csv')
shops <- read.fst('./food_shops_ratings/data/shops', as.data.table = TRUE)
shops <- shops[!is.na(x_lon)][, ratingn := as.numeric(rating) - 1][ratingn > 5, ratingn := NA]
oas <- read.fst('./food_shops_ratings/data/output_areas', as.data.table = TRUE)
lcn <- read.fst('./food_shops_ratings/data/locations', as.data.table = TRUE)

# BUILD GRID --------------------------------------------------------------------------------------------------------------------
message('building the grid...')

# Construct a global grid with cells approximately 1 mile across
dggs <- dgconstruct(spacing = 1, metric = FALSE, resround = 'down')

# Get the corresponding grid cells for each food shop location (lat-long pair)
shops$cell <- dgGEO_to_SEQNUM(dggs, shops$x_lon, shops$y_lat)$seqnum

# Converting SEQNUM to GEO gives the center coordinates of the cells
cellcenters   <- dgSEQNUM_to_GEO(dggs, shops$cell)

# Get the number of shops in each cell, then add the average ratings (0-6) and the lad_id (some 2K cells have overlaps)
shops_mtc <- shops[, .(count = .N), cell]
shops_mtc <- shops[, .(rating = mean(ratingn, na.rm = TRUE)), cell ][shops_mtc, on = 'cell']

y <- unique(shops[, .(cell, lad_id)])
y1 <- y[cell %in% y[, .N, cell][N == 1, cell] ]
y2 <- shops[cell %in% y[, .N, cell][N > 1, cell], .N, .(cell, lad_id)][order(cell, -N)][, .SD[1], cell][, .(cell, lad_id)]
shops_mtc <- rbindlist(list( y1, y2 ))[shops_mtc, on = 'cell']

# Get the grid cell boundaries for cells with shops in them
# grid <- dgcellstogrid(dggs, shops$cell, frame = FALSE, wrapcells = TRUE)
grid <- readRDS('./food_shops_ratings/boundaries/grid')

# Convert grid to adding a dataframe of its own ids
grid_ids <- as.data.frame(sapply(slot(grid, 'polygons'), function(x) slot(x, 'ID')), stringsAsFactors = FALSE)
row.names(grid_ids) <- sapply(slot(grid, 'polygons'), function(x) slot(x, 'ID'))
grid <- SpatialPolygonsDataFrame(grid, grid_ids)
colnames(grid@data) <- c('id')

# Update the grid cells' properties to include additional info  for each cell (lad_id, counting, metric)
grid <- merge(grid, shops_mtc, by.x = "id", by.y = "cell")

# LOAD GEOGRAPHY ----------------------------------------------------------------------------------------------------------------
message('loading geography...')

# select London Boroughs
y <- lads[lad_ons %in% lcn[grepl('E090', location_id), location_id]]
bnd <- subset(grid, grid@data$lad_id %in% y$lad_id)
bnd <- subset(bnd, !is.na(bnd@data$rating) & bnd@data$rating >= 3)

# create palette over the metric
pal <- colorNumeric("RdYlGn", bnd$rating)

# load Local Authority boundaries
lad_bnd <- readRDS('./food_shops_ratings/boundaries/LAD')
lad_bnd <- subset(lad_bnd, lad_bnd@data$id %in% y$lad_ons)
lad_bnd <- merge(lad_bnd, lcn[location_id %in% y$lad_ons, .(location_id, name)], by.x = 'id', by.y = 'location_id')

# MAP 1st LAYER -----------------------------------------------------------------------------------------------------------------
message('Build the initial map...')
mp <- leaflet(options = leafletOptions(minZoom = 6)) %>%
        addMapPane(name = "polygons", zIndex = 410) %>% 
        addMapPane(name = "hexbins", zIndex = 420) %>% # higher zIndex rendered on top
        # center and zoom: UK
        fitBounds(lad_bnd@bbox[1], lad_bnd@bbox[2], lad_bnd@bbox[3], lad_bnd@bbox[4]) %>%
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
message('Adding GRID Polygons...')
mp <- mp %>% 
    addPolygons(
        data = bnd,
        group = 'Hexbins',
        stroke = FALSE, 
        smoothFactor = 0.2, 
        fillOpacity = 0.6,
        color = ~pal(rating),
        label = ~htmlEscape(as.character(rating)),
        options = leafletOptions(pane = 'hexbins')
    )
message('Adding AREA Polygons...')
mp <- mp %>% 
    addPolygons(
        data = lad_bnd,
        group = 'Boundaries',
        stroke = TRUE,
        color = 'black',
        weight = 2,
        opacity = 1,
        smoothFactor = 0.2, 
        fillOpacity = 0,
        label = ~name,
        labelOptions = labelOptions(noHide = TRUE, opacity = 1 , textsize = '15px', textOnly = TRUE, offset = c(0, -4)),
        options = leafletOptions(pane = 'polygons')
    )

# ADD LEGEND --------------------------------------------------------------------------------------------------------------------
message('Adding Legend...')
mp <- mp %>%
    addLegend(
        group = 'Hexbins',
        pal = pal, 
        values = bnd$rating,
        title = "Average Food Rating",
        opacity = 1,
        position = "bottomright"
    )
    
# ADD LAYER CONTROL -------------------------------------------------------------------------------------------------------------
message('Adding Layer Control...')
mp <- mp %>%
	addLayersControl(
		baseGroups = c('OSM Mapnik', 'OSM B&W', 'Stamen Toner', 'Stamen Toner Lite', 'Hydda Full', 'Hydda Base'),
		overlayGroups = c('Hexbins', 'Boundaries'),
		options = layersControlOptions(collapsed = TRUE)
	)
	
# ADD TITLE ---------------------------------------------------------------------------------------------------------------------
message('Adding Title...')
mp <- mp %>%
	addControl(
		tags$div(HTML(paste0('<p style="font-size:20px;padding:10px 5px 10px 10px;margin:0px;background-color:#F7E816;">', 
		'Distribution of Ratings binned in Hexagons for London Boroughs', 
		'</p>'))), 
		position = 'bottomleft'
	)

# SHOW MAP ----------------------------------------------------------------------------------------------------------------------
message('Showing Map...')
print(mp)
