#!/bin/bash

cdir=$PWD
module load gcc python qt
#qt/5.5.0

version=3.9.0
local_file=cmake-${version}.tar.gz
[ ! -e $local_file ] && wget https://cmake.org/files/v3.9/${local_file} --no-check-certificate

local_dir=cmake-${version}
rm -rf $local_dir
tar zxvf $local_file
cd $local_dir
./configure --prefix=$cdir/$version --parallel=4 --qt-gui
make -j
make install
cd $cdir

$cdir/../bin/make_module_from_current.sh -d $cdir/3.9.0 -n cmake -v 3.9.0 -o $cdir/../modules/
