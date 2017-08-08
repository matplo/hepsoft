#!/bin/bash

savedir=$PWD

XDIR="<dir to be set>"
working_dir="$XDIR/fjcontrib"
mkdir -p $working_dir

function exec_configure()
{
	./configure --prefix=$1 CXXFLAGS="-shared -fPIC"
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
