# to learn to code you have to practice
# coding means making mistakes, hoping less and less with time 
# do not rush to ask for help, try first to reread the code you wrote, then read for the warning, after all that if you still have no clue ask for help

# install R: https://cran.r-project.org/
# install RStudio: https://www.rstudio.com/products/rstudio/download/#download
# RStudio overview and main options: 
# clone the github workshop repo in an RStudio project

# using the console to show R as a simple calculator

# open a new R text file in the source path

# see how to run code from the source pan ==> REPL: Read–Eval–Print-Loop

# save the file, commit, push to github, goto the website to confirm the changes

# creates a "vector" (set of elements of the same nature) using the 'c' function (combine, concatenate)
x <- c(12, 13, 34, 4, 6, 87)
x
print(x)
length(x)
x[3]
x[1:2]

# predefined constant vectors
LETTERS[1:5]
letters[1:5]
rbind(LETTERS[1:5], letters[1:5])
month.abb[10:12]
month.name[10:12]

# vectorization: applying the same operator/function to all elements of a structure at the same time (R doesn't often need loops for repetitions)
x + 2
3 * x
x * 4
y <- c(2, 3, 4, 7, 18, 44)
x + y

# recycling: if applying an operator to two vectors of different dimension, the shorter vector gets its elements repeated as needed
z <- y[1:length(x) -1]
z
x + z

# explain what packages are: additional functionalities
# install and load a few packages: run the file 'install_pkgs.R'
source('install_pkgs.R')

# explain what a function is, and its arguments, by positions and by name, complete or short form, optional and its default value
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
mean(c(v, NA))
mean(c(v, NA), na.rm = TRUE)
mean(c(v, NA), TRUE)
mean(c(v, NA), 0.1, TRUE)

# explain main: operators, data types, data structures, pipe operator
NA

# create dataframe
df <- data.frame(1:10, letters[1:10])

# load (?) dataset from core R: iris, mtcars
head(iris)
head(iris, 12)
tail(mtcars)
tail(head(mtcars, 12), 1) # query only the 12th row
mtcars %>% head(12) %>% tail(1) # same with pipes

# load dataset from packages: 
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
hdi <- read.csv('introduction_to_r/HDI.csv')

# load text data from internet [see https://gender-pay-gap.service.gov.uk/] !!! ==> watch at the differences between core R and readr
paygap <- read.csv('https://gender-pay-gap.service.gov.uk/Viewing/download-data?year=2017')
paygap <- read_csv('https://gender-pay-gap.service.gov.uk/Viewing/download-data?year=2017')

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
barplot(table(diamonds$cut))
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
