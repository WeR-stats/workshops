# to learn to code you have to practice
# coding means making mistakes, hoping less and less with time 
# do not rush to ask for help, try first to reread the code you wrote, then read for the warning, after all that if you still have no clue ask for help

# install git: 
# install R: https://cran.r-project.org/
# install RStudio: https://www.rstudio.com/products/rstudio/download/#download
# RStudio overview and main options: 
# clone the github workshop repo in an RStudio project (see the docs from past meet up http://bit.ly/2TUyjsL)

# using the console to show R as a simple calculator

# open a new R text file in the source path

# see how to run code from the source pan ==> REPL: Read–Eval–Print-Loop

# save the file, commit, push to github, goto the website to confirm the changes

# explain variable

# creates a "vector" (set of elements of the same nature) using the 'c' function (<c>ombine, <c>oncatenate)
x <- c(12, 13, 34, 4, 6, 87)
x
print(x)
length(x) # number of elements in x
x[3]      # third element
x[1:2]    # first and second elements !!! ==> R starts counting from 1, insted of 0 as most programming languages 
x[c(2, 3, length(x))]    # second, third and last elements

# vectorization: applying the same operator/function to all elements of a structure at the same time (R doesn't often need loops for repetitions)
x + 2
3 * x
x * 4
y <- c(2, 3, 4, 7, 18, 44)
x + y

# recycling: if applying an operator to two vectors of different dimension, the shorter vector gets its elements repeated as needed
z <- y[1:length(x) -1] # 
z
x + z

# predefined constant vectors
LETTERS # uppercase 26 letters of the English alphabet
letters # lowercase 26 letters of the English alphabet
all.equal(tolower(LETTERS), letters) # check that lowercase <LETTERS> is equal to <letters>
all.equal(LETTERS, toupper(letters)) # check that uppercase <letters> is equal to <LETTERS>
rbind(LETTERS, letters)    # create a character matrix 2 rows and 26 columns
class(rbind(letters, LETTERS))
str(rbind(letters, LETTERS))
month.name # months in letters
month.abb  # months abbreviated
all.equal(substr(month.name, 1, 3), month.abb) # check that 
cbind(month.name, month.abb)    # create a character matrix 12 and by 2 columns
cbind(letters, LETTERS)
class(cbind(month.name, month.abb))
str(cbind(month.name, month.abb))

# explain what a function is; its arguments, listed by positions and/or by name, in complete or short form; optional arguments, and default value

# show how RStudio help in writing down a function call
sqrt(x = 81)
sqrt(81)
mean(c(1, 5, 9, 15))
mean(1:10)
?mean
set.seed(1)
v <- sample(1:1000, 100)
mean(v)
mean(v, 0.10) 
vo <- sort(v)
mean(vo[11:90]) # trimmed mean leaves out 10% of lowest and highest obs, in this case 10 obs as total is 100 
mean(c(v, NA)) # this works but the result won't satisfy...
mean(c(v, NA), na.rm = TRUE) # this works OK 
mean(c(v, NA), TRUE) # this does NOT work, you know why?
mean(c(v, NA), 0.1, TRUE) # this again works, do you understand the difference with the above command?

# how to find a value in a vector under specified conditions
x <- c(1:20, 121:32)
max(x)          # return the value
which.max(x)    # return the position
x[which.max(x)] # return the value
x <- c(1:20, NA, 121:32)
max(x)               # return NA
max(x, na.rm = TRUE) # return the value
x[which.max(x)]      # return the value
x[which(is.na(x))] <- -1 # search for the value and substitute
x[which.min(x)]

# explain main: operators, data types, special values, data structures, pipe operator
NA

# create dataframe
df1 <- data.frame(letters, LETTERS)
all.equal(df1, cbind(letters, LETTERS))
class(df1)
str(df1)  # result is much simpler than the above about a matrix
df2 <- data.frame(cbind(letters, LETTERS))
all.equal(df1, df2)
df <- data.frame(1:26, df1)
names(df)
names(df)[1] <- 'numbers'
names(df)
df <- data.frame(numbers = 1:26, df1)
nrow(df)   # number of rows
ncol(df)   # number of columns
dim(df)    # both the above
length(df) # in the case of a dataframe, this equals the number of columns
str(df)

