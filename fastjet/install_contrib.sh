#!/bin/bash

cdir=$PWD

version=1.026
local_file=fjcontrib-${version}.tar.gz
[ ! -e ${local_file} ] && wget http://fastjet.hepforge.org/contrib/downloads/${local_file}
local_dir=fjcontrib-${version}
rm -rf ${local_dir}
tar zxvf ${local_file}
cd $local_dir

modules_dir=$(dirname $cdir)/modules
module use $modules_dir
# [ $(uname -n | cut -c 1-4) = "pdsf" ] && module load CGAL/4.10
[ $(uname -n | cut -c 1-4) = "pdsf" ] && module load gcc python 
module load fastjet
module list

# install_dir=$cdir/$version
install_dir=$(fastjet-config --prefix)
if [ -d $install_dir ]; then
    ./configure --prefix=$install_dir
    make -j
    make install
fi
# $cdir/../bin/make_module_from_current.sh -d $install_dir -n fastjet_contrib -v $version -o $cdir/../modules/

cd $cdir
