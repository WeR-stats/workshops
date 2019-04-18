#####################################
# UK GENDER PAY GAP - DATA DISPLAY #
####################################

## Preparation ---------------------------------------------------------------------------------------------------------

# load packages
pkgs <- c('basictabler', 'classInt', 'data.table', 'DT', 'fst', 'RColorBrewer', 'scales')
invisible(lapply(pkgs, require, character.only = TRUE))

# set constants
data_path <- './gender_paygap/data'
geo_path <- '../uk_geography/datasets'
bnd_path <- '../uk_geography/boundaries/'
geo_cols <- c('LSOA', 'MSOA', 'LAD', 'CTY', 'RGN', 'CTRY', 'WARD', 'PCON', 'CCG')

# load data
dts <- read.fst(file.path(data_path, 'dts'), as.data.table = TRUE)
sic <- fread(file.path(data_path, 'sic.csv'))
sections <- fread(file.path(data_path, 'sections.csv'))
vars <- fread(file.path(data_path, 'vars.csv'))
lcn <- read.fst(file.path(geo_path, 'locations'), as.data.table = TRUE)

## Simple tables ---------------------------------------------------------------------------------------------------------

# Totals by size
y <- dts[datefield == 2018]
qhtbl(y[, .N, size], firstColumnAsRowHeaders = TRUE, columnFormats = list(NULL, list(big.mark = ',')))
qhtbl(rbindlist(list( y[, .N, size], c('TOTAL', y[, .(.N)]) )), firstColumnAsRowHeaders = TRUE, columnFormats = list(NULL, list(big.mark = ',')))

# Totals by section with pct distribution
y <- dts[datefield == 2018]
qhtbl(
  y[, .N, dsection][, pct := 100*N/sum(N)][order(dsection)],
  firstColumnAsRowHeaders = TRUE,
  columnFormats = list(NULL, list(big.mark = ","), "%1.2f%%")
)

# Average Metrics by section
y <- dts[datefield == 2018]
cols <- names(dts)[((which(names(dts) == 'DMH')):ncol(dts))]
y <- y[, lapply(.SD, mean, na.rm = TRUE), dsection,  .SDcols = cols][order(dsection)]
tbl <- BasicTable$new()
tbl$addData(y, 
        firstColumnAsRowHeaders = TRUE, 
        explicitColumnHeaders = c('Section', vars$description),
        columnFormats = rep(list("%.2f"), ncol(y))
)
cells <- tbl$findCells(columnNumbers = 2:5, maxValue = 0, includeNull = FALSE, includeNA = FALSE)
tbl$setStyling(cells = cells, declarations = list("background-color" = "#38EB6B", "color" = "#9C0006"))
cells <- tbl$findCells(columnNumbers = 2:5, minValue = 20, maxValue = 40, includeNull = FALSE, includeNA = FALSE)
tbl$setStyling(cells = cells, declarations = list("background-color" = "#FFC60A", "color" = "#9C0006"))
cells <- tbl$findCells(columnNumbers = 2:5, minValue = 40, includeNull = FALSE, includeNA = FALSE)
tbl$setStyling(cells = cells, declarations = list("background-color" = "#FF050D", "color" = "#9C0006"))
tbl$renderTable()

# Variation by sections
y <- dts[datefield < 2019 & !is.na(section)]
y <- dcast(y, dsection~datefield, value.var = 'DMH', fun.aggregate = mean, na.rm = TRUE)
y[, var := 100 * (`2018` / `2017` - 1)]
tbl <- BasicTable$new()
tbl$addData(y, 
        firstColumnAsRowHeaders = TRUE, 
        explicitColumnHeaders = c('Section', '2017', '2018', 'Variation'),
        columnFormats = rep(list("%.2f"), ncol(y))
)
cells <- tbl$findCells(columnNumbers = 4, maxValue = 0, includeNull = FALSE, includeNA = FALSE)
tbl$setStyling(cells = cells, declarations = list("background-color" = "#38EB6B", "color" = "#9C0006"))
cells <- tbl$findCells(columnNumbers = 4, minValue = 2, maxValue = 8, includeNull = FALSE, includeNA = FALSE)
tbl$setStyling(cells = cells, declarations = list("background-color" = "#FFC60A", "color" = "#9C0006"))
cells <- tbl$findCells(columnNumbers = 4, minValue = 8, includeNull = FALSE, includeNA = FALSE)
tbl$setStyling(cells = cells, declarations = list("background-color" = "#FF050D", "color" = "#9C0006"))
tbl$renderTable()

# Variation by sic (subsection)
get_tbl_sic <- function(x){
  y <- dts[datefield < 2019 & section == x][, subsection := as.integer(gsub(',.*', '', sic))]
  y <- sic[section == x][y, on = c(sic_code = 'subsection')][, sic_code := NULL][!is.na(description)]
  setnames(y, 'description', 'sit_desc')
  y <- dcast(y, sit_desc~datefield, value.var = 'DMH', fun.aggregate = mean, na.rm = TRUE)
  y[, var := 100 * (`2018` / `2017` - 1)]
  tbl <- BasicTable$new()
  tbl$addData(y, 
          firstColumnAsRowHeaders = TRUE, 
          explicitColumnHeaders = c(paste('SIC of Section:', sections[section == x, description]), '2017', '2018', 'Variation'),
          columnFormats = rep(list("%.2f"), ncol(y))
  )
  cells <- tbl$findCells(columnNumbers = 4, maxValue = 0, includeNull = FALSE, includeNA = FALSE)
  tbl$setStyling(cells = cells, declarations = list("background-color" = "#38EB6B", "color" = "#9C0006"))
  cells <- tbl$findCells(columnNumbers = 4, minValue = 2, maxValue = 8, includeNull = FALSE, includeNA = FALSE)
  tbl$setStyling(cells = cells, declarations = list("background-color" = "#FFC60A", "color" = "#9C0006"))
  cells <- tbl$findCells(columnNumbers = 4, minValue = 8, includeNull = FALSE, includeNA = FALSE)
  tbl$setStyling(cells = cells, declarations = list("background-color" = "#FF050D", "color" = "#9C0006"))
  tbl$renderTable()
}
get_tbl_sic('A')

