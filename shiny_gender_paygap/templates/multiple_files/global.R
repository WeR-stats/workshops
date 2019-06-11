#################################################
# SHINYAPP TEMPLATE * MULTIPLE FILES * global.R #
#################################################
# Settings and calls for packages and objects common to both ui and server

# load packages ------
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

# load data ------
data_path <- '~/workshops/shiny_gender_paygap/data'
dts <- read_fst(file.path(data_path, 'dataset'), as.data.table = TRUE)
mtcs <- fread(file.path(data_path, 'metrics.csv'))
lcn <- read_fst(file.path(data_path, 'locations'), as.data.table = TRUE)
bnd <- readRDS(file.path(data_path, 'boundaries'))

# create ancillary long form datasets
fix_cols <- names(dts)[1:which(names(dts) == 'datefield')]
mtc_cols.gap <- c('DMH', 'DMdH', 'DMB', 'DMdB')
mtc_cols.sex <- names(dts)[which(names(dts) == 'BPM'):ncol(dts)]
dts.g <- melt(dts, id.vars = fix_cols, measure.vars = mtc_cols.gap, variable.name = 'metric')
dts.s <- melt(dts, id.vars = fix_cols, measure.vars = mtc_cols.sex)
dts.s[, c('metric', 'sex') := tstrsplit(variable, "(?<=.{2})", perl = TRUE)][, variable := NULL]

# set constants ------
sections <- levels(dts$section_desc)
sizes <- levels(dts$size)
cols_geo <- c('LAD', 'CTY', 'RGN', 'CTRY', 'PCD', 'PCT', 'PCA', 'PCON', 'CCG')
names(cols_geo) <- c('Local Authority', 'County', 'Region', 'Country', 'Postcode District', 'Postal Town', 'Postcode Area', 'Constituency', 'Clinical Commission')
metrics <- mtcs$code
names(metrics) <- mtcs$description

# list of geographic areas
lcn.lst <- list()
for(g in 1:length(cols_geo)){
    lcn.lst[[g]] <- as.list(lcn[type == cols_geo[g], location_id])
    names(lcn.lst[[g]]) <- lcn[type == cols_geo[g], name]
}
names(lcn.lst) <- cols_geo

# general options ------
options(spinner.color = '#e5001a', spinner.size = 1, spinner.type = 4)
options(bitmapType = 'cairo', shiny.usecairo = TRUE)
options(knitr.table.format = 'html')

# define functions ------


get_geo_areas <- function(child_type, child_code = NA, parent_type = NA, parent_code = NA){
    if(is.na(child_code) & is.na(parent_type)){
        y <- lcn.lst[[child_type]]
    } else {
        if(is.na(child_code))
            child_code <- dts[get(parent_type) == parent_code, get(child_type)]
        y <- lcn.lst[[child_type]][lcn.lst[[child_type]] %in% child_code]
    }
    y[order(names(y))]
}


# styles and themes ------

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

