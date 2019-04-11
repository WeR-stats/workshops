# remember to first cd into the subfolder (~/scripts/r_packages/)
pkgs <- readLines(file('r_packages.lst'))
pkgs <- pkgs[!sapply(pkgs, require, char = TRUE)]
if(length(pkgs) > 0) install.packages(pkgs)