# some (famous) dataset are already incuded in core R: [see the list: ]
head(iris)
head(iris, 12)
tail(mtcars)
tail(head(mtcars, 12), 1) # query only the 12th row
mtcars %>% head(12) %>% tail(1) # same with pipes

# it's time to talk about what packages are: additional functionalities

# install and load a few packages: run the file 'install_pkgs.R'
source('install_pkgs.R')

# read documentation about a package
library(help = 'data.table')

# load datasets from packages: 
# - diamond from ggplot2
data(diamonds, package = c('ggplot2'))
# - gapminder from gapminder
data(gapminder, package = c('gapminder'))
# - flights from nycflights13
data(flights, package = c('nycflights13'))
# - storms from dplyr
data(storms, package = c('dplyr'))

# load text data: read.table, read.csv, read.csv2, read.delim, dead.delim2, readr:read_csv, data.table:fread
hdi <- read.table('introduction_to_r/HDI.csv', header = TRUE, sep = ',')
hdi <- read.csv('introduction_to_r/HDI.csv') # equal as above, read.csv is just a shortcut! 

# load CSV data from internet [see https://gender-pay-gap.service.gov.uk/] !!! ==> watch at the differences between core R and readr
paygap <- read.csv('https://gender-pay-gap.service.gov.uk/Viewing/download-data?year=2017')
ames <- read_csv('https://www.openintro.org/stat/data/ames.csv')

# load TSV data from internet [see 1st version of file for docs http://lib.stat.cmu.edu/datasets/boston] 
boston <- read.delim('http://lib.stat.cmu.edu/datasets/boston_corrected.txt', skip = 8)

# load multiple files and combine in one dataset [see files 138-142 (Dec-18) at https://cycling.data.tfl.gov.uk/]
x <- data.frame(
        id = 138:142,
        url = c('28Nov2018-04Dec2018', '05Dec2018-11Dec2018', '12Dec2018-18Dec2018', '19Dec2018-25Dec2018', '26Dec2018-01Jan2019')
)
cycle_data <- do.call(
    'rbind', 
    lapply(1:nrow(x), function(n) read.csv( paste0('https://cycling.data.tfl.gov.uk/usage-stats/', x[n, 1], 'JourneyDataExtract', x[n, 2], '.csv') ) )
)
names(cycle_data) <- gsub('[*.]', '_', tolower(names(cycle_data)))
cycle_data$start_date <- as.POSIXct(strptime(cycle_data$start_date, '%d/%m/%Y %H:%M'))
cycle_data$end_date <- as.POSIXct(strptime(cycle_data$end_date, '%d/%m/%Y %H:%M'))
cycle_data$startstation_name <- NULL
cycle_data$endstation_name <- NULL
table(months(cycle_data$start_date))
cycle_data <- cycle_data[months(cycle_data$start_date) == 'December',]

# ... plus load station data for coordinates
cycle_stations <- jsonlite::fromJSON(txt = 'https://api.tfl.gov.uk/bikepoint')
cycle_stations <- data.frame(cbind(
    station_id = sub('BikePoints_', '', cycle_stations$id), 
    terminal_id = sapply(1:nrow(cycle_stations), function(n) cycle_stations$additionalProperties[[n]][, 5][1]),
    x_lon = cycle_stations$lon,
    y_lat = cycle_stations$lat,
    address = cycle_stations$commonName
), stringsAsFactors = FALSE)
cycle_stations$station_id <- as.integer(cycle_stations$station_id)
cycle_stations$x_lon <- as.numeric(cycle_stations$x_lon)
cycle_stations$y_lat <- as.numeric(cycle_stations$y_lat)
cycle_stations <- separate(cycle_stations, 'address', c('place', 'area'), ',')
cycle_stations$place <- trimws(cycle_stations$place)
cycle_stations$area <- trimws(cycle_stations$area)

# merge total month count to list of stations
y <- as.data.frame(table(cycle_data$startstation_id, dnn = 'station_id'), stringsAsFactors = FALSE)
cycle_stations <- merge(cycle_stations, y, by = 'station_id')

inner_join(cycle_stations, y, by = 'station_id') -> cycle_stations
y$station_id <- as.numeric(y$station_id)

