#################################################
# UK FOOD HYGIENE RATING - DATA VIZ INTERACTIVE #
#################################################

# load packages
pkgs <- c('data.table', 'fst', 'ggplot2')
invisible(lapply(pkgs, require, character.only = TRUE))

# load data
lads <- fread('data/lads')
shops <- read.fst('data/shops', as.data.table = TRUE)

