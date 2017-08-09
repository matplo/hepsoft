#!/bin/bash

cdir=$PWD

modules_dir=$(dirname $cdir)/modules
module use $modules_dir
# [ $(uname -n | cut -c 1-4) = "pdsf" ] && module load CGAL/4.10
[ $(uname -n | cut -c 1-4) = "pdsf" ] && module load gcc python 
module load hepmc lhapdf
module list

[ -z "$LHAPDFDIR" ] && echo "[error] needs LHAPDFDIR" && exit 1
fjpath=$(fastjet-config --prefix)
[ -z "$fjpath" ] && echo "[error] needs fastjet-config" && exit 1

version=8226
local_file="pythia$version.tgz"
srcdir="pythia$version"
[ ! -e $local_file ] && wget http://home.thep.lu.se/~torbjorn/pythia8/$local_file
tar xvf $local_file
install_dir=$cdir/$version

cd $srcdir

if [ -e $(which root-config) ]; then
    rsys=`root-config --prefix`
    rsysinc=`root-config --incdir`
    rsyslib=`root-config --libdir`
    ./configure --prefix=$install_dir \
	--enable-shared \
	--with-root=$rsys \
	--with-root-lib=$rsyslib \
	--with-root-include=$rsysinc \
	--with-hepmc2=$HEPMCDIR \
	--with-fastjet3=$fjpath
else
    ./configure --prefix=$install_dir \
	--enable-shared \
	--with-hepmc2=$HEPMCDIR \
	--with-fastjet3=$fjpath
fi

make -j && make install

chmod +x $install_dir/bin/pythia8-config
$cdir/../bin/make_module_from_current.sh -d $install_dir -n fastjet -v $version -o $cdir/../modules/

cd $cdir

