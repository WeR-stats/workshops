# remember to first cd into the subfolder (~/scripts/r_packages/)
library(devtools)
pkgs <- readLines(file('r_packages_gh.lst'))
pkgs <- pkgs[!unname(sapply(sapply(strsplit(pkgs, '/'), '[', 2), require, char = TRUE))]
for(pkg in pkgs) install_github(pkg, dep = FALSE)