# check dataframe
ncol(diamonds)
nrow(diamonds)
dim(diamonds)
length(diamonds) # for a dataframe is equal to number of columns
length(diamonds$carat)
dim(diamonds$carat)  # non sense for a vector, only length
names(diamonds)
str(mtcars)
str(diamonds)
summary(mtcars)
summary(diamonds)
fivenum(diamonds$carat) # works only on vectors

# select column(s)
diamonds[, 'carat'] # !!! see difference with diamonds$carat
diamonds[, c('carat', 'price')] # !!! see difference with c(diamonds$carat, diamonds$price)
subset(diamonds, select = 'price')
subset(diamonds, select = c('carat', 'price'))
cbind(diamonds$carat, diamonds$price) # show how you get the same content but lose structure

diamonds %>% select(carat)
diamonds %>% select(carat, price)


# filter row(s) ===> explain sequence: semicolon, seq(from, to), seq(from, to, by), seq(from, to, length)
diamonds[5,]   # note that without comma shift to selecting columns
diamonds[c(5, 12, 350, 4567),] # note that without comma throws error, some column indices do not exist
diamonds[5:12,]
diamonds[seq(5, 12),]
diamonds[seq(1, 1000, 50),]
diamonds[951,] # this is the last row of above slice

diamonds[diamonds$cut == 'Good',] # !!! see difference with diamonds[diamonds$cut == 'good',]
diamonds[diamonds$price >= 12000,] 
diamonds[diamonds$carat >= 1 & diamonds$cut == 'Ideal',] 
diamonds[diamonds$carat >= 1 & diamonds$cut == 'Ideal',] 
levels(diamonds$cut)
unique(diamonds$cut)
unique(as.character(diamonds$cut))
table(diamonds$cut)
table(diamonds$cut, diamonds$color)
diamonds[diamonds$cut %in% c('Premium', 'Ideal'),] 
diamonds[diamonds$cut >= 'Premium',] # it works because it is an ORDERED factor
diamonds[diamonds$cut < 'Ideal',] 
diamonds[diamonds$cut != 'Ideal',] # same as above
diamonds[diamonds$cut >= 'Premium' | diamonds$price > 1000,] 
subset(diamonds, subset = (diamonds$cut == 'Good'))

diamonds %>% slice(5)
idx <- c(5, 12, 350, 4567)
all.equal(diamonds[idx,], diamonds %>% slice(idx))
diamonds %>% filter(cut == 'Good')
all.equal(diamonds[diamonds$cut == 'Good',], diamonds %>% filter(cut == 'Good'))
diamonds %>% filter(carat >= 1, cut == 'Ideal')
all.equal(diamonds[diamonds$carat >= 1 & diamonds$cut == 'Ideal',], diamonds %>% filter(carat >= 1, cut == 'Ideal'))

# add / overwrite / drop column
diamonds$test <- 1
diamonds$test <- NA
diamonds$test <- NULL
diamonds$Ratio <- diamonds$price / diamonds$carat
diamonds$Ratio <- round(diamonds$Ratio) 
names(diamonds)

diamonds %>% mutate(Ratio = round(price / carat, 2)) -> diamonds

# order by column(s)
diamonds[order(diamonds$price),]
diamonds[order(c(diamonds$cut, diamonds$price)),]
diamonds[order(-diamonds$price),]
diamonds[order(rev(diamonds$cut), -diamonds$price),] # you can't use minus sign with ordered factors

diamonds %>% arrange(desc(cut), -price)

# classification
dcuts <- data.table(
    cuts = c(0, 1000, 5000, 10000, 15000), 
    labels = c('Very Low', 'Low', 'Medium', 'High', 'Very High')
)
diamonds$price_group <- cut(diamonds$price, c(dcuts$cuts, Inf), labels = dcuts$labels, ordered = TRUE, right = FALSE)

# add row
rbind


# grouping rows by column(s)
aggregate(diamonds$price, list(diamonds$cut), mean) # !!! ==> show how aggregate(diamonds, d$Name, mean) throws error
aggregate(diamonds[, c('price', 'depth'),], list(diamonds$cut), mean) 
aggregate(diamonds[, c('price', 'depth'),], list(diamonds$cut, diamonds$color), mean) 
aggregate(price~cut+color, diamonds, mean) 
aggregate(cbind(price, depth)~cut+color, diamonds, mean)

