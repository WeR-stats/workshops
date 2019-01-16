## Problem Formulation


## Data Preparation

### Data Planning


### Data Collection
  - Internal
  - External
    - Open Data
    - Web Scraping and Driving
    - Paid Data

### Data Sourcing (I/O)


### Data Storage Design
   - Flat File
   - Binary File
   - Relational Database (SQL)
   - Schema-less Database (NO SQL)


## Data Processing



### Data Manipulation [acting on Atomics]

  - Validate:
    - the attributes of categorical variables
    - the range of numeric variables
       


### Data Wrangling [acting on Structures]
   
  - examine and explore: display and summarize (tables), then visualize (plots)
  - replace names
  - identify duplicates, and in case remove 
  - remove redundant information or not worth keeping: unnecessary rows (too many missing values?) and/or useless columns (internal codes?)
  - tidy data: every row must be an observtional unit, every column a 
    - if values has been uncorrectly stored as variables: *gather* variables into values, or *melt* columns into rows
    - if variables has been uncorrectly recorded as values: *spread* values as variables, or *cast* rows along columns
  - split values into different variables, if they include multiple pieces of information
  - combine multiple columns in a single variable
  - identify and in case coerce into the correct data types


### Data Imputation [Missing Values]

### Anomaly Detection [Outliers and Extreme Values]

### Feature Engineering [Attribute Selection, Domain Reduction]


## Data Exploration [Hypothesis Generation]

### Data Summaries

### Data Display

### Data Visualization


## Data Understanding

### Data Modelling [Hypothesis Confirmation, Explanatory Analysis]
You can only use an observation once to confirm a hypothesis. As soon as you use it more than once you’re back to doing exploratory analysis. This means to do hypothesis confirmation you need to “preregister” (write out in advance) your analysis plan, and not deviate from it even when you have seen the data. The key difference is how often do you look at each observation: if you look only once, it’s *confirmation*; if you look more than once, it’s *exploration*

### Data Learning [Pattern Discovery and Recognition, Predictive Analytics]


### Time Series [Forecasting]


### Spatial Data [GeoStatistics]


### Graphs [Network Analysis]


### Meta Analysis


## Data Presentation

  - Document
  - Flat File
  - Spreadsheet
  - Reporting System
  - Dashboard
  - Web Interactive Application
  

## Data Assessment



## Data Monitoring



<!--stackedit_data:
eyJoaXN0b3J5IjpbMTY1Mjc3MzU3OCwyMzk4OTM3NTYsLTY5ND
M3OTIzN119
-->