########################################
# UK GENDER PAY GAP - DATA MAPS POINTS #
########################################

# load packages
pkgs <- c('data.table', 'fst', 'htmlwidgets', 'htmltools', 'leaflet', 'leaflet.extras', 'rgeos', 'sp')
invisible(lapply(pkgs, require, character.only = TRUE))

# set constants
data_path <- './gender_paygap/data'
geo_path <- '../uk_geography/datasets'
bnd_path <- '../uk_geography/boundaries/'
cols_geo <- c('LSOA', 'MSOA', 'LAD', 'CTY', 'RGN', 'CTRY', 'WARD', 'PCON', 'CCG')

# load data
dts <- read.fst(file.path(data_path, 'dts'), as.data.table = TRUE)
dts <- dts[!is.na(x_lon) & datefield == 2018]
sic <- fread(file.path(data_path, 'sic.csv'))
sections <- fread(file.path(data_path, 'sections.csv'))
vars <- fread(file.path(data_path, 'vars.csv'))
oas <- read.fst(file.path(geo_path, 'output_areas'), as.data.table = TRUE)
lcn <- read.fst(file.path(geo_path, 'locations'), as.data.table = TRUE)

# set style constant
pnt.radius = 6
pnt.ftrp = 0.2
pnt.weight = 1
pnt.trp = 0

# subset to London
area_type <- 'CTY'
area_ids <- lcn[type == area_type & grepl('london', tolower(name)), location_id ]
dts.sel <- dts[OA %in% oas[get(area_type) %in% area_ids, OA]]
# dts.sel <- dts[OA %in% oas[get(area_type) == 'E13000001', OA]]
# dts.sel <- dts.sel[shop_id %in% sample(dts.sel$shop_id, 2500)]
# area_type <- 'LAD'
# area_ids <- lcn[type == area_type & grepl('southwark', tolower(name)), location_id ]
# dts.sel <- dts[OA %in% oas[get(area_type) %in% area_ids, OA]]
# dts.sel <- copy(dts)

# gets the centroid coords of the chosen area
dts.sel <- dts.sel[DMdH > - 40 & DMdH < 40]
dts.sp <- SpatialPoints(dts.sel[, .(x_lon, y_lat)])
proj4string(dts.sp) <- CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0')
dts.bb <- gConvexHull(dts.sp)@bbox

mp <- leaflet(options = leafletOptions(minZoom = 6)) %>%
        # center and zoom: UK
        fitBounds(dts.bb[1], dts.bb[2], dts.bb[3], dts.bb[4]) %>%
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
        data = dts.sel,
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
mtc.pal <- colorNumeric(c("#FF0A0A", "#DB9D63", "#E0E065", "#96D4ED", "#17EB17"), dts.sel$DMdH) # use RStudio colourpicker addin
mtc.pal <- colorBin('BrBG', dts.sel$DMdH, 6, pretty = FALSE, reverse = TRUE) # use ColorBrewer http://colorbrewer2.org/
mtc.pal <- colorQuantile('viridis', dts.sel$DMdH, n = 10, reverse = TRUE) # use Pythonista Viridis https://bids.github.io/colormap/
mp %>% 
    addCircleMarkers(
        data = dts.sel,
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = ~mtc.pal(DMdH),
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
        data = dts.sel, 
        group = "circles",
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = ~mtc.pal(DMdH),
        fillOpacity = 1 - pnt.ftrp,
        stroke = TRUE,
        color = 'black',
        weight = pnt.weight,
        opacity = 1 - pnt.trp
    ) %>% 
    addLegend(
        group = "circles",
        pal = mtc.pal,
        values = dts.sel$DMdH,  # documentation says you should write ~rating, but doesn't work!
        title = 'Gender Hourly Pay Gap: Median',
        position = 'bottomright'
    )


# let's also add some simple label on mouse hover
mp %>% 
    addCircleMarkers(
        data = dts.sel,
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = ~mtc.pal(DMdH),
        fillOpacity = 1 - pnt.ftrp,
        stroke = TRUE,
        color = 'black',
        weight = pnt.weight,
        opacity = 1 - pnt.trp,
        label = ~company_name
    )

# or some more involved, using HTML (notice that the more complex the building function, the longer to load and difficult the file )
build_point_label <- function(y){
    HTML(paste0(
        '<hr>',
            '<b>Company</b>: ', y$company_name, '<br>', 
            '<b>ID</b>: ', y$company_id, '<br>', 
            '<b>SIC</b>: ', y$sic, '<br>', 
            '<b>Section</b>: ', y$dsection, '<br>', 
            '<b>Size</b>: ', y$size, '<br>', 
            '<b>Last Updated</b>: ', 'N/A', '<br>', 
        '<hr>',
            '<b>Gender Hourly Pay Gap: Mean</b>: ', y$DMH, '<br>', 
            '<b>Gender Hourly Pay Gap: Median</b>: ', y$DMdH, '<br>', 
            '<b>Gender Bonus Pay Gap: Mean</b>: ', y$DMB, '<br>', 
            '<b>Gender Bonus Pay Gap: Median</b>: ', y$DMdB, '<br>', 
        '<hr>'
    ))
}
mp %>% 
    addCircleMarkers(
        data = dts.sel,
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = ~mtc.pal(DMdH),
        fillOpacity = 1 - pnt.ftrp,
        stroke = TRUE,
        color = 'black',
        weight = pnt.weight,
        opacity = 1 - pnt.trp,
        label = lapply(1:nrow(dts.sel), function(x) build_point_label(dts.sel[x]))
    )

# we can also add popup on mouse click in the same way
mp %>% 
    addCircleMarkers(
        data = dts.sel,
        lng = ~x_lon, lat = ~y_lat,
        radius = pnt.radius,
        fill = TRUE,
        fillColor = ~mtc.pal(DMdH),
        fillOpacity = 1 - pnt.ftrp,
        stroke = TRUE,
        color = 'black',
        weight = pnt.weight,
        opacity = 1 - pnt.trp,
        label = ~company_name,
        popup = lapply(1:nrow(dts.sel), function(x) build_point_label(dts.sel[x]))
    )

# we can also use different layers for each size, and then add control menu to manage 
rt.lvls <- sort(unique(droplevels(dts.sel$size)))
for(grp in rt.lvls){
    dts.sel.grp <- dts.sel[size == grp]
    if(nrow(dts.sel.grp) > 0)
        mp <- mp %>%
                addCircleMarkers(
                    group = grp,
                    data = dts.sel.grp,
                    lng = ~x_lon, lat = ~y_lat,
                    radius = pnt.radius,
                    fill = TRUE,
                    fillColor = ~mtc.pal(DMdH),
                    fillOpacity = 1 - pnt.ftrp,
                    stroke = TRUE,
                    color = 'black',
                    weight = pnt.weight,
                    opacity = 1 - pnt.trp,
                    label = ~company_name,
                    popup = lapply(1:nrow(dts.sel.grp), function(x) build_point_label(dts.sel.grp[x]))
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
        pal = mtc.pal,
        values = dts.sel$DMdH,
        title = 'Gender Hourly Pay Gap: Median',
        position = 'bottomright'
    )

# Let's finally add a title
ttl <- paste('Distribution of Median Gender Hourly Pay Gap in', paste(lcn[location_id %in% area_ids, name], collapse = ' + '))
# ttl <- 'Distribution of Median Gender Hourly Pay Gap'
mp <- mp %>% 
	addControl(
		tags$div(HTML(paste0('<p style="font-size:20px;padding:10px 5px 10px 10px;margin:0px;background-color:#F7E816;">', 
		ttl, 
		'</p>'))), 
		position = 'bottomleft'
	)

# and save the map as HTML
saveWidget(mp, 
  # file.path('.', 'gender_paygap', 'outputs', gsub(' ', '_', paste0(ttl, '.html'))), 
   'test.html',
   selfcontained = TRUE,
#   libdir = file.path(dpath, 'dependencies'),
   background = 'deepskyblue',
   title = ttl
)

