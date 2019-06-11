################################################
# SHINYAPP TEMPLATE * MULTIPLE DIRS * global.R #
################################################
# Settings and calls for packages and objects common to both ui and server
# How to copy to shiny server folder:
# - mkdir -p /srv/shiny-server/uk_gender_paygap/data
# - cp -R ~/workshops/shiny_gender_paygap/templates/multiple_dirs/* /srv/shiny-server/uk_gender_paygap
# - cp ~/workshops/shiny_gender_paygap/data/* /srv/shiny-server/uk_gender_paygap/data
# check logs at /var/log/shiny-server/

## load packages ------
pkgs <- c(
    # DATA WRANGLING, UTILITIES
    'classInt', 'data.table', 'fst', 'htmltools', 'scales',
    'bcrypt', 'crosstalk', 'htmltools', 'htmlwidgets',
    # DATA DISPLAY
    'DT', 'extrafont', 'formattable', 'kableExtra', 'rhandsontable', 'rpivotTable',
    # DATA VIZ
    'ggplot2', 'geofacet', 'GGally', 'ggiraph', 'ggmosaic', 'ggparallel', 'ggrepel', 'ggridges', 'ggthemes',
    'bpexploder', 'dygraphs', 'echarts4r', 'plotly', 'rbokeh', 'scatterD3', 'trelliscopejs', 'wordcloud2',
    'leaflet', 'leaflet.extras', 'leaflet.opacity', 'mapview', 'tmap',
    'Cairo', 'dichromat', 'extrafont', 'RColorBrewer', 'scico', 'viridis', 'wesanderson',
    # SHINY
    'shiny', 'rmarkdown', 'shinycssloaders', 'shinycustomloader', 'shinyjqui', 'shinyjs', 'shinyWidgets',
    'bs4Dash', 'flexdashboard', 'shinydashboard',
    'bsplus', 'colourpicker', 'fontawesome', 'rintrojs', 'shinymaterial', 'shinythemes'
)
lapply(pkgs, require, char = TRUE)

## load data ------
data_path <- '~/workshops/shiny_gender_paygap/data'
www_path <- '~/workshops/shiny_gender_paygap/www'
dts <- read_fst(file.path(data_path, 'dataset'), as.data.table = TRUE)
mtcs <- fread(file.path(data_path, 'metrics.csv'))
lcn <- read_fst(file.path(data_path, 'locations'), as.data.table = TRUE)
bnd <- readRDS(file.path(data_path, 'boundaries'))

## general options -------
options(spinner.color = '#e5001a', spinner.size = 1, spinner.type = 4)
options(bitmapType = 'cairo', shiny.usecairo = TRUE)
options(knitr.table.format = 'html')

## helpers / lookups -------

# list of company activities sections
sections <- levels(dts$section_desc)

# list of company sizes
sizes <- levels(dts$size)

# list of geographic areas
cols_geo <- c('LAD', 'CTY', 'RGN', 'CTRY', 'PCD', 'PCT', 'PCA', 'PCON', 'CCG')
names(cols_geo) <- c('Local Authority', 'County', 'Region', 'Country', 'Postcode District', 'Postal Town', 'Postcode Area', 'Constituency', 'Clinical Commission')

# list of items in each geographic areas
lcn.lst <- list()
for(g in 1:length(cols_geo)){
    lcn.lst[[g]] <- as.list(lcn[type == cols_geo[g], location_id])
    names(lcn.lst[[g]]) <- lcn[type == cols_geo[g], name]
}
names(lcn.lst) <- cols_geo

# list of positions of a helper object 
pos.lst <- c('bottomright', 'bottomleft', 'topleft', 'topright')

