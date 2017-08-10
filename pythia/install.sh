#!/bin/bash

cdir=$PWD

function abspath()
{
  case "${1}" in
    [./]*)
    echo "$(cd ${1%/*}; pwd)/${1##*/}"
    ;;
    *)
    echo "${PWD}/${1}"
    ;;
  esac
}

function thisdir()
{
        THISFILE=`abspath $BASH_SOURCE`
        XDIR=`dirname $THISFILE`
        if [ -L ${THISFILE} ];
        then
            target=`readlink $THISFILE`
            XDIR=`dirname $target`
        fi

        THISDIR=$XDIR
        echo $THISDIR
}

hepsoft_dir=$(dirname $(thisdir))

modules_dir=${hepsoft_dir}/modules
module use $modules_dir
[ $(uname -n | cut -c 1-4) = "pdsf" ] && module load CGAL/4.10 root/v5-34-34
# [ $(uname -n | cut -c 1-4) = "pdsf" ] && module load gcc python
module load hepmc lhapdf root fastjet
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
	--with-fastjet3=$fjpath \
    --with-lhapdf5=$LHAPDFDIR \
	--with-python
else
    ./configure --prefix=$install_dir \
	--enable-shared \
	--with-hepmc2=$HEPMCDIR \
	--with-fastjet3=$fjpath \
    --with-lhapdf5=$LHAPDFDIR \
	--with-python
fi

make -j && make install

chmod +x $install_dir/bin/pythia8-config

ftopatch=$install_dir/share/Pythia8/examples/Makefile.inc
if [ -e $ftopatch ]; then
	echo "[i] patching $ftopatch..."
	${hepsoft_dir}/bin/sedi.sh "s|-std=c++98||g" $ftopatch
fi
echo "[i] testing pythia8-config..."
$install_dir/bin/pythia8-config --libs

$cdir/../bin/make_module_from_current.sh -d $install_dir -n pythia -v $version -o $cdir/../modules/

cd $cdir

