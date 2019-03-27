#########################################
# UK FOOD HYGIENE RATING - DATA DISPLAY #
#########################################

## Preparation ---------------------------------------------------------------------------------------------------------

# load packages
pkgs <- c('basictabler', 'classInt', 'data.table', 'DT', 'fst', 'RColorBrewer', 'scales')
invisible(lapply(pkgs, require, character.only = TRUE))

# set constants
data_path <- './food_shops_ratings/data'

# load data
lads <- fread(file.path(data_path, 'lads.csv'))
shops <- read.fst(file.path(data_path, 'shops'), as.data.table = TRUE)
oas <- read.fst(file.path(data_path, 'output_areas'), as.data.table = TRUE)
lcn <- read.fst(file.path(data_path, 'locations'), as.data.table = TRUE)

## Some query ----------------------------------------------------------------------------------------------------------

# check some famous brand
brand.pret <- shops[grepl('pret a manger', tolower(name))]

# not so easy for another one
brand.star <- shops[grepl('starbucks', tolower(name))]


## Average Ratings and Counting by Rating for Local Authorities --------------------------------------------------------

ys <- shops[as.numeric(rating) <= 6]
y <- dcast(ys, lad_id~(as.numeric(rating) -1 ))
ym <- ys[, .(avg = mean(as.numeric(rating) - 1, na.rm = TRUE)), lad_id]
y <- ym[y, on = 'lad_id']
y <- lads[, .(lad_id, name)][y, on = 'lad_id'][, lad_id := NULL]
setorder(y, 'name')
y <- cbind(y, rowSums(y[, as.character(0:5), with = FALSE]) )
    
dt <- datatable( 
        y, 
        rownames = FALSE ,
        colnames = c('Local Authority', 'Rating', 0:5, 'Total'),
        selection = 'none',
        class = 'cell-border nowrap',
        extensions = c('Buttons', 'FixedColumns', 'Scroller'),
        options = list(
            scrollX = TRUE,
            scrollY = 800,
            scroller = TRUE,
            fixedColumns = list(leftColumns = 1),
            searchHighlight = TRUE,
            buttons = c('copy', 'csv', 'print'),
            ordering = TRUE,
            columnDefs = list(list(className = 'dt-center', targets = 1)),
            deferRender = TRUE,
                initComplete = JS(
                    "function(settings, json) {",
                        "$(this.api().table().header()).css({
                            'text-align': 'center',
                            'background-color': '#000000', 
                            'color': '#F2FF00',
                            'font-size': '130%'
                        });",
                    "}"
                ),
            dom = 'Biftp'
        ) 
    ) 

dt <- dt %>% formatCurrency('avg', '', digits = 3) %>% formatCurrency(as.character(0:5), '', digits = 0)

n_cls <- 9
v_cls <- classIntervals(y$avg, n_cls)[[2]][2:n_cls]
dt <- dt %>% 
        formatStyle('avg', 
            `font-weight` = '600',
            backgroundColor = styleInterval(v_cls , brewer.pal(9, 'OrRd')),
            color = styleInterval( v_cls, c(rep('black', 6), rep('white', 3))) 
        )
bars_col <- c('orangered', 'darkorange', 'gold', 'paleturquoise', 'lightskyblue', 'palegreen')
show_col(bars_col)
for(idx in as.character(0:5))
    dt <- dt %>% 
        formatStyle(idx,
           background = styleColorBar( y[, get(idx)], bars_col[as.numeric(idx) + 1] ),
           backgroundSize = '90% 75%',
           backgroundRepeat = 'no-repeat',
           backgroundPosition = 'center'
        )


saveWidget(dt, 
   file.path(getwd(), 'food_shops_ratings', 'outputs', 'ratings_by_lads.html'), 
   selfcontained = TRUE,
   libdir = 'dependencies',
   background = 'deepskyblue',
   title = 'Average and Counting Ratings by Local Autorithies'
)

## Average Ratings for Local Authority by Sector --------------------------------------------------------------------------------

ys <- shops[as.numeric(rating) <= 6][, ratingn := as.numeric(rating) - 1]
y <- dcast(ys, lad_id~sector, fun.aggregate = mean, value.var = 'ratingn', fill = NA)
ym <- ys[, .(avg = mean(ratingn, na.rm = TRUE)), lad_id]
y <- ym[y, on = 'lad_id']
y <- lads[, .(lad_id, name)][y, on = 'lad_id'][, lad_id := NULL]
setorder(y, 'name')

dt <- datatable( 
        y, 
        rownames = FALSE ,
        colnames = c('Local Authority' = 'name', 'Total Rating' = 'avg'),
        selection = 'none',
        class = 'cell-border nowrap',
        extensions = c('Buttons', 'FixedColumns', 'Scroller'),
        options = list(
            scrollX = TRUE,
            scrollY = 800,
            scroller = TRUE,
            fixedColumns = list(leftColumns = 2),
            searchHighlight = TRUE,
            buttons = c('copy', 'csv', 'print'),
            ordering = TRUE,
            columnDefs = list(list(className = 'dt-center', targets = 1:(ncol(y) - 1))),
            deferRender = TRUE,
                initComplete = JS(
                    "function(settings, json) {",
                        "$(this.api().table().header()).css({
                            'text-align': 'center',
                            'background-color': '#000000', 
                            'color': '#F2FF00',
                            'font-size': '120%'
                        });",
                    "}"
                ),
            dom = 'Biftp'
        ) 
    ) 

dt <- dt %>% formatCurrency(1:ncol(y), '', digits = 3) 

brks <- quantile(y[,2:ncol(y)], probs = seq(.05, .95, .05), na.rm = TRUE)
clrs <- round(seq(255, 40, length.out = length(brks) + 1), 0) %>%
  {paste0("rgb(255,", ., ",", ., ")")}
dt <- dt %>% formatStyle(2:ncol(y), backgroundColor = styleInterval(brks, rev(clrs)))