# list of palettes to be used with the ColorBrewer package:  
palette.lst <- list(
    'SEQUENTIAL' = c( # ordinal data where (usually) low is less important and high is more important
        'Blues' = 'Blues', 'Blue-Green' = 'BuGn', 'Blue-Purple' = 'BuPu', 'Green-Blue' = 'GnBu', 'Greens' = 'Greens', 'Greys' = 'Greys',
        'Oranges' = 'Oranges', 'Orange-Red' = 'OrRd', 'Purple-Blue' = 'PuBu', 'Purple-Blue-Green' = 'PuBuGn', 'Purple-Red' = 'PuRd', 'Purples' = 'Purples',
        'Red-Purple' = 'RdPu', 'Reds' = 'Reds', 'Yellow-Green' = 'YlGn', 'Yellow-Green-Blue' = 'YlGnBu', 'Yellow-Orange-Brown' = 'YlOrBr',
        'Yellow-Orange-Red' = 'YlOrRd'
    ), 
    'DIVERGING' = c(  # ordinal data where both low and high are important (i.e. deviation from some reference "average" point)
        'Brown-Blue-Green' = 'BrBG', 'Pink-Blue-Green' = 'PiYG', 'Purple-Red-Green' = 'PRGn', 'Orange-Purple' = 'PuOr', 'Red-Blue' = 'RdBu', 'Red-Grey' = 'RdGy',
        'Red-Yellow-Blue' = 'RdYlBu', 'Red-Yellow-Green' = 'RdYlGn', 'Spectral' = 'Spectral'
    ),  
    'QUALITATIVE' = c(  # categorical/nominal data where there is no logical order
        'Accent' = 'Accent', 'Dark2' = 'Dark2', 'Paired' = 'Paired', 'Pastel1' = 'Pastel1', 'Pastel2' = 'Pastel2',
        'Set1' = 'Set1', 'Set2' = 'Set2', 'Set3' = 'Set3'
    )
)

# list of options for charts
point.shapes <- c('circle' = 21, 'square' = 22, 'diamond' = 23, 'triangle up' = 24, 'triangle down' = 25)
line.types <- c('dashed', 'dotted', 'solid', 'dotdash', 'longdash', 'twodash')
face.types <- c('plain', 'bold', 'italic', 'bold.italic')
val.lbl.pos <- list(
    'Inside'  = list('Vertical' = c(0.5,  1.5), 'Horizontal' = c( 1.2, 0.2) ),
    'Outside' = list('Vertical' = c(0.4, -0.3), 'Horizontal' = c(-0.2, 0.2) )
)
lbl.format <- function(y, type, is.pct = FALSE){
    if(type == 1){ 
        format(y, big.mark = ',', nsmall = 0)
    } else if(type == 2){ 
        if(is.pct){ 
            paste0(format(round(100 * y, 2), nsmall = 2), '%')
        } else { 
            format(y, big.mark = ',', nsmall = 0)
        }    
    } else {
        format(y, nsmall = 2)
    }
}

# list of options for labels in maps
lbl.options <- labelOptions(
    textsize = '12px', direction = 'right', sticky = FALSE, opacity = 0.8,
    offset = c(60, -40), style = list('font-weight' = 'normal', 'padding' = '2px 6px')
)

# list of classification methods, to be used with classInt and ColorBrewer packages 
class.methods <- c(
    'Fixed' = 'fixed',                  # need an additional argument fixedBreaks that lists the n+1 values to be used
    'Equal Intervals' = 'equal',        # the range of the variable is divided into n part of equal space
    'Quantiles' = 'quantile',           # each class contains (more or less) the same amount of values
    'Pretty Integers' = 'pretty',       # sequence of about â€˜n+1â€™ equally spaced â€˜roundâ€™ values which cover the range of the values in â€˜xâ€™. The values are chosen so that they are 1, 2 or 5 times a power of 10.
    'Natural Breaks' = 'jenks',         # seeks to reduce the variance within classes and maximize the variance between classes
    'Hierarchical Cluster' = 'hclust',  # Cluster with short distance
    'K-means Cluster' = 'kmeans'        # Cluster with low variance and similar size
)

# fixed breaks (usually decided/constrained by business rules)
fixed_brks <- c(0, 0.0025, 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 0.75, 1)

# list of maptiles as background for maps
tiles.lst <- as.list(maptiles[, provider])
names(tiles.lst) <- maptiles[, name]

## define functions ------

# return list of items in a specified parent area/code
get_geo_areas <- function(child_type, child_code = NA, parent_type = NA, parent_code = NA){
    if(is.na(child_code))
        child_code <- dts[get(parent_type) == parent_code, get(child_type)]
    y <- lcn.lst[[child_type]][lcn.lst[[child_type]] %in% child_code]
    y[order(names(y))]
}

# convert a ggplot into its corresponding interactive plot from ggiraph extension
gg.to.ggiraph <- function(p, sel.type = 'single', gg.width = 0.8){
        ggiraph( ggobj = p, 
            width  = gg.width,
            zoom_max  = 1,
            selection_type = sel.type,
            # selected_css = "",
            tooltip_offx = 20, tooltip_offy = -10,
            hover_css = "fill:red;cursor:pointer;r:4pt;opacity-value:0.5;",
            tooltip_extra_css= "background-color:wheat;color:gray20;border-radius:10px;padding:3pt;",
            tooltip_opacity = 0.9,
            pointsize = 12
        )
}

## styles / themes ------