diamonds %>% group_by(cut) %>% summarize(avg_price = mean(price), avg_depth = mean(depth), total_size = sum(carat))
diamonds %>% group_by(cut, color) %>% summarize(avg_price = mean(price), avg_depth = mean(depth), total_size = sum(carat))


# plot one categorical variable
y <- table(diamonds$cut)
barplot(y)
y <- diamonds %>% group_by(cut) %>% summarize(N = n())
barplot(y$N)

barplot(table(diamonds$cut, diamonds$price_group))

ggplot(diamonds)  # what does it do? need to explain aestetics and add
ggplot(diamonds, aes(x = cut))  # it look like it added something but ... ? needs to explain geometries and add
ggplot(diamonds, aes(x = cut)) + geom_bar()

g <- ggplot(diamonds, aes(x = cut)) # save layer 
g + geom_bar()

diamonds %>% 
    group_by(cut) %>% 
    summarize(avg_price = mean(price)) %>% 
    ggplot(aes(x = cut, y = avg_price)) +
        geom_col()

# plot one numeric variable
hist(diamonds$price)
boxplot(diamonds$price)
boxplot(Ratio~cut, data = diamonds, main = "Diamonds Data",  xlab = "Carat", ylab = "AVG Price")


ggplot(diamonds, aes(x = price)) + geom_histogram()
ggplot(diamonds, aes(x = price)) + geom_histogram(binwidth = 10) # how many buckets should you create? can't say, you have to try
ggplot(diamonds, aes(x = price)) + geom_histogram(bins = 10) 
ggplot(diamonds, aes(x = price)) + geom_histogram(bins = 100) 
ggplot(diamonds, aes(x = price)) + geom_density()
ggplot(diamonds, aes(x = price)) + geom_density(aes(color = cut))
ggplot(diamonds, aes(x = price)) + geom_histogram(bins = 10, aes(fill = cut))
ggplot(diamonds, aes(x = price)) + geom_histogram() +
    facet_wrap(~ cut)

ggplot(diamonds, aes(x = cut, y = price)) + geom_boxplot()
ggplot(diamonds, aes(x = cut, y = price)) + geom_violin()  # not only the standard five numbers but a look at the entire distribution
ggplot(diamonds, aes(x = cut, y = price)) + geom_violin() + geom_jitter(alpha = 0.01) # price is not actually correlated with cut, possibly carat instead ?
ggplot(diamonds, aes(x = cut, y = price)) + geom_violin() + geom_jitter(aes(size = carat), alpha = 0.01)
ggplot(diamonds, aes(x = cut, y = price)) + 
    geom_jitter(aes(color = carat), alpha = 0.25, size = 1, shape = 1, width = 0.35) + # you want jitter first not to cover the violins
    geom_violin(alpha = 0.5, color = 'grey50', draw_quantiles = c(0.25, 0.50, 0.75)) +
    scale_color_gradient('Diamond Size', low = 'turquoise', high = 'red') +
    scale_y_continuous(labels = scales::comma) +
    labs(x = 'Cut', y = 'Price', title = 'Price vs Cut and Carat') +
    ggthemes::theme_few()


# plot two categorical variables

ggplot(diamonds, aes(x = cut, y = price_group)) + 
    geom_tile(aes(fill = carat)) +
    scale_fill_gradientn(colours = brewer.pal(7, 'BuGn'))


# plot two numeric variables
plot(diamonds$carat, diamonds$price)
plot(diamonds$carat, diamonds$price, col = diamonds$cut, main = 'A', xlab = 'X', ylab = 'Y')
legend(x = 'bottomright', legend = levels(diamonds$cut), col = c('black', 'blue', 'red', 'yellow', 'green'), pch = 1)

ggplot(diamonds, aes(x = carat, y = price)) + geom_point()

ggplot(diamonds, aes(x = carat, y = price, color = cut)) + geom_point()

ggplot(diamonds, aes(x = carat, y = price, color = cut)) + # notice that the plus sign MUST end the line, can't be at the beginning of a new line
    geom_point(shape = 1) # to see the available shape: 

ggplot(diamonds, aes(x = carat, y = price, color = cut)) +
    geom_point(size = 0.5) # notice that in this way size is NOT an aestetics, so it is the same for ALL points

ggplot(diamonds, aes(x = carat, y = price, color = cut)) +
    geom_point(aes(size = Ratio), alpha = 0.1)

