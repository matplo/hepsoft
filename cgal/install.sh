#!/bin/bash

cdir=$PWD

version=$1
[ -z $version ] && version=4.10

remote_file=CGAL/cgal/archive/releases/CGAL-$version.tar.gz
local_file=`basename $remote_file`
[ ! -e $local_file ] && wget https://github.com/$remote_file -O $local_file
unpack_dir=$cdir/cgal-releases-CGAL-$version
rm -rf ${unpack_dir}
tar zxvf $local_file
build_dir=$PWD/build_${version}
rm -rf ${build_dir}
mkdir -p ${build_dir}
cd $build_dir

[ $(uname -n | cut -c 1-4) = "pdsf" ] && module load modules cmake gcc boost

cmake -DCMAKE_INSTALL_PREFIX=$cdir/$version -DCMAKE_BUILD_TYPE=Release ${unpack_dir}
make -j all
make install

cd $cdir

../bin/make_module_from_current.sh -d $PWD/$version -n CGAL -v $version -o ../modules/
