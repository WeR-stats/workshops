#######################################
# UK GENDER PAY GAP - DATA VIZ STATIC #
#######################################

## Preparation ---------------------------------------------------------------------------------------------------------

# load packages
pkgs <- c('data.table', 'fst', 'ggplot2', 'ggiraph', 'ggridges', 'ggthemes', 'RColorBrewer', 'viridis')
invisible(lapply(pkgs, require, character.only = TRUE))

# set constants
data_path <- './gender_paygap/data'
geo_path <- '../uk_geography/datasets'
bnd_path <- '../uk_geography/boundaries/'
cols_geo <- c('LSOA', 'MSOA', 'LAD', 'CTY', 'RGN', 'CTRY', 'WARD', 'PCON', 'CCG')

# load data
dts <- read.fst(file.path(data_path, 'dts'), as.data.table = TRUE)
sic <- fread(file.path(data_path, 'sic.csv'))
sections <- fread(file.path(data_path, 'sections.csv'))
vars <- fread(file.path(data_path, 'vars.csv'))
lcn <- read.fst(file.path(geo_path, 'locations'), as.data.table = TRUE)

# build tidy dts
fix_cols <- names(dts)[1:which(names(dts) == 'WPZ')]
mtc_cols.gap <- c('DMH', 'DMdH', 'DMB', 'DMdB')
mtc_cols.sex <- names(dts)[which(names(dts) == 'BPM'):ncol(dts)]
dts.g <- melt(dts, id.vars = fix_cols, measure.vars = mtc_cols.gap, variable.name = 'metric')
dts.s <- melt(dts, id.vars = fix_cols, measure.vars = mtc_cols.sex)
dts.s[, c('metric', 'sex') := tstrsplit(variable, "(?<=.{2})", perl = TRUE)][, variable := NULL]

# HISTOGRAMS ----------------------------------------------------------------------------------------------------------



# BOXPLOTS ----------------------------------------------------------------------------------------------------------
y <- dts.g[datefield == 2018 & metric == 'DMdH' & value > - 50 & value < 50]
ggplot(y[!is.na(size)], aes(metric, value, fill = size)) +
    geom_boxplot() +
    theme_minimal()

ggplot(y[!is.na(section)], aes(metric, value, fill = section)) +
    geom_boxplot() +
    theme_minimal()

my_gg <- 
    ggplot(y[!is.na(section)], aes(metric, value, fill = section)) + 
        geom_boxplot_interactive(aes(tooltip = dsection), size = 2) +
        theme_few()
girafe(code = print(my_gg) )

var_sel <- 'RGN'
y1 <- lcn[type == var_sel, .(location_id, name)][y, on = c(location_id = var_sel)][, location_id := NULL][order(name)]
y1 <- y1[!is.na(section) & !is.na(name)]
ggplot(y1, aes(metric, value, fill = name)) +
    geom_boxplot() + 
    facet_wrap(~section) +
    theme_economist()

y <- dts.s[datefield == 2018 & grepl('Q', metric)]
y <- y[!is.na(section)]
ggplot(y, aes(metric, value, color = sex)) + 
    geom_boxplot() + 
    facet_wrap(~section) +
    theme_minimal()

y <- y[!is.na(size)]
ggplot(y, aes(metric, value, color = sex)) + 
    geom_boxplot() + 
    facet_grid(size~section) +
    theme_minimal()


## TILES ----------------------------------------------------------------------------------------------------------
my_gg <- 
    ggplot(y[!is.na(section) & !is.na(size)], aes(size, section)) + 
        geom_tile_interactive(aes(fill = value, tooltip = value), colour = "white") +
        scale_fill_gradient(low = "green", high = "red") +
        facet_wrap(~section) +
        coord_equal() +
        theme_few()
girafe(code = print(my_gg) )


## RIDGES ----------------------------------------------------------------------------------------------------------
y <- dts.g[datefield == 2018 & metric == 'DMH']
ggplot(y, aes(value, section)) + 
    geom_density_ridges() +
    theme_few() # get(paste0('theme_', thm, '()'))


y <- y[value > -60 & value < 60]
ggplot(y, aes(value, section)) + 
    geom_density_ridges() +
    theme_few() # get(paste0('theme_', thm, '()'))


ggplot(y, aes(value, section)) + 
    geom_density_ridges(jittered_points = TRUE, position = 'raincloud', alpha = 0.7, scale = 0.9) + 
    theme_ridges()

ggplot(y, aes(value, section, fill = ..x..)) + 
    geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01, gradient_lwd = 1.) +
    scale_fill_viridis(name = '', option = 'C') +
    theme_economist_white()


y <- dts.s[datefield == 2018 & metric == 'Q1']
ggplot(y, aes(value, section, fill = sex)) + 
    geom_density_ridges() +
    scale_fill_manual(values = c('#D55E0050', '#0072B250'), labels = c('female', 'male')) +
    scale_color_manual(values = c('#D55E00', '#0072B2'), guide = 'none') +
    scale_discrete_manual('point_color', values = c('#D55E00', '#0072B2'), guide = 'none') +
    guides(fill = guide_legend( override.aes = list( fill = c('#D55E00A0', '#0072B2A0'), color = NA, point_color = NA) ) ) +
    theme_ridges(center = TRUE)

get_ridges <- function(
                var_sel, mtc = 'DMH', min_mtc = -60, max_mtc = 60, dte = 2018, 
                sub_type = NA, sub_code = NA, fct = NA, thm = 'few'
    ){
        y <- dts.g[datefield == dte & metric == mtc]
        if(!is.na(min_mtc)) y <- y[value > min_mtc]
        if(!is.na(max_mtc)) y <- y[value < max_mtc]
        if(!is.na(sub_type)) y <- y[get(sub_type) == sub_code]
        if(var_sel %in% cols_geo){
            y <- lcn[type == var_sel, .(location_id, name)][y, on = c(location_id = var_sel)][, location_id := NULL][order(name)]
            setnames(y, 'name', var_sel)
        }
        y <- y[!is.na(get(var_sel))]
        ggplot(y, aes(value, get(var_sel))) + 
            geom_density_ridges() +
            labs(x = vars[var_id == mtc, description], y = var_sel) +
            theme_few() # get(paste0('theme_', thm, '()'))
}
get_ridges('section', min_mtc = -10, max_mtc = 20)
get_ridges('RGN', min_mtc = -10, max_mtc = 20)
get_ridges('LAD', sub_type = 'RGN', sub_code = 'E12000001', min_mtc = -10, max_mtc = 20)
get_ridges('WPZ', sub_type = 'LAD', sub_code = 'E09000028', min_mtc = -10, max_mtc = 20)