ggplot(diamonds, aes(x = carat, y = price, color = cut)) + 
    geom_point(size = 1, shape = 1) +
    facet_wrap( ~ cut)

ggplot(diamonds, aes(x = carat, y = price, color = cut)) + 
    geom_point(size = 1, shape = 1) +
    facet_grid(price_group ~ cut)

p <- ggplot(diamonds, aes(x = carat, y = price, color = cut)) + geom_point() 
p + theme_light()     # included in ggplot2
p + theme_economist() # comes with ggthemes
p + theme_economist() + scale_color_economist()
p + theme_tufte()
p + theme_excel() + scale_color_excel() # AAAAARGH!!!!!! WHY ?!?!?


# palettes: introduce RColorBrewer [see http://http://colorbrewer2.org/]
RColorBrewer::display.brewer.all()
ggplot(diamonds, aes(x = carat, y = price, color = cut)) +
    geom_point() +
    facet_grid(price_group ~ cut) +
    scale_color_brewer(palette = 'BrBG')


# load excel data from internet: readxl [see https://archive.ics.uci.edu/ml/datasets/online+retail]
tmp.xls <- tempfile(fileext = ".xls")
download.file(
    'https://archive.ics.uci.edu/ml/machine-learning-databases/00352/Online%20Retail.xlsx',
    destfile = tmp.xls,
    mode = 'wb'
)
retail <- readxl::read_xlsx(tmp.xls)
unlink(tmp.xls)

# load json file from internet: jsonlite [see https://petition.parliament.uk/petitions/ for a petition id]
pet_id <- 223013
petitions_ori <- jsonlite::fromJSON(paste0('https://petition.parliament.uk/petitions/', pet_id, '.json'))
petitions_ori$data$attributes$action
petitions_ori$data$attributes$state
petitions <- petitions_ori$data$attributes$signatures_by_constituency
petitions <- petitions[order(petitions$ons_code),]

# load electors and merge with petitions [see hhttps://www.ons.gov.uk/peoplepopulationandcommunity/elections/electoralregistration/datasets/electoralstatisticsforuk]
tmp.xls <- tempfile(fileext = ".xls")
download.file(
    'https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/elections/electoralregistration/datasets/electoralstatisticsforuk/2017unformatted/elec5dt2unformattedelectoralstatisticsuk2017.xls',
    destfile = tmp.xls,
    mode = 'wb'
)
excel_sheets(tmp.xls)
electors <- read_xls(tmp.xls, sheet = 5)
unlink(tmp.xls)
electors <- electors[, c(1, 5)]
names(electors) <- c('ons_code', 'electors')
petitions <- merge(petitions, electors, by = 'ons_code')
# rm(electors)
petitions$permille <- round(petitions$signature_count / petitions$electors * 1000, 3)

# differences between dataframe, tibble, data.table

# differences in data wrangling between core R, dplyr (= explain pipe operator), data.table, SQL


# rewrite above merge with dplyr
petitions %>% inner_join(electors, by = 'ons_code')

# rewrite above merge with data.table (notice: you can also use the same )
DT.petitions <- setDT(petitions)
DT.electors <- setDT(electors)
DT.petitions[DT.electors, on = 'ons_code', nomatch = 0]    # !!! ==> notice how this is different from DT.petitions[DT.electors, on = 'ons_code']

# rewrite above merge with sqldf
sqldf('SELECT pt.*, el.electors FROM petitions_ori pt JOIN electors el ON pt.ons_code = el.ons_code')

# how to tidy very messy data [see http://hdr.undp.org/en/data] ==> explain why you use data.table to load data
hdi <- fread('introduction_to_r/Human Development Index (HDI).csv', skip = 1, select = c('Country', 1990:2017))
hdi[, Country := trimws(Country)]
hdi <- melt(hdi, variable.name = 'year', na.rm = TRUE)
setorderv(hdi, c('year', 'value'), c(1, -1))
hdi[, rank := 1:.N, year]
dcuts <- data.table(
    cuts = c(0, 0.45, 0.55, 0.70, 0.80), 
    labels = c(
        'Very Low Human Development', 'Low Human Development', 
        'Medium Human Development', 
        'High Human Development', 'Very High Human Development'
    )
)
hdi[, group := cut(value, c(dcuts$cuts, 1), labels = dcuts$labels, ordered = TRUE, right = FALSE)]
fwrite(hdi, 'introduction_to_r//HDI_v2.csv')

