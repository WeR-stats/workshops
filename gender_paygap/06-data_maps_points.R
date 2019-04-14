########################################
# UK GENDER PAY GAP - DATA MAPS POINTS #
########################################

# load packages
pkgs <- c('data.table', 'fst', 'htmlwidgets', 'htmltools', 'leaflet', 'leaflet.extras', 'rgeos', 'sp')
invisible(lapply(pkgs, require, character.only = TRUE))

# load data
lads <- fread('./food_shops_ratings/data/lads.csv')
sectors <- fread('./food_shops_ratings/data/sectors.csv')
ratings <- fread('./food_shops_ratings/data/ratings.csv')
shops <- read.fst('./food_shops_ratings/data/shops', as.data.table = TRUE)
shops <- shops[!is.na(x_lon)]
oas <- read.fst('./food_shops_ratings/data/output_areas', as.data.table = TRUE)
lcn <- read.fst('./food_shops_ratings/data/locations', as.data.table = TRUE)

# set style constant
pnt.radius = 6
pnt.ftrp = 0.2
pnt.weight = 1
pnt.trp = 0.2

# subset to London
area_type <- 'CTY'
area_ids <- lcn[type == area_type & grepl('london', tolower(name)), location_id ]
shops.sel <- shops[OA %in% oas[get(area_type) %in% area_ids, OA]]
# shops.sel <- shops[OA %in% oas[get(area_type) == 'E13000001', OA]]
# shops.sel <- shops.sel[shop_id %in% sample(shops.sel$shop_id, 2500)]
# area_type <- 'LAD'
# area_ids <- lcn[type == area_type & grepl('southwark', tolower(name)), location_id ]
# shops.sel <- shops[OA %in% oas[get(area_type) %in% area_ids, OA]]

# gets the centroid coords of the chosen area
shops.sp <- SpatialPoints(shops.sel[, .(x_lon, y_lat)])
proj4string(shops.sp) <- CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0')
shops.bb <- gConvexHull(shops.sp)@bbox

mp <- leaflet(options = leafletOptions(minZoom = 6)) %>%
        # center and zoom: UK
        fitBounds(shops.bb[1], shops.bb[2], shops.bb[3], shops.bb[4]) %>%
        # add maptiles
    	addProviderTiles(providers$OpenStreetMap.Mapnik, group = 'OSM Mapnik') %>%
    	addProviderTiles(providers$OpenStreetMap.BlackAndWhite, group = 'OSM B&W') %>%
    	addProviderTiles(providers$Stamen.Toner, group = 'Stamen Toner') %>%
    	addProviderTiles(providers$Stamen.TonerLite, group = 'Stamen Toner Lite') %>% 
    	addProviderTiles(providers$Hydda.Full, group = 'Hydda Full') %>%
    	addProviderTiles(providers$Hydda.Base, group = 'Hydda Base') %>% 
        # add map reset button 
        addResetMapButton()

# simple map: no groups (=fill/icon), no labels, try first all London, thenm Inner London, finally 2.5K sample
mp %>% 
    addCircleMarkers(
        data = shops.sel,
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = 'orange',
        fillOpacity = 1 - pnt.ftrp,
        stroke = TRUE,
        color = 'black',
        weight = pnt.weight,
        opacity = 1 - pnt.trp
    )

# let's group by rating and color accordingly
rating.pal <- colorFactor(c("#FF0A0A", "#DB9D63", "#E0E065", "#96D4ED", "#17EB17"), droplevels(shops.sel$rating)) # use RStudio colourpicker addin
rating.pal <- colorFactor('RdYlBu', droplevels(shops.sel$rating)) # use ColorBrewer http://colorbrewer2.org/
rating.pal <- colorFactor('viridis', droplevels(shops.sel$rating)) # use Pythonista Viridis https://bids.github.io/colormap/
mp %>% 
    addCircleMarkers(
        data = shops.sel,
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = ~rating.pal(rating),
        fillOpacity = 1 - pnt.ftrp,
        stroke = TRUE,
        color = 'black',
        weight = pnt.weight,
        opacity = 1 - pnt.trp
    )
