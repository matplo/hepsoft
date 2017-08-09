#!/bin/bash

[ $(uname -n | cut -c 1-4) = "pdsf" ] && module load modules cmake gcc python git
module list

cdir=$PWD

version=$1
[ -z $version ] && version=1.64.0
_version=$(echo $version | sed 's|\.|_|g')
remote_file=/boostorg/release/${version}/source/boost_${_version}.tar.gz
local_file=`basename $remote_file`
[ ! -e $local_file ] && wget https://dl.bintray.com/$remote_file -O $local_file

if [ -d BoostBuilder.git ]; then
    cd BoostBuilder.git
    git pull
    cd $cdir
else
    git clone git@github.com:drbenmorgan/BoostBuilder.git BoostBuilder.git
fi

mkdir -p Boost.Build
cd Boost.Build
cmake -DCMAKE_INSTALL_PREFIX=$cdir/$version ../BoostBuilder.git
make -j
make install

cd $cdir

../bin/make_module_from_current.sh -d $cdir/$version -n boost -v $version -o ../modules/
