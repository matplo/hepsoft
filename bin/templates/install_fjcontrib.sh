#!/bin/bash

savedir=$PWD

XDIR="<dir to be set>"
working_dir="$XDIR/fjcontrib"
mkdir -p $working_dir

function find_cgal()
{
    ext="so"
    syst=`uname -n`
    [ "$syst"="Darwin" ] && ext="dylib"
    cgaldir=""
    libpath=$1
    # too wild..? - ok for macports /usr/lib
    IFS=:
    for p in ${libpath}; do
	echo " - checking for libCGAL.${ext} in ${p}"
	libcgal="${p}/libCGAL.${ext}"
	libcgal_lib="${p}/lib/libCGAL.${ext}"
	if [ -e "${libcgal}" ]; then
            echo "[i] found CGAL: ${libcgal}"
	    cgaldir=`dirname ${p}`
	fi
    done
    result=$2
    if [[ "$result" ]]; then
	eval $result=$cgaldir
    fi
}

function exec_configure()
{
    cgaldep=""
    find_cgal "${LD_LIBRARY_PATH}:${DYLD_LIBRARY_PATH}:/opt/local/lib" cgaldir
    if [ -z $cgaldir ]; then
	./configure --prefix=$1 CXXFLAGS="-shared -fPIC"
    else
	./configure --prefix=$1 --enable-cgal --with-cgaldir=$cgaldir CXXFLAGS="-shared -fPIC"
    fi
}

if [ ! -d "$working_dir" ]; then
    echo "[error] $working_dir does not exist."
else
    version=$1
    #[ -z $version ] && version=3.1.2
    [ -z $version ] && version=1.026
    #install_dir="$working_dir/$version"
    install_dir=$FASTJETDIR

    cd $working_dir
    echo $PWD
    echo "[i] will install to: $install_dir"
    echo "[i] installing fastjet $version"

    fdfile="fjcontrib-$version.tar.gz"
    srcdir="fjcontrib-$version"
    echo "[i] file to download: $fdfile"
    echo "[i] source sub dir: $srcdir"
    if [ -e "./downloads/$fdfile" ]; then
        echo "[i] $fdfile exists - will not download"
    else
        mkdir -p ./downloads
        cd ./downloads
        wget http://fastjet.hepforge.org/contrib/downloads/$fdfile
        cd -
    fi
    tar zxvf ./downloads/$fdfile
    cd $srcdir

    [ "$2" = "clean" ] && make clean

    exec_configure $install_dir

    make
    # make check
    make install

fi

cd $savedir
