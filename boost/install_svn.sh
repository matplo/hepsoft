#!/bin/bash

cdir=$PWD

version=svn

svn_dir=$cdir/dowload_${version}
src_dir=$svn_dir/src
mkdir -p $src_dir
module load subversion
svn co http://svn.boost.org/svn/boost/branches/release $src_dir

[ $(uname -n | cut -c 1-4) = "pdsf" ] && module load modules cmake gcc python

build_dir=$cdir/build_${version}

rm -rf $build_dir
mkdir $build_dir
cd $build_dir
cmake -DCMAKE_INSTALL_PREFIX=$cdir/$version -DCMAKE_BUILD_TYPE=Release ${src_dir}
make -j
make install
cd $cdir

../bin/make_module_from_current.sh -d $cdir/$version -n boost -v $version -o ../modules/
