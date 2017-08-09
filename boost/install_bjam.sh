#!/bin/bash

cdir=$PWD
clean=
version=$1
[ -z $version ] && version=1.64.0
_version=$(echo $version | sed 's|\.|_|g')
remote_file=/boostorg/release/${version}/source/boost_${_version}.tar.gz
local_file=`basename $remote_file`
[ ! -e $local_file ] && wget https://dl.bintray.com/$remote_file -O $local_file
unpack_dir=$cdir/boost_${_version}
if [ ! -z $clean ]; then
	echo "[i] cleaning old dir..."
	rm -rf ${unpack_dir}
	echo "[i] unpacking..."
	tar zxvf $local_file 2>&1 > /dev/null
	echo "[i] done."
fi

module use $cdir/../modules
[ $(uname -n | cut -c 1-4) = "pdsf" ] && module load cmake gcc python && module load cmake/3.9.0
module list

cd ${unpack_dir}
time ./bootstrap.sh --prefix=$cdir/$version
time ./b2 install

cd $cdir

../bin/make_module_from_current.sh -d $PWD/$version -n boost -v $version -o ../modules/
