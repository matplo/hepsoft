#!/bin/bash

cdir=$PWD

module load modules cmake gcc boost

wget https://github.com/CGAL/cgal/archive/releases/CGAL-4.10.tar.gz
tar zxvf CGAL-4.10
cd cgal-releases-CGAL-4.10
cmake .
make -j

cd $cdir
./make_module.sh
