# remember to first cd into the subfolder (~/scripts/r_packages/)
pkgs <- readLines(file('r_packages.lst'))
pkgs <- pkgs[!sapply(pkgs, require, char = TRUE)]
install.packages(pkgs)