# four functions: colorNumeric, colorBin, colorQuantile, colorFactor. see https://rstudio.github.io/leaflet/colors.html

# Without a legend you don't understand what's going on
mp %>% 
    addCircleMarkers(
        data = shops.sel, 
        group = "circles",
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = ~rating.pal(rating),
        fillOpacity = 1 - pnt.ftrp,
        stroke = TRUE,
        color = 'black',
        weight = pnt.weight,
        opacity = 1 - pnt.trp
    ) %>% 
    addLegend(
        group = "circles",
        pal = rating.pal,
        values = shops.sel$rating,  # documentation says you should write ~rating, but doesn't work!
        title = 'Ratings',
        position = 'bottomright'
    )


# let's also add some simple label on mouse hover
mp %>% 
    addCircleMarkers(
        data = shops.sel,
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = ~rating.pal(rating),
        fillOpacity = 1 - pnt.ftrp,
        stroke = TRUE,
        color = 'black',
        weight = pnt.weight,
        opacity = 1 - pnt.trp,
        label = ~name
    )

# or some more involved, using HTML (notice that the more complex the building function, the longer to load and difficult the file )
build_point_label <- function(y){
    HTML(paste0(
        '<hr>',
            '<b>Name</b>: ', y$name, '<br>', 
            '<b>ID</b>: ', y$shop_ladid, '<br>', 
            '<b>Sector</b>: ', y$sector, '<br>', 
            '<b>Last Updated</b>: ', y$updated_at_fmt, '<br>', 
        '<hr>',
            '<b>Rating</b>: ', y$rating, '<br>', 
            '<b>Hygiene</b>: ', y$score_H, '<br>', 
            '<b>Structural</b>: ', y$score_S, '<br>', 
            '<b>Confidence</b>: ', y$score_C, '<br>', 
        '<hr>'
    ))
}
mp %>% 
    addCircleMarkers(
        data = shops.sel,
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = ~rating.pal(rating),
        fillOpacity = 1 - pnt.ftrp,
        stroke = TRUE,
        color = 'black',
        weight = pnt.weight,
        opacity = 1 - pnt.trp,
        label = lapply(1:nrow(shops.sel), function(x) build_point_label(shops.sel[x]))
    )

# we can also add popup on mouse click in the same way
mp %>% 
    addCircleMarkers(
        data = shops.sel,
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = ~rating.pal(rating),
        fillOpacity = 1 - pnt.ftrp,
        stroke = TRUE,
        color = 'black',
        weight = pnt.weight,
        opacity = 1 - pnt.trp,
        label = ~name,
        popup = lapply(1:nrow(shops.sel), function(x) build_point_label(shops.sel[x]))
    )

# it's better to use different layers for each group, and then add control menu to manage 
rt.lvls <- unique(droplevels(shops.sel$rating))
for(grp in rt.lvls){
    shops.sel.grp <- shops.sel[rating == grp]
    mp <- mp %>%
            addCircleMarkers(
                group = grp,
                data = shops.sel.grp,
                lng = ~x_lon, lat = ~y_lat,
                radius = pnt.radius,
                fill = TRUE,
                fillColor = ~rating.pal(rating),
                fillOpacity = 1 - pnt.ftrp,
                stroke = TRUE,
                color = 'black',
                weight = pnt.weight,
                opacity = 1 - pnt.trp,
                label = ~name,
                popup = lapply(1:nrow(shops.sel.grp), function(x) build_point_label(shops.sel.grp[x]))
            )
}
mp <- mp %>% 
	addLayersControl(
		baseGroups = c('OSM Mapnik', 'OSM B&W', 'Stamen Toner', 'Stamen Toner Lite', 'Hydda Full', 'Hydda Base'),
		overlayGroups = rt.lvls,
		options = layersControlOptions(collapsed = TRUE)
	)

