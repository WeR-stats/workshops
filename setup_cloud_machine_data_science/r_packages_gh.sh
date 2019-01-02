#!/bin/sh
while read PKG
do
  cat $PWD/pwd | sudo -S su - -c "R -e \"devtools::install_github('$PKG'')\""
done < `dirname $0`/r_packages.lst