# rewrite above tidying code with dplyr




## dygraphs [see docs @ http://rstudio.github.io/dygraphs/] -----------------------------------------------------------------------
yr <- retail %>% 
        mutate(invoice_day = as.Date(InvoiceDate), revenues = Quantity * UnitPrice) %>% 
        group_by(invoice_day) %>% 
        summarise(freq = n(), revenues = sum(revenues)/10) %>% 
        as.data.frame()
ggplot(yr, aes(x = invoice_day, y = freq)) + 
    geom_line() + 
    scale_y_continuous(label = comma) + 
    labs(title = 'Number of Orders', x = 'Day', y = 'Number of Orders') +
    theme_calc()

ggplot(yr, aes(x = invoice_day)) + 
    geom_line(aes(y = freq, colour = 'Number of Orders')) + 
    geom_line(aes(y = revenues, colour = 'Total Revenues')) + 
    scale_y_continuous(label = comma, sec.axis = sec_axis(~.*6, name = 'Total Revenues')) + 
    scale_colour_manual(values = c('green', 'brown')) + 
    labs(title = 'Number of Orders and Total Revenues', x = 'Day', y = 'Number of Orders', color = 'Quantity') +
    theme_calc() +
    theme(legend.position = c(0.16, 0.89))

yr <- xts(yr[, -1], order.by = yr[, 1])
dygraph(yr[, 1]) 
dygraph(yr, main = 'Number of Orders and Total Revenues') %>% 
    dyLegend(width = 500, show = 'always', hideOnMouseOut = FALSE) %>% 
    dyAxis('y', label = 'Number of Orders', drawGrid = TRUE) %>%
    dyHighlight( highlightCircleSize = 4, highlightSeriesBackgroundAlpha = 0.4, hideOnMouseOut = TRUE, highlightSeriesOpts = list(strokeWidth = 2) ) %>% 
    dyRangeSelector( dateWindow = c(max(as.Date(retail$InvoiceDate)) - 61, max(as.Date(retail$InvoiceDate))), height = 30, strokeColor = 'black' ) %>%
    dyRoller(rollPeriod = 7) %>%
    dyAxis('y2', label = 'Total Revenues', drawGrid = TRUE) %>%
    dySeries('revenues', axis = 'y2') %>%
    dyOptions( axisLineWidth = 1.25, stackedGraph = FALSE, fillGraph = FALSE, colors = c('green', 'brown') )


## leaflet [see docs @ http://rstudio.github.io/leaflet/] -----------------------------------------------------------------------
leaflet() %>% addCircles(data = cycle_stations, lng = ~x_lon, lat = ~y_lat)
leaflet() %>% addTiles() %>% addCircles(data = cycle_stations, lng = ~x_lon, lat = ~y_lat)
mp <- leaflet() %>% addCircles(data = cycle_stations, lng = ~x_lon, lat = ~y_lat)
mp %>% addProviderTiles(providers$OpenStreetMap.Mapnik) 

mp <- mp %>%  # [see https://leaflet-extras.github.io/leaflet-providers/preview/]
    addProviderTiles(providers$OpenStreetMap.Mapnik, group = 'OSM Mapnik') %>%
    addProviderTiles(providers$OpenStreetMap.BlackAndWhite, group = 'OSM B&W') %>%
    addProviderTiles(providers$Stamen.Toner, group = 'Stamen Toner') %>%
    addProviderTiles(providers$Stamen.TonerLite, group = 'Stamen Toner Lite') %>% 
    addProviderTiles(providers$Hydda.Full, group = 'Hydda Full') %>%
    addProviderTiles(providers$Hydda.Base, group = 'Hydda Base')
mp # ?
mp <- mp %>% 
	addLayersControl(
		baseGroups = c('OSM Mapnik', 'OSM B&W', 'Stamen Toner', 'Stamen Toner Lite', 'Hydda Full', 'Hydda Base'),
		options = layersControlOptions(collapsed = TRUE)
	)