mp <- mp %>% 
    addLegend(group = "circles",
        pal = rating.pal,
        values = shops.sel$rating,
        title = 'Ratings',
        position = 'bottomright'
    )

# Let's finally add a title
ttl <- paste('Distribution of Rating For Food Shop in', paste(lcn[location_id %in% area_ids, name], collapse = ' + '))
mp <- mp %>% 
	addControl(
		tags$div(HTML(paste0('<p style="font-size:20px;padding:10px 5px 10px 10px;margin:0px;background-color:#F7E816;">', 
		ttl, 
		'</p>'))), 
		position = 'bottomleft'
	)

# and save the map as HTML
saveWidget(mp, 
   # file.path('./food_shops_ratings/outputs', gsub(' ', '_', paste0(ttl, '.html'))), 
   'test.html',
   selfcontained = TRUE,
#   libdir = file.path(dpath, 'dependencies'),
   background = 'deepskyblue',
   title = ttl
)

# SECTORS ----------------------------------------------------------------------------------------------------------------------
attr_sectors <- data.table(
    sector_id = c(1, 5, 7, 14, 4613, 7838, 7839, 7840, 7841, 7842, 7843, 7844, 7845, 7846),
    st_group = factor(c(
        'Food', 'Services', 'Wholesalers', 'Wholesalers', 'Retailers', 'Farmers/growers', 'Wholesalers', 
        'Retailers', 'Food', 'Services', 'Services', 'Food', 'Services', 'Food'
    )),
    st_shape = c(21, 22, 23, 23, 24, 21, 23, 24, 21, 22, 22, 21, 22, 21),
    st_fill = factor(c(
        'limegreen', 'navy', 'orange', 'orange', 'brown', 'black', 'orange',
        'brown', 'limegreen', 'navy', 'navy', 'limegreen', 'navy', 'limegreen'
    )),
    st_outline = factor(c(
        'black', 'white', 'black', 'black', 'black', 'white', 'black', 
        'black', 'black', 'white', 'white', 'black', 'white', 'black'
    )),
    st_icon = factor(c(
        'helicopter', 'plane', 'cocktail', 'film', 'dumbbell', 'hospital', 'carcrash', 'usermd', 
        'briefcase', 'carbattery', 'shoppingcart', 'road', 'graduationcap', 'shoppingbag'
    ))
)
shops.sel <- attr_sectors[shops.sel, on = 'sector_id']

mp <- leaflet(options = leafletOptions(minZoom = 6)) %>%
        # center and zoom: UK
        fitBounds(shops.bb[1], shops.bb[2], shops.bb[3], shops.bb[4]) %>%
        # add maptiles
    	addProviderTiles(providers$OpenStreetMap.Mapnik, group = 'OSM Mapnik') %>%
    	addProviderTiles(providers$OpenStreetMap.BlackAndWhite, group = 'OSM B&W') %>%
    	addProviderTiles(providers$Stamen.Toner, group = 'Stamen Toner') %>%
    	addProviderTiles(providers$Stamen.TonerLite, group = 'Stamen Toner Lite') %>% 
    	addProviderTiles(providers$Hydda.Full, group = 'Hydda Full') %>%
    	addProviderTiles(providers$Hydda.Base, group = 'Hydda Base') %>% 
        # add map reset button 
        addResetMapButton()

