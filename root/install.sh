#!/bin/bash

savedir=$PWD

optstring="bcd:ghinv:o:m"

#!/bin/bash

cdir=$PWD
modules_dir=$(dirname $cdir)/modules
module use $modules_dir
if [ $(uname -n | cut -c 1-4) = "pdsf" ]; then
    module load gcc python cmake/3.9.0
    #module load cmake git
fi
module list
gcc -v

version=$1
[ -z $version ] && version=v5-34-34 && echo "[w] using default version"
echo "[i] version is $version"
# from https://root.cern.ch/get-root-sources
# https://root.cern.ch/building-root

git_dir=$cdir/root
[ ! -d $git_dir ] && git clone http://root.cern.ch/git/root.git
cd $git_dir
git checkout -b $version $version

config_opts=
if [ $(uname -n | cut -c 1-4) = "pdsf" ];
then 
    config_opts="-Dxrootd=OFF -Dldap=OFF"
fi

install_dir=${cdir}/${version}
bdir="${cdir}/build_${version}"
mkdir -p $bdir && cd $bdir && cmake $git_dir $config_opts
cd $bdir && cmake --build .
cd $bdir && cmake -DCMAKE_INSTALL_PREFIX=$install_dir -P cmake_install.cmake
$cdir/../bin/make_module_from_current.sh -d $install_dir -n fastjet -v $version -o $cdir/../modules/

cd $cdir


