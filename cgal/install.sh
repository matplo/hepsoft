#!/bin/bash

cdir=$PWD

version=$1
[ -z $version ] && version=4.10

local_file=CGAL-${version}.tar.gz
remote_file=CGAL/cgal/archive/releases/${local_file}
[ ! -e $local_file ] && wget https://github.com/$remote_file -O $local_file
unpack_dir=$cdir/cgal-releases-CGAL-${version}
# rm -rf ${unpack_dir}
# tar zxvf $local_file
build_dir=$PWD/build_${version}
rm -rf ${build_dir}
mkdir -p ${build_dir}
cd $build_dir

module use $cdir/../modules
[ $(uname -n | cut -c 1-4) = "pdsf" ] && module load gcc boost/1.64.0 cmake/3.9.0
module list

cmake -DCMAKE_INSTALL_PREFIX=$cdir/$version -DCMAKE_BUILD_TYPE=Release -DBOOST_ROOT=${boostDIR} ${unpack_dir}
make clean
make -j all
make install

cd $cdir

../bin/make_module_from_current.sh -d $PWD/$version -n CGAL -v $version -o ../modules/