st.lvls <- levels(shops.sel$st_group)
for(grp in st.lvls){
    shops.sel.grp <- shops.sel[st_group == grp]
    mp <- mp %>%
            addCircleMarkers(
                group = grp,
                data = shops.sel.grp,
                lng = ~x_lon, lat = ~y_lat,
                radius = pnt.radius * 2,
                fill = TRUE,
                fillColor = ~st_fill,
                fillOpacity = 1 - pnt.ftrp,
                stroke = TRUE,
                color = ~st_outline,
                weight = pnt.weight,
                opacity = 1 - pnt.trp,
                label = ~name,
                # label = ~as.character(as.numeric(rating) - 1),
                # labelOptions = labelOptions(
                #     noHide = TRUE, 
                #     offset = c(0, -2), 
                #     textOnly = TRUE,
                #     style = list('color' = 'white', 'font-family'= 'serif', 'font-style'= 'bold', 'font-size' = '12px')
                # ),
                popup = lapply(1:nrow(shops.sel.grp), function(x) build_point_label(shops.sel.grp[x]))
            ) %>%
            addLabelOnlyMarkers(
                group = grp,
                data = shops.sel.grp,
                lng = ~x_lon, lat = ~y_lat,
                label = ~as.character(as.numeric(rating) - 1),
                labelOptions = labelOptions(
                    noHide = TRUE, 
                    offset = c(-2, -2), 
                    textOnly = TRUE,
                    style = list('color' = 'white', 'font-family'= 'serif', 'font-style'= 'bold', 'font-size' = '12px')
                ),
            )
}
mp <- mp %>% 
	addLayersControl(
		baseGroups = c('OSM Mapnik', 'OSM B&W', 'Stamen Toner', 'Stamen Toner Lite', 'Hydda Full', 'Hydda Base'),
		overlayGroups = st.lvls,
		options = layersControlOptions(collapsed = TRUE)
	)

mp <- mp %>% 
    addLegend(group = "circles",
        pal = rating.pal,
        values = shops.sel$rating,
        title = 'Ratings',
        position = 'bottomright'
    )

# Let's finally add a title
ttl <- paste('Distribution of Rating For Food Shop in', paste(lcn[location_id %in% area_ids, name], collapse = ' + '))
mp <- mp %>% 
	addControl(
		tags$div(HTML(paste0('<p style="font-size:20px;padding:10px 5px 10px 10px;margin:0px;background-color:#F7E816;">', 
		ttl, 
		'</p>'))), 
		position = 'bottomleft'
	)


# CUSTOM ICONS ------------------------------------------------------------------------------------------------------------------
### see:
# https://ionicons.com/ open source
# https://fontawesome.com/icons?d=gallery&m=free some are free
# https://www.glyphicons.com/ not sure if there's still a basic free package

icon_set <- awesomeIconList( 
	helicopter = makeAwesomeIcon(icon = 'helicopter'),
	plane = makeAwesomeIcon(icon = 'plane'),
	cocktail = makeAwesomeIcon(icon = 'cocktail'),
	film = makeAwesomeIcon(icon = 'film'),
	dumbbell = makeAwesomeIcon(icon = 'dumbbell'),
	hospital = makeAwesomeIcon(icon = 'hospital'),
	carcrash = makeAwesomeIcon(icon = 'car-crash'),
	usermd = makeAwesomeIcon(icon = 'user-md'),
	briefcase = makeAwesomeIcon(icon = 'briefcase'),
	carbattery = makeAwesomeIcon(icon = 'car-battery'),
	shoppingcart = makeAwesomeIcon(icon = 'shopping-cart'),
	road = makeAwesomeIcon(icon = 'road'),
	graduationcap = makeAwesomeIcon(icon = 'graduation-cap'),
	shoppingbag = makeAwesomeIcon(icon = 'shopping-bag')
)

# use point symbols from base R graphics as icons: https://www.statmethods.net/advgraphs/images/points.png
pch_to_icons <- function(pch, fill, outline = 'black', width = 12, height = 12, ...) {
    n <- length(pch)
    files <- character(n)
    for (i in seq_len(n)) {
        f <- tempfile(fileext = '.png')
        png(f, width = width, height = height, bg = 'transparent')
        par(mar = c(0, 0, 0, 0))
        plot.new()
        points(.5, .5, pch = pch[i], col = outline[i], bg = fill[i], cex = min(width, height) / 8, ...)
        dev.off()
        files[i] <- f
    }
    files
}