get_count_days <- function(ids, keep_id = FALSE, where = 'start'){
    y <- cycle_data[cycle_data[, paste0(where, 'station_id')] %in% ids, c(paste0(where, 'station_id'), paste0(where, '_date'))]
    y[, paste0(where, '_date')] <- factor(weekdays(y[, paste0(where, '_date')]), levels = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), ordered = TRUE)
    if(keep_id){
        as.data.frame(table(y, dnn = c('station_id', 'day'))) 
    } else {
        y$startstation_id <- NULL
        as.data.frame(table(y, dnn = 'day')) 
    }
}
ggplot(get_count_days(1), aes(x = day, y = Freq)) + geom_col()
ggplot(get_count_days(104:110), aes(x = reorder(day, Freq), y = Freq)) + geom_col() + coord_flip()
ggplot(get_count_days(104:110, TRUE), aes(x = reorder(day, Freq), y = Freq, color = station_id)) + geom_col(position = 'dodge') + coord_flip()
ggplot(get_count_days(104:110, TRUE), aes(x = reorder(day, Freq), y = Freq, fill = station_id)) + geom_col(position = 'dodge') + coord_flip()
ggplot(get_count_days(104:110, TRUE), aes(x = reorder(day, Freq), y = Freq, fill = station_id)) + geom_col(color = 'black', position = 'dodge') + coord_flip()
build_popup <- function(id){
    get_count_days(id) %>% 
        kable %>%
        kable_styling(
            bootstrap_options = c('striped', 'hover', 'condensed', 'responsive'), 
            font_size = 10, 
            full_width = FALSE
        )   
}

mp <- leaflet() %>%  
        addProviderTiles(providers$OpenStreetMap.Mapnik, group = 'OSM Mapnik') %>%
        addProviderTiles(providers$OpenStreetMap.BlackAndWhite, group = 'OSM B&W') %>%
        addProviderTiles(providers$Stamen.Toner, group = 'Stamen Toner') %>%
        addProviderTiles(providers$Stamen.TonerLite, group = 'Stamen Toner Lite') %>% 
        addProviderTiles(providers$Hydda.Full, group = 'Hydda Full') %>%
        addProviderTiles(providers$Hydda.Base, group = 'Hydda Base') %>% 
        addCircleMarkers(
            data = cycle_stations, 
            lng = ~x_lon, lat = ~y_lat,
            group = 'Stations',
            color = ~ifelse(area %in% c('Aldgate', 'Angel'), 'red', 'blue'),
            radius = ~rescale(Freq, to = c(1, 20)),
            stroke = FALSE,
            fillOpacity = 0.5,
    		label = lapply(
            		    1:nrow(cycle_stations),
            		    function(x)
                            HTML(paste0(
                                '<hr>',
                                '<b>Place</b>: ', cycle_stations$place[x], '<br>', 
                                '<b>Area</b>: ', cycle_stations$area[x], '<br>', 
                                '<b>N. Rides</b>: ', format(cycle_stations$Freq[x], big.mark = ','), '<br>', 
                                '<hr>'
                            ))
    		),
        	labelOptions = labelOptions(
        		textsize = '12px',
        		direction = 'right',
        		sticky = FALSE,
        		offset = c(80, -50),
        		style = list('font-weight' = 'normal', 'padding' = '2px 6px')
        	),
    		popup = lapply(
                        1:nrow(cycle_stations),
                        function(x)
                            HTML(paste0(
                                '<strong><font size="+1">
                                    Number of rides by <em>Day of the week</em>
                                </font></strong><br>',
                                build_popup(cycle_stations$station_id[x])
                            ))
                    ),
    		popupOptions = popupOptions(minWidth = 440)
        ) %>% 
    	addLayersControl(
    		baseGroups = c('OSM Mapnik', 'OSM B&W', 'Stamen Toner', 'Stamen Toner Lite', 'Hydda Full', 'Hydda Base'),
    		overlayGroups = c('Stations'),
    		options = layersControlOptions(collapsed = TRUE)
    	) %>% 
    	addControl(
    		tags$div(HTML(paste0(
    		    '<p style="font-size:14px;padding:10px 5px 10px 10px;margin:0px;background-color:#F7E816;">', 
    		    'London Santander Cycle Scheme. Usage Dec-18', 
    		    '</p>' 
            ))), 
    		position = 'bottomleft'
    	)
    
mp

saveWidget(mp, 
    'leaflet-test.html', 
    selfcontained = TRUE, 
    background = 'deepskyblue',
	title = 'London Santander Cycle Scheme. Usage Dec-18'
)

