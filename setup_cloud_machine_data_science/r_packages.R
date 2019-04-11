pkgs <- readLines(file('r_packages.lst'))
pkgs <- pkgs[!sapply(pkgs, require, char = TRUE)]
if(length(pkgs) > 0) install.packages(pkgs)