# Variation by Regions / LAD in Region
get_tbl_rgn <- function(x){
  y <- dts[datefield < 2019 & RGN == x]
  y <- dcast(y, LAD~datefield, value.var = 'DMH', fun.aggregate = mean, na.rm = TRUE)
  y[, var := 100 * (`2018` / `2017` - 1)]
  y <- lcn[type == 'LAD', .(location_id, name)][y, on = c(location_id = 'LAD')][, location_id := NULL][order(name)]
  tbl <- BasicTable$new()
  tbl$addData(y, 
          firstColumnAsRowHeaders = TRUE, 
          explicitColumnHeaders = c(paste('Local Authorities for:', lcn[location_id == x, name]), '2017', '2018', 'Variation'),
          columnFormats = rep(list("%.2f"), ncol(y))
  )
  cells <- tbl$findCells(columnNumbers = 4, maxValue = 0, includeNull = FALSE, includeNA = FALSE)
  tbl$setStyling(cells = cells, declarations = list("background-color" = "#38EB6B", "color" = "#9C0006"))
  cells <- tbl$findCells(columnNumbers = 4, minValue = 2, maxValue = 8, includeNull = FALSE, includeNA = FALSE)
  tbl$setStyling(cells = cells, declarations = list("background-color" = "#FFC60A", "color" = "#9C0006"))
  cells <- tbl$findCells(columnNumbers = 4, minValue = 8, includeNull = FALSE, includeNA = FALSE)
  tbl$setStyling(cells = cells, declarations = list("background-color" = "#FF050D", "color" = "#9C0006"))
  tbl$renderTable()
}
get_tbl_rgn('E12000008')  # lcn[type=='RGN']


## DataTables ---------------------------------------------------------------------------------------------------------

y <- dts[datefield == 2018, .(LAD, BPM, BPF)]
y <- lcn[type == 'LAD', .(location_id, name)][y, on = c(location_id = 'LAD')][, location_id := NULL][order(name)]
y <- y[, .(.N, BPM = mean(BPM), BPF = mean(BPF)), name]

# y <- dts[datefield == 2018, .(LAD, size, BPM, BPF)]
# y <- lcn[type == 'LAD', .(location_id, name)][y, on = c(location_id = 'LAD')][, location_id := NULL][order(name, size)]
# y <- y[, .(.N, BPM = mean(BPM), BPF = mean(BPF)), .(name, size)]

dt <- datatable( 
        y, 
        rownames = FALSE ,
        colnames = c('Local Authority', 'Counting', 'Bonus Men', 'Bonus Women'),
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

dt <- dt %>% formatCurrency('N', '', digits = 0) %>% formatCurrency(c('BPM', 'BPF'), '', digits = 2)

n_cls <- 9
v_cls <- classIntervals(c(y$BPM, y$BPF), n_cls)[[2]][2:n_cls]
dt <- dt %>% 
        formatStyle(c('BPM', 'BPF'), 
            `font-weight` = '600',
            backgroundColor = styleInterval(v_cls , brewer.pal(9, 'OrRd')),
            color = styleInterval( v_cls, c(rep('black', 6), rep('white', 3))) 
        )

saveWidget(dt, 
   file.path(getwd(), 'gender_paygap', 'outputs', 'bonus_by_lads.html'), 
   selfcontained = TRUE,
   libdir = 'dependencies',
   background = 'deepskyblue',
   title = 'Bonus by Local Autorithies'
)

## Quartiles by Sector --------------------------------------------------------------------------------

cols <- names(dts)[grepl('Q', names(dts))]
y <- dts[datefield == 2018, c('dsection', cols), with = FALSE]
# y <- lcn[type == 'LAD', .(location_id, name)][y, on = c(location_id = 'LAD')][, location_id := NULL][order(name)]
y <- y[, lapply(.SD, mean), dsection, .SDcols = cols][order(dsection)]


dt <- datatable( 
        y, 
        rownames = FALSE ,
        colnames = c('Section' = 'dsection'),
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
            columnDefs = list(
                list(className = 'dt-center', targets = 1:(ncol(y))),
                list(
                    targets = 0,
                    render = JS(
                      "function(data, type, row, meta) {",
                      "return type === 'display' && data.length > 50 ?",
                      "'<span title=\"' + data + '\">' + data.substr(0, 50) + '...</span>' : data;",
                      "}"
                    )
                )            
            ),
            deferRender = TRUE,
            initComplete = JS(
                "function(settings, json) {",
                    "$(this.api().table().header()).css({
                        'text-align':'center',
                        'background-color':'#000000', 
                        'color':'#F2FF00',
                        'font-size':'120%'
                    });",
                "}"
            ),
            dom = 'Biftp'
        ) 
    ) 

dt <- dt %>% formatCurrency(2:ncol(y), '', digits = 2) 

brks <- quantile(y[, 2:ncol(y)], probs = seq(.05, .95, .05), na.rm = TRUE)
clrs <- round(seq(255, 40, length.out = length(brks) + 1), 0) %>%
  {paste0("rgb(255,", ., ",", ., ")")}
dt <- dt %>% formatStyle(2:ncol(y), backgroundColor = styleInterval(brks, rev(clrs)))
dt