# add text at the left of the upper navbar
navbarPageWithText <- function(..., text) {
    navbar <- navbarPage(...)
    textEl <- tags$p(class = "navbar-text", text)
    navbar[[3]][[1]]$children[[1]] <- tagAppendChild( navbar[[3]][[1]]$children[[1]], textEl)
    navbar
}

# return correct spacing for axis labels rotation
lbl.plt.rotation = function(angle, position = 'x'){
    positions = list(x = 0, y = 90, top = 180, right = 270)
    rads  = (angle - positions[[ position ]]) * pi / 180
    hjust = 0.5 * (1 - sin(rads))
    vjust = 0.5 * (1 + cos(rads))
    element_text(angle = angle, vjust = vjust, hjust = hjust)
}

# global style for ggplot charts
my.ggtheme <- function(g, 
                       xaxis.draw = FALSE, yaxis.draw = FALSE, axis.draw = FALSE, ticks.draw = FALSE, axis.colour = 'black', axis.size = 0.1,
                       hgrid.draw = FALSE, vgrid.draw = FALSE, grids.colour = 'black', grids.size = 0.1, grids.type = 'dotted',
                       labels.rotation = c(45, 0), labels.rotate = FALSE, 
                       bkg.colour = 'white', font.size = 6, ttl.font.size.mult = 1.2, ttl.face = 'bold',
                       legend.pos = 'bottom', plot.border = FALSE, font.family = 'Arial'
){
    g <- g + theme(
        text             = element_text(family = font.family),
        plot.title       = element_text(hjust = 0, size = rel(1.2) ),  # hjust: 0-left, 0.5-center, 1-right
        plot.background  = element_blank(),
        plot.margin      = unit(c(1, 0.5, 0, 0.5), 'lines'),  # space around the plot as in: TOP, RIGHT, BOTTOM, RIGHT
        plot.caption     = element_text(size = 8, face = 'italic'),
        axis.line        = element_blank(),
        axis.ticks       = element_blank(),
        axis.text        = element_text(size = font.size, color = axis.colour),
        axis.text.x      = element_text(angle = labels.rotation[1], hjust = 1), # vjust = 0.5),
        axis.text.y      = element_text(angle = labels.rotation[2]), # , hjust = , vjust = ),
        axis.title       = element_text(size = font.size * (1 + ttl.font.size.mult), face = ttl.face),
        axis.title.x     = element_text(vjust = -0.3), 
        axis.title.y     = element_text(vjust = 0.8, margin = margin(0, 10, 0, 0) ),
        legend.text      = element_text(size = 6),
        legend.title     = element_text(size = 8), 
        legend.title.align = 1,
        legend.position  = legend.pos,
        legend.background = element_blank(), 
        legend.spacing   = unit(0, 'cm'),
        #                legend.key = element_blank(), 
        legend.key.size  = unit(0.2, 'cm'),
        legend.key.height = unit(0.4, 'cm'),      
        legend.key.width = unit(1, 'cm'),
        panel.background = element_rect(fill = bkg.colour, colour = bkg.colour), 
        panel.border     = element_blank(),
        panel.grid       = element_blank(),
        panel.spacing.x  = unit(3, 'lines'),
        panel.spacing.y  = unit(2, 'lines'),
        strip.text       = element_text(hjust = 0.5, size = font.size * (1 + ttl.font.size.mult), face = ttl.face),
        strip.background = element_blank()
    )
    if(plot.border) g <- g + theme( panel.border = element_rect(colour = axis.colour, size = axis.size, fill = NA) )
    if(axis.draw){
        g <- g + theme( axis.line = element_line(color = axis.colour, size = axis.size ) )
    } else {
        if(xaxis.draw) g <- g + theme( axis.line.x = element_line(color = axis.colour, size = axis.size ) )
        if(yaxis.draw) g <- g + theme( axis.line.y = element_line(color = axis.colour, size = axis.size ) )
    }
    if(ticks.draw)  g <- g + theme( axis.ticks = element_line(color = axis.colour, size = axis.size ) )
    if(hgrid.draw & vgrid.draw){
        g <- g + theme( panel.grid.major = element_line(colour = grids.colour, size = grids.size, linetype = grids.type ) )
    } else{
        if(vgrid.draw) g <- g + theme( panel.grid.major.x = element_line(colour = grids.colour, size = grids.size, linetype = grids.type ) ) 
        if(hgrid.draw) g <- g + theme( panel.grid.major.y = element_line(colour = grids.colour, size = grids.size, linetype = grids.type ) )
    }
    if(labels.rotate){
        g <- g + theme( axis.text.x = element_text(hjust = 1, angle = 45 ) )
    }
    return(g)
}

