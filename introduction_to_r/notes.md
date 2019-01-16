
# Introduction To *R*

**Author**: [Luca Valnegri](https://www.linkedin.com/in/lucavalnegri/)   
**Last Updated**:  16-Jan-2019

---
  * [Preliminaries](#preliminaries)
    - [Motivations](#motivations)
    - [Data Science Workflow](#workflow)
    - [Reproducible Research](#rep-research)
    - [Installation](#projects)
    - [GitHub and RStudio Projects](#projects)
  * [R Basics](#basics)
    - [Help](#help)
    - [Operators](#operators)
      + [Arithmetic](#op-arithmetics)
      + [Logical](#op-logicals)
      + [Conditional](#op-conditionals)
    - [Built-In Constants And Functions](#constants-functions)
      + [Mathematics](#built-maths)
      + [Statistics](#built-stats)
      + [Matrices](#built-matrices)
    - [Variables](#variables)
    - [Environment, Workspace](#environment)
    - [Packages](#packages)
    - [Coding Style](#coding-style)
  * [Data Types [atomics]](#data-types)
    - [logical (boolean)](#data-types-logical)
    - [character (string)](#data-types-character)
    - [numeric](#data-types-numeric)
    - [complex](#data-types-complex)
    - [raw](#data-types-raw)
  * [Data Structures](#data-structures)
    - [Vector](#vector)
      + [Sequences](#vec-sequences)
      + [Repetitions](#vec-repetitions)
    - [Matrix](#matrix)
    - [Array](#arrray)
    - [Dataframe](#dataframe)
    - [List](#list)
    - [Factor](#factor)
  * [Data I/O](#data-io)
    - [Keyboard](#data-io-keyboard)
    - [Text Files](#data-io-text)
    - [Spreadsheets](#)
    - [Other Statistical Packages](#)
    - [Databases](#)
    - [Web Scraping](#)
    - [Other Formats](#)
    - [Built-In Datasets](#)
  * [Data Manipulation](#data-manipulation)
    - [Strings](#strings)
    - [Date and time](#data-time)
    - [Regular Expressions](#regex)
  * [Data Wrangling](#data-wrangling)
    - [Select columns](#select-cols)
    - [Filter Rows](#filter-rows)
    - [Add/Drop Column](#add-drop-col)
    - [Recode / Transform Variable](#recode)
    - [Merge datasets](#merge)
  * [Data Summary](#data-summary)
    - [Univariate](#data-summary-uni)
    - [Multivariate](#data-summary-multi)
  * [Data Visualization](#data-viz)
    - [Univariate](#data-viz-uni)
      + [Bar plot](#barplot)
      + [Pie chart](#piechart)
      + [Dot plot](#dotplot)
      + [Pyramid](#pyramid)
      + [Histogram](#histogram)
      + [Area Chart](#areachart)
      + [Density plot](#densityplot)
      + [Boxplot](#boxplot)
      + [Violin Plot](#violinplot)
    - [Bivariate](#data-viz-bi)
      + [Scatterplot](#scatterplot)
      + [Bubble Chart](#bubblechart)
      + [Highlight](#highlight)
      + [Mosaic Plot](#mosaicplot)
    - [Multivariate](#data-viz-multi)
      + [Scatterplot Matrix](#scatterplot-matrix)
      + [Ridges](#ridges)
      + [Radar Chart](#radarchart)
      + [Correlogram](#correlogram)
      + [Sankey Diagram](#sankey)
      + [Parallel Coordinates](#parallelcoords)
      + [Parallel Sets](#parallelsets)
      + [Chord Diagram](#chord-diagram)
      + [Tree Diagram](#tree-diagram)
      + [Network Diagram](#network-diagram)
      + [Treemap](#tree-map)
      + [Circle Packing](#circle-packing)
      + [Wordcloud](#)
      + [Treemap](#)
    - [Time](#data-viz-spatial)
      + [Line chart](#line-chart)
      + [Streamgraph](#streamgraph)
    - [Spatial](#data-viz-spatial)
      + [Proportional Symbol](#)
      + [Choropleth](#)
      + [Hexbin](#)
      + [Cartogram](#)
      + [Voronoi](#)
      + [Connections](#)
      + [Flows](#)
  * [Data Modeling And Learning](#)
    - [Probability And Simulation](#)
    - [Statistical Inference](#)
      + [Estimation](#)
      + [Hypothesis Testing](#)
    - [Classification](#)
      + [kNN](#)
      + [Decision Trees](#)
      + [Random Forest](#)
      + [](#)
    - [Regression](#)
      + [](#)
      + [](#)
    - [Features Engineering](#)
      + [Attributes Selection](#)
      + [Domain Reduction](#)
    - [Clustering](#)
    - [Forecasting](#)
    - [Survival Analysis](#)
    - [Meta Analysis](#)
    - [???](#)
      + [Training](#)
      + [Evaluation, Cross Validation](#)
      + [Hyperparameter Tuning](#)
      + [Regularization](#)
      + [](#)
  * [Programming](#)
    - [Conditionals](#)
      + [If...else](#) 
      + [switch](#) 
    - [Repetitions](#)
      + [while](#) 
      + [for](#) 
      + [\*apply Family](#) 
    - [Functions](#)
    - [Scripts](#)
      + [Debugging](#)
      + [Error Handling And Recovery](#)
      + [Logging](#)
    - [Building Packages](#)

---

  <a name="motivations"/>

## Motivations 

### Data Science Workflow


### Reproducible Research


### GitHub and RStudio Projects

While you could avoid to know any git command to use version control from the RStudio git GUI, it's advisable
   - `git commit`
   - `git checkout`
   - `git push`
   - `git pull`


  <a name=""/>

## R Basics

When writing $R$ code , notice that:
  - *R* is case-sensitive
  - spaces are not essential. This means that additional spacing can be added without interfering with the coding, to make the code more readable. But this has to be consistent along all scripts.
  - *comments* can be added everywhere using the hash sign `#`, and everything after that, on the same line, is dismissed by the interpreter. Notice that comments in $R$ are only one-liner, there's no way of adding multi-liner, but starting each line with the hash sign. 
    Adding comments to the code is extremely important to make sure that your future self and others can understand what your code is about.
    In RStudio you can use the shortcut `CTRL+SHIFT+C` to toggle  commenting from the highlighted lines in the source window.
  - when referring to paths, backslashes `\` are not admitted. In Windows, it's possible, but not advised, to use a double backslash instead.



  <a name=""/>

### Help

  - ?fun or help(fun) to look for a particular function. Notice that every specific help page in R is laid out in the same way 
  - `help.start()`
  - `?funname` or `help(funname)` to look for a particular function. Notice that every specific help page in R is laid out in the same way
  - `??topic`
  - `help.search('topic')`
  - `apropos('topic')`
   - `vignette(topic = 'topic', package = 'pkgname')` to look for documentation on a particular package
  - `demo('pkgname')`
  - `example('topic')`
  - online resources:
    - List of CRAN Packages [by date](https://cran.r-project.org/web/packages/available_packages_by_date.html) or [by name](https://cran.r-project.org/web/packages/available_packages_by_name.html)
    - [CRAN Task Views](https://cran.r-project.org/web/views/)
    - Stack Overflow](https://stackoverflow.com/questions/tagged/r)  and [Cross Validated](https://stats.stackexchange.com/questions/tagged/r)
    - [RStudio Community](https://community.rstudio.com/)
  

  <a name="operators"/>

### Operators
$R$ can be used at its basics as a normal calculator. It can perform the following operations:

  <a name=""/>

#### Arithmetic
  - addition: `x + y`
  - subtraction: `x - y`
  - multiplication: `x * y`
  - division: `x / y`
  - exponentiation: `x^y`, or `x**y`, raises the number to its left to the power of the number to its right
  - module: `x %% y`, returns the remainder of the division of the number to the left by the number on its right
  - integer division: `x %/% y`

  <a name=""/>

#### Comparison
  - `x == y`
  - `x != y` 
  - `x < y`
  - `x <= y` 
  - `x > y` 
  - `x >= y`

  <a name=""/>

#### Logical
  - NOT `!x`, 
  - OR `x | y` or `x || y`, when we want the result to be a single value (scalar) even if applied to vectors
  - AND `x & y`, or `x && y`, when we want the result to be a scalar

  <a name=""/>

#### Rounding
  - `round(x, digits = 0)` rounds the argument to the specified number of decimal places (default is 0).
  - `floor(x)` returns the largest integer(s) not greater than the corresponding elements of x
  - `ceiling(x)` returns the smallest integer(s) not less than the corresponding elements of x
  - `trunc(x)` returns the integer(s) formed by truncating the values in x toward 0. Notice the relation: 
    `trunc(x) = floor(x > 0) + ceiling(x < 0)`)
  - `signif(x, digits = 6)` rounds the argument to the specified number of significant digits (default is 6).

#### $R$ Specific
  - `:` to create *sequences*
  - `[` and `[[` to *index* data structures
  - `$` and `@` to *select* elements or *slots* in data structures
  - `x %in% y` to look for elements 
  - `%any%`
  - `~` to specify relations in a model, with `.` an additional argument that represents all the remaining *features*
  - `::`  
  - `:::`  


  <a name=""/>

### Built-In Constants And Functions

 - The order of the arguments matters, unless arguments are inserted with their name.
 - Some arguments are mandatory, while others are optional and use their default value when not included in the function call
 - the *formula* argument `~` is a shortcut to represent a model in a concise way 

  <a name=""/>

#### Mathematics
  - absolute value: `abs(x)`
  - sign: `sgn(x)`
  - square root: `sqrt(x)`

  <a name=""/>

#### Statistics

  - `sum()`
  - `diff()`
  - `median()`
  - `mode()`
  - `min()`
  - `max()`
  - `range()`
  - `mean()`
  - `quantile()`
  - `summary()`
  - `fivenum()`
  - `var()`

In most of the previous functions, `na.rm` is an optional that allows to drop *missing* values before applying the required function to the specified set of numbers.

  <a name=""/>

#### Matrices


  <a name=""/>

### Constants
A *character constant* is any string delimited by single quotes (apostrophes) `'`, double quotes (quotation mark) `"` or backticks (backquotes or grave accent) ` ` `. They can be used interchangeably, but double quotes are preferred (and character constants are printed using double quotes), so single quotes are normally only used to delimit character constants containing double quotes.

*Escape sequences* inside character constants are started using the backslash character `\` as escape character (an *escape* character is a character which invokes an alternative interpretation on subsequent characters in a character sequence). The only admissible escape sequences in $R$ are the following: 
    - `\n` newline
    - `\r` carriage return
    - `\t` tab
    - `\b` backspace
    - `\\` backslash
    - `\'` single quote
    - `\"` double quote
    - ` \` backtick
    - `\a` alert (bell)
    - `\f` form feed
    - `\v` vertical tab
    - `\nnn` character with given octal code (1, 2 or 3 digits)
    - `\xnn` character with given hex code (1 or 2 hex digits)
    - `\unnnn` Unicode character with given code (1--4 hex digits)
    - `\Unnnnnnnn` Unicode character with given code (1--8 hex digits)


  <a name=""/>

### Variables

A basic concept in all programming languages is the *variable*. It allows the coder to store a value, or more generally an object, so that can be accessed later using its name. The great advantages of doing calculations with variables is reusability and abstraction.

In *R* it is possible to use any of the following statements to assign the object (value) *obj* to the variable named *x*: 
  - `x <- obj` 
  - `obj -> x` 
  - `assign(x, obj)` 
In *RStudio*, you can insert the assignment symbol `->` using the shortcut `ALT+-`

Notice the following:
  - Even if the more common *equal* sign `=` is recognized, it is highly discouraged, and should only be used to pass values to arguments in a function call, or set default values to parameter during the function definition. Moreover, `=` has lower precedence than `<-`, so they should not be mixed together in the same command.
  - If the variable *x* already exists, its old value is overwitten with the new value *obj* without any warning. 
  - $R$ is case sensitive! So *x* and *X* are considered two different variables.

Identifiers for variables consist of a sequence of letters, digits, the period `.` and the underscore `_`. They must not start with a digit nor underscore, nor with a period followed by a digit. The following *reserved* words are not valid identifiers:
 - `TRUE`
 - `FALSE`
 - `NaN`
 - `NULL`
 - `Inf`
 - `if`
 - `else`
 - `repeat`
 - `while`
 - `for`
 - `in`
 - `next`
 - `break`
 - `function`
 - `NA`
 - `NA_integer_`
 - `NA_real_`
 - `NA_complex_`
 - `NA_character_`
 - `...`, `..1`, `..2`, ... 

To print out the value of a variable, it suffices to write its name, if working from the console, or using the command `print` if from a script. Notice that R does not print the value of a variable to the console when assigning it. To assign a value and simultaneously print it the assignment should be surrounded by parenthesis, as in `(x <- obj)`. 
 
 

  <a name=""/>

### Environment, Workspace
The *workspace* is the current *R* working environment available to users to store objects, and includes any user-defined objects.

  - `getwd()` return the *working directory*, which is the place where *R* looks by default (when not told otherwise) to retrieve or save any data
  - `setwd('pathname')` change the working directory to **pathname**. Note that *R* sees `\` as an *escape* character, so in Windows the path needs to be inserted using a double backslash `\\`, or a forward slash `/` commonly found on UNIX systems.
  - `ls()` list all objects included in the current environment
  - `load('myfile.RData')` load a workspace into the current session
  - `save(object_list, file = 'myfile.RData')` save specific objects to a file
  - `save.image()` save the workspace to the file .RData in the cwd 
  - `rm(x)` remove the specified object *x* from the environment
  - `rm(list = ls())` remove all objects from the environment
  - `gc()` performs a *garbage collection*
  - `options()` view current option settings
    - `options(digits = 3)` set number of digits to print on output
    - `options( = )` # set 
  - `history()` display last (25) co`mmands
  - `history(max.show = Inf)` display `all previous commands
  - `savehistory(file = 'myfile')` default i` - `s ".Rhistory" in working dir
  - `loadhistory(file = 'myfile')` default i `- `s ".Rhistory" from working dir
  - `source('filename')`
  - `tempfile()`
  - `q()`

#### R System
  - `.libPaths()`
  - `R.Version()`
  - `getRversion()`


#### File system
  - `file.exists`
  - `file.create`
  - `file.path`



  <a name=""/>

### Packages






 - install.packages('pkgname')
 - require(pkgname)
 - library(pkgname)
 - detach.packages(pkgname)
 - remove.packages(pkgname)
 - update.packages()
 - vignette(topic = '', package = 'pkgname')
 
To find the packages that comes with *R*:
```{r}
dts <- as.data.frame(installed.packages(), stringsAsFactors = FALSE)
dts[dts$Priority %in% c('base', 'recommended'), 'Package']
```


  <a name=""/>

## Data Types [atomics]


Variables can be of different nature or *type*, according to the nature of the object they store. To know more about their data type, here are some functions that can help:
  - `class(x)`
  - `typeof(x)`
  - `mode(x)`
 
To test if an object assume a specific type we can use the generic function:
`is.type(x)`
 
It is often necessary to change the way that variables store their object(s), something called *coercing* or *casting*:
`as.type(x)`
Only certain coercions are allowed though, and some of them, even if possible, lead to loss of information. All integer, numeric, and logical are coercible to character

Specific types of value: 
 - `NA` with testing function`is.na()`. It should be noted that the *basic* `NA` is of type *logical*. There are also other specific missing values placeholders for some data types: `NA_character_`, `NA_integer_`, `NA_real_`, `NA_complex_`.
 - `NULL` with testing function `is.null()`
 - `Inf` with testing function `is.infinite()`
 - `NaN` with testing function `is.nan()`


  - **logical** or *boolean*. Under the hood, the logical values TRUE and FALSE are coded respectively as 1 and 0. Therefore:
    - `as.logical(0)` returns FALSE, and `as.numeric(FALSE)` returns 0
    - `as.numeric(TRUE)` returns 1, but `as.logical(x)` returns TRUE for every `x` different from 0.

  - **character** Any type of text surrounded by single or double quotation marks.

  - **numeric** When *R* encounter a number, it automatically assume that it's a numeric, whatever the value. To force *R* to store an integer value as integer type, you have to use `L` after the number.


    - **integer**
 
    - **double**
 
  - **date** and **time** 
    There are two main object to represent date and time in R:
   - *date* for calendar date, with the standard format being the ISO `yyyy-mm-dd`, but *R* recognizes automatically also `yyyy/mm/dd`
   - POSIXct/POSIXlt for date, time and timezone. The standard format in this case is `yyyy-mm-dd hh:mm:ss`
 
   Under the hood, both the above classes are simple numerical values, as the number of days, for the date class, or the number of seconds, for the POSIX objects, since the 1st January 1970. The 1st of January in 1970 is the common origin for representing times and dates in a wide range of programming languages. There is no particular reason for this; it is a simple convention. Of course, it's also possible to create dates and times before 1970; the corresponding numerical values are simply negative in this case.

`unclass(x)` returns the number of days, if x is Date, or seconds, if x is POSIXct, since '1970-01-01'
`date(d)`
`format(x, format = '')`
`weekdays(d)` returns the day(s) of the week for every element in *x*
`months(d)` the month(s)
`quarters(x)` the quarter(s) (in the form Qx)


  - **Po**

Other data types that you possiblky never encounter are:
  - **complex**
  - **raw**




<!-- new section -->

  <a name=""/>

## Data Structures

  - `str(x)` displays information about the internal structure of the object `x`
  - `head(x, n = 6)` list the first `n` elements of the object `x`
  - `tail(x, n = 6)` list the last `n` elements of the object `x`

 

  <a name=""/>

### Vector
A set of values of the same type. The usual way to create a vector by hand is to *combine*, *concatenate*, or *collect* its elements using the function `c`:
~~~
v <- c(...)
~~~ 
For the purposes of these notes, any item in a generic vector will be called *element*.

When building the vector, its elements could be of different nature, but $R$ will *cast* if possible to the minimal data type overall, following the simple hierachy: 
> character > numeric > integer > logical

Some functions related to vectors are the following:
  - `print(v)`
  - `names(v) <- new_names`
  - `length(v)` returns the number of elements in *v* (note that `dim(v)` returns `NULL` )
  - `which(v.condition)` returns the positions  of the elements that satisy the specified condition when applied to the specified vector
  - `which.min(v)` returns the position(s)  of the minimum value(s) in a numeric vector 
  - `which.max(v)` returns the position(s)  of the minimum value(s) in a numeric vecor
  - `diff(v)` returns a vector of `length(x) - 1` containing the differences between consecutive elements of `x`
  - `diffinv(v)` 
  - `difftime(v)`

#### Vectorization


#### Recycling





 - %in% to test if one or more values belong(s) to a vector


  <a name=""/>

#### Sequences

 - `n1:n2` creates the vector `c(n1, n1 + 1, ..., n2 - 1, n2)`
 - `seq(n1, )``
 - `seq(n1, )`


  <a name=""/>

#### Repetitions

 - rep(x, )



  <a name=""/>

### Matrix
A vector with an additional *dimension* attribute with two elements: number of rows and number of columns. Any matrix is built upon a vector, indicating how many rows or/and columns will be the final result, and if the matrix should be filled horizontally (along the rows) or vertically (along the columns). There is no recycling here, the length of the specified vector must be equal to the total number of values of the desired matrix (product of number of rows and number of columns).

~~~
my_vector <- 1:10
dim(my_vector) <- c(2, 5)
my_matrix <- matrix(my_vector, nrow = 2)
identical(my_vector, my_matrix)
~~~

  <a name=""/>

### Array


  <a name=""/>

### Dataframe
A horizontal or vertical binding of possibly named vectors all of the same length.

For the purpose of these notes, any item in a dataframe will be called *value*.

- create a dataframe starting from some vectors $v_1, v_2, ..., v_n$:
  df <- dataframe(v1, v2, ..., vn)
- it's possible to give different names to some or all the vectors: 
  df <- dataframe('n1' = v1, 'n2' = v2, ..., vn)

colnames(df) or names(df)
rownames(df)
cpos <- which(names(df) == cname)

- select a column:
  df[, 'cname']
  df$cname
  df[['cname']]
  df[, cpos]
  
- select multiple columns


- drop a column:


da

- merge two dataframe:
  df <- merge(df1, df2, by.x = '', by.y = '', )



  <a name=""/>

### List

For the purpose of these notes, any item in a vector will be called *component*.


  <a name=""/>

### Factor
R provides a convenient and efficient way to store values for *categorical* variables, that takes on a limited number of values, herein called *levels*.
To create a *factor* in *R*, use the `factor(x)` function, where *x* is the vector to be converted into a factor. This simple way to define a factor let *R* order the levels in alphabetical order, implicitly using `sort(unique(x))`. A different order can be specified passing a convenient vector through the *levels* argument. 
If not specified otherwise, the above *order* is actually not meaningful, and *R* throws an error if trying to apply relational operators. But if the order itself has a true meaning, in the sense that the underlying variable is at least *ordinal*, it's possible to specify the *ordered* arguments as `TRUE`. In this case it's also good practice to specify the correct levels. To force an order on an existing unordered factor, it is possible to use the *ordered* function as in `ordered(f, levels = c(...))`.

The general form of the function is:
~~~
factor(x = character(), levels, labels = levels, exclude = NA, ordered = is.ordered(x), nmax = NA)
~~~

Once a factor is defined, the unique values of the original variable are mapped to integers, and ...
 - `levels(f)` lists all unique values taken on by f (NAs are ignored though)
 - `levels(f) <- v` rename the levels of *f* to a different set of values. Note that has to be `length(v) = length(levels(f))`, and that the elements in *v* are associated to the levels by the correspondent positions.   
 - `as.numeric(f)` lists all numeric values associated with the values taken on by x 
 - `summary(f)` now returns a frequency distribution of the underlying variable
 - `plot(f)` now returns a histogram of the underlying variable
 
The factor type could be used not only to store and manage categorical variables, but also numerical discrete variables, directly, and even continuous, once they have been *discretized*, a result that can be easily achieved using the *cut* function:
 - `f <- cut(x, breaks = n)` *x* is grouped into *n* evenly spaced buckets
 - `f <- cut(x, breaks = c(x<sub>1</sub>, x<sub>2</sub>, ..., x<sub>x</sub>))` *x* is grouped into *n-1* bins using the *n* specified  limit values.
The above process could be also be used to group the values of a discrete variable that assumes too many values, to more easily analyze them.

Often, during the analysis, we encounter factors that have some levels with very low counts. To simplify the analysis, it often helps to drop such levels. In R, this requires two steps: 
 - first filtering out any rows with the levels that have very low counts,
 - then removing these levels from the factor variable with `droplevels`. 
This is because the *droplevels()* function would keep levels that have just 1 or 2 counts; it only drops levels that don't exist in a dataset.
A similar behaviour happens when subsetting a factor, *R* removes the instances but leaves the level behind! In this case, though, we can directly add `drop = TRUE` to the subsetting operation to have the empty level(s) deleted as well as their values.

*R*'s default behavior when creating data frames is to convert all characters into factors, often causing headache to the user trying to figure out why its character columns are not working properly... To turn off this behavior simply add the argument 
`stringsAsFactors = FALSE` to the *data.frame* call. By the way, *data.table* does NOT convert characters to factors automatically.

To assign labels to levels, according to the actual values in data: `fct <- factor(fct, levels = labels)`
To change the labels of levels, according to the order they are already stored: `levels(fct) <- labels`
To acc
`fct <- factor(fct, levels = names(sort(table(fct), decreasing = TRUE)))`


Used to efficiently store categorical variable. 

```
v <- factor(x)
levels(v)
sumamry(v)
as.integer(v)
levels(v) <- new_levels
v <- factor(x, levels = new_levels, ordered = TRUE)
```


<!-- new section -->

## Data I/O

  <a name=""/>

### Keyboard


  <a name=""/>

### Text files


#### CSV files


#### TSV files


#### FWF files


  <a name=""/>

### Spreadsheet


  <a name=""/>

### Other Statistical Packages


  <a name=""/>

### Databases


  <a name=""/>

### Web Scraping


  <a name=""/>

### Other formats


  <a name=""/>

### Built-In datasets
Once $R$ is started, there are lots of example data sets available within $R$ itself, and along with most loaded packages. You can list the data sets by their names and then load a data set into memory to be used in your statistical analysis. 

  - `data()` returns a list of all the datasets contained in all the packages currently loaded into the local system
  - `data(dtsname)` load the dataset called *dtsname*
  - `data(package = .packages(all.available = TRUE))` list all the data sets in all the available packages stored on CRAN

Some noticeable datasets are: 
  - **iris** and **mtcars** from base *R*
  - **diamonds** from the `ggplot2` package
  - **gapminder** from the `gapminder` package
  - **nasa** and **storms** from the `dplyr` package
  - **flights** from the `nycflights13` package


  <a name=""/>

## Data Manipulation



  <a name=""/>

### Strings

  - `nchar(x)`
  - `paste(x)`
  - `paste0(x)` is equal to `paste(x, sep = '')`
  - `substr(x)`
  - `substring(x)`
  - `strsplit(x)`
  - `tolower(x)`
  - `toupper(x)`
  - `trimws(x)`
 
  <a name=""/>

### Date and Time



  <a name=""/>

### *Regexp* Regular Expressions




  <a name=""/>

## Data Wrangling

  <a name=""/>

### Select Variables in a dataset (Filter columns)


  <a name=""/>

### Subset (Filter rows) a dataset


  <a name=""/>

### Index a dataset (Filter values)


  <a name=""/>

### Add / Recode / Transform variables


  <a name=""/>

### Merge two (or more) datasets



  <a name=""/>

## Data Summary

  <a name=""/>

### Univariate

 - table(x)


  <a name=""/>

### Bivariate

 - table(x, y)



  <a name=""/>

## Data Display



  <a name=""/>

## Data Visualization

  <a name=""/>

### Setting parameters

 - main = 
 - 
 

  <a name=""/>

### Univariate

  <a name=""/>

#### Bar plot

 - barplot()


  <a name=""/>

#### Pie chart


  <a name=""/>

#### Dot plot


  <a name=""/>

#### Histogram


  <a name=""/>

#### Density plot



  <a name=""/>

### Bivariate


  <a name=""/>

#### Highlight


  <a name=""/>

#### Scatterplot


  <a name=""/>

#### Scatterplot matrices


  <a name=""/>

#### Correlogram


## Data Modeling And Learning

### Simulation


### Statistical Inference


#### Estimation


#### Hypothesis Testing


### Classification


### Regression


### Features Engineering


#### Attributes Selection


#### Domain Reduction


### Clustering


### Forecasting


  <a name=""/>

## Programming

  <a name=""/>

### Conditionals


  <a name=""/>

#### If ... else

  - we are interested in running some code only if a situation does appear:
    ~~~
    if(condition){
        code to run when condition is true
    }
    ~~~
    or, in a more concise but often less readible form:
    ~~~
    if(condition) code to run when condition is true
    ~~~   
  - we want to run two different code snippets, according to the fact tthat a situation does show up or not:
    ~~~
    if(condition){
        code to run when condition is true
    } else {
        code to run when condition is false
    } 
    ~~~
    When the code to actually run in both cases is simple, the above construct could be replace by the following shorter version:
    ~~~
    ifelse(condition, code to run if condition is true, code to run if condition is false)
    ~~~
  - we are faced with more than two :
    ~~~
    if(condition1){
        code to run when condition1 is true
    } else if(condition2){
        code to run when condition2 is true
    } else if(...){
        ...
    } else {

    }
    ~~~
    Notice that the `else` part could actually be missing, if we want to do nothing if none of the specified conditions actually happens.

  <a name=""/>

#### Switch
When we're facing with a situation with multiple possibilities, it's often better use the `switch` statement, which provides a more readible way to list all the underline conditions and connected 
~~~
switch(

)
~~~


  <a name=""/>

### Repetitions

  <a name=""/>

#### Repeat
It's a basic infinite repetition of the inner code, with the only way to exit due to the `break` statement:
  - the code in this loop run at least once:
    ~~~
    repeat {
        code
        if(condition) break
    }
    ~~~
  - the code in this loop could possibly never run:
    ~~~
    repeat {
        if(condition) break
        code
    }
    ~~~

  <a name=""/>

#### While Loop

~~~
while(condition){
    code
    # put something here that can change condition
}
~~~

Notice that the code in the above loop could possibly never run, according to the condition being `TRUE` or `FALSE` at the start.

Moreover, if the inner code snippet that should change the test condition fails to set it FALSE at least once, the loop never stops.

  <a name=""/>

#### For Loop
When you know how many times you want to repeat an action, a `for` loop is the best option. The idea of the for loop is that you are stepping through a set or a sequence, one element at a time, and performing an action at each step along the way. 

  - by element:
    ~~~
    for(item in list){
        code involving item
    }
    ~~~
  - by index:
    ~~~
    for(index in sequence){
        code recalling index
    }
    ~~~

You can use *nested* loops to step through multidimensional objects, like matrices and dataframes:
~~~
for(i in seq1){ 
    for(j in seq2){ 
        code 
    } 
}
~~~

You can exit from a single step or the entire loop altogether using 
 - `next` to skip omly the current iteration, and proceed with the subsequent element in the sequence/set
 - `break` to exit the loop straightaway


  <a name=""/>

#### `*apply` Family

`lapply()` is possibly the most known, and used, *vectorized* version of the classic `for` loop, and is often preferred (and simpler) in the *R* world because of its readiility and efficiency. As a matter of fact, it's just the most used caseof an entire family of functions that helps build repetitions of functions.

  - `apply(x, MARGIN, FUN, ...)`


  - `lapply(X, FUN, ..., USE.NAMES = TRUE)`
*lapply*,  short for *__l__ist __apply__*, is usually the first and arguably the most commonly used function of *R*'s wide *apply* family. In general, `lapply(x, funname, ...)` takes a vector or list *x*, and applies *funname* to each of its members. If FUN requires additional arguments, you pass them after you've specified *x* and FUN. 

The output of *lapply* is always a list, the same length as *x*, where each element is the result of applying *funname* on the corresponding element of *x*. 

The function can be one of R's built-in functions, but it can also be a function written by the user. This self-written function can be defined beforehand, or can be inserted directly as an *anonymous* function as follow: 
```lapply(v, function(x) { code block })```

Because dataframes are essentially lists under the hood, with the columns of the dataframe being the elements of the underlying list, calling an *lapply* with a dataframe as argument would apply the specified function to each column of the data frame. 


  - `sapply(X, FUN, ..., simplify = TRUE, USE.NAMES = TRUE)`
Many of the operations performed by `lapply` on the specified vector or list, will each generate a list containing elements with the same type and length. These lists can just as well be represented by a vector, or a matrix. That's exactly what `sapply`, standing for *__s__implified l__apply__*. It performs first `lapply`, and then sees whether the result can be correctly represented as an array, because the lengths of the elements in the output is always the same. If the simplification is not possible, then the output is identical to the output the parent *lapply* would have generated, without any warning. Henceforth, *sapply* is not a robust tool, because the output structure tends to be dependent on the inputs, and there's no way to enforce a different behaviour. The usual suggestion is that it's a great tool for interactive use, but not such a safe tool to be included in functions or, worse, in production. 

Another neat feature of `sapply` is that if it could gather sufficient information from the input, being it a named vector or list, it then tries to meaningfully name the elements of the output structure. To avoid such behaviour, add the argument `USE.NAMES = FALSE`. 

  - `vapply(X, FUN, FUN.VALUE, ..., USE.NAMES = TRUE)`
With *vapply* the user can define the exact structure of the output, so to avoid any unpredicted behaviour which you can typical incurred when using *sapply*. There is an additional argument *FUN.VALUE* that expects a template for the return argument of the function *FUN*, such as *datatype(n)*, where *datatype* could be: integer, numeric, character or logical, while *n* is the length of result. When the structure of the output of the function does not correspond to the above template, *vapply* will throw an error that informs about the misalignment between expected and actual output. *vapply* can then be considered a more robust and safer version of *sapply*, and converting all *sapply* calls to a *vapply* version is therefore a good practice. There's really no reason to use *sapply*. if the output that *lapply* would generate can be simplified to an array, you'll want to use *vapply*, specifying the structure of the expected output, to do this securely. If simplification is not possible, simply stick to *lapply*.

  - `tapply`


  - `mapply`


  - `rapply`


  - `eapply`





  <a name=""/>

### Functions

~~~
fname <- function(argname_req, argname_opt = def_value){
    code to run 
    return(object)
}
~~~

A function then returns the object explicited in the *return* function, if it exists; alternatively, the result from the last line executed. There could be many return calls in function's body.

There are three main parts to a function:
 - *arguments* `formals(fun.name)`: the user inputs that the function works on. They can be the data that the function manipulates, or options that affect the calculation. 
   Functions can have multiple arguments, separated by a comma with a single space only afterwards. 
   Some or all the arguments could be *optional*, if a *default value* is set for them using an equal sign surrounded by spaces. 
   Arguments can be explicited by position or by name. By style convention, the first argument, if required, is not named. However, beyond the first couple of arguments you should always use matching by name. It makes the code much easier for everyone to read. This is particularly important if the argument is optional, because it has a default. When overriding a default value, it's good practice to use the name.
   - Every time a function is called, it's given a new fresh and clean environment, first populated with the arguments.
   - Once the function has ended its job, all its environment is destroyed.
   - If a variable present in the code, but not herein defined, is not passed in as an argument, R looks for it outside of the function environment, starting one level up and . If it's not found in the global environment, *R* throws an error
   - Any variable defined inside a function, does not exist outside of its scope.
   - A variable defined inside a function can have the same name of a variable defined outside a function, but they are completely different objects disposing of a different scoping, with and the former taking precedence over the latter only inside the function.
   
 - *body* `body(fun.name)`: the code that actually performs the manipulation.
 
 - *scope* `environment(fun.name)`.
   Scoping is the process of how R looks for a variable's value when given a name. It is usually partitioned as global vs local.  
   Every variable defined inside a function is bound to live only inside that function. If you try to access it outside of the scope of that function, you will get an error because it does not exist!
   If a variable is not found inside the function, but it exists in the global environment, it is passed into it *by value*, meaning that the function can play with it but can't change the original value even if that's what happens inside the function.  

 
 
 - arguments required vs optional. 
   Optional arguments are ones that don't have to be set by the user, either because they are given a default value, or because the function can infer them from the other data. Even though they don't have to be set, they often provide extra flexibility.
 - arguments vs parameters
 - In *R* functions are objects just like any other object. In particular, they can be argument to other functions!
 - documentation: help(fun.name), ?fun.name
 - *nested* functions.
   It's often useful to use the result of one function directly in another one, without having to create an intermediate variable.
 - *anonymous* function

 - Function names should be chosen as descriptive of the action taken, and because of that should always be expressed as *verbs*.
 - Argument names should be expressed as *names* and must avoid to be called as core *R* objects.
   Aside from giving your arguments good names, you should put some thought into what order your arguments are in and if they should have defaults or not. Arguments are often one of two types:
   - **data** arguments, that supply the data to compute on
   - **detail** arguments, that control the details of how the computation is done.
  Generally, data arguments should come first, while detail arguments should go on the end, and usually should have default values.

 - If in need to display messages about the code, it is bad practice to use `cat` or `print`, functions designed just to display output. The official *R* way to supply simple diagnostic information is the `message` function. The unnamed arguments are pasted together with no separator (and no need for a newline at the end) and by default are printed to the screen.

 - Notice that there are three kinds of functions in R: 
    - most of the functions are called *closures*
    - language constructs are known as *special* functions
    - a few important functions are known as *builtin* functions, they use a special evaluation mechanism to make them go faster.

#### Colloquials

 - `stopifnot(condition)`
 - `stop('message', .cond = TRUE)`
   Using `stop()` inside a `if` statement that checks the *condition*, instead of the simpler but often obscure `stopifnot()`, allows to specify a more informative error message. Writing good error messages is an important part of writing a good function. We recommend your error tells the user what *should be true*, not what is false

#### Side Effects
Side effects describe what happens when running a function that alters the state of your R session. If foo() is a function with no side effects (a.k.a. pure), then when we run x <- foo(), the only change we expect is that the variable x now has a new value. No other variables in the global environment should be changed or created, no output should be printed, no plots displayed, no files saved, no options changed. We know exactly the changes to the state of the session just by reading the call to the function.
Of course functions with side effects are crucial for data analysis. You need to be aware of them, and deliberate in their usage. It's ok to use them if the side effect is desired, but don't surprise users with unexpected side 

#### Robustness
A desired class of functions is the set of so-called *pure* functions, characterized by the following *good* traits:
  - TBD


##### - Unstable types

A function is called *type unconsistent* when the type or class of its output depends on the type of input. This unpredictable behaviour is a sign that you shouldn't rely on type unconsistent functions inside your own functions, but use only alternative functions that are type consistent!

Typical examples of such functions are the following:
 - `[`, that when applied to a dataframe can return a vector or a dataframe depending on the dimension of the input. A simple way to overcome this problem is adding a `drop = FALSE` argument to the call.
 - `sapply` . The easiest way to avoid the situation is using instead `vapply`, or better any `map` functions from the *purrr* package.
 
Most of the time, switching to stable functions means that we have to accept failings, and possibly write down some informative error message to return, or write additional conditionals to decide which action to undertake in case of above failings.
 
 
##### - Non-Standard Evaluation (NSE)

To avoid the problems caused by non-standard evaluation functions, you could avoid using them. In our example, we could achieve the same results by using standard subsetting (for example, using the standard bracket subsetting `[` instead of `dplyr::filter()`).But if you do need to use non-standard evaluation functions, it's up to you to provide protection against the problem cases. That means you need to know what the problem cases are, to check for them, and to fail explicitly.


#####   - Hidden Arguments

A classic example of a hidden dependence is the `stringsAsFactors` argument to the `read.csv()` function (and a few other data frame functions). That's because if the argument is not specified, it inherits its value from `getOption("stringsAsFactors")`, a global option that a user may change. In general, you want to avoid having the return value of your own functions depend on any global options. That way, you and others can reason about your functions without needing to know the current state of the options.

It is, however, okay to have side effects of a function depend on global options. For example, the `print` function uses `getOption("digits")` as the default for the `digits` argument. This gives users some control over how results are displayed, but doesn't change the underlying computation.


  <a name=""/>

### Objects

Object-oriented programming (OOP) is very powerful, but not appropriate for every data analysis workflow. OOP is usually suitable for workflows where you can describe exhaustively a limited number of objects. 

One of the principles of OOP is that functions can behave differently for different kinds of object inputs. The summary() function is a good example of this. Since different types of variable need to be summarized in different ways, the output that is displayed to you varies depending upon what you pass into it.

R has many OOP frameworks, some of which are better than others. Knowing how to use S3 is a fundamental R skill. R6 and ReferenceClasses are powerful OOP frameworks, with the former being much simpler. S4 is useful for working with Bioconductor. Don't bother with the others.

#### S3



#### R6



#### ReferenceClasses




  <a name=""/>

### Scripts 



  <a name=""/>

#### Debugging

 - `tryCatch`



  <a name=""/>

#### Error Handling And Recovery


  <a name=""/>

#### Logging



  <a name=""/>

### Building Packages


<!--stackedit_data:
eyJoaXN0b3J5IjpbODMwMDIzNjcyLC0xNzYyNDIzNTcsMTE1ND
U4MTc3NywtMzk4NDAyNDc3LC0xMTYyMTQwODY3LDIwNjAwMzIz
OCwxMDE3MTA0Nzc4LDkxMTE1ODk4MiwxNTU2MTcxMjQzLDE1OT
c4OTMyNDcsLTIxNDI1MTA2NTcsLTE2ODc0ODU4NDUsNTk0NTU4
MzA4LC0xMzEwMTg1MTYyLC0xNDIyNTE3MjM3LDQwMDc0MDE4OC
wxNDM1NjkyMSw5MTE1Nzg1MTgsNzMwOTk4MTE2XX0=
-->