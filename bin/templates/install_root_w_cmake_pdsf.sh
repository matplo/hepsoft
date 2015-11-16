#!/bin/bash

savedir=$PWD

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

THISFILE=`abspath $BASH_SOURCE`
XDIR=`dirname $THISFILE`
if [ -L ${THISFILE} ];
then
    target=`readlink $THISFILE`
    XDIR=`dirname $target`
fi

THISDIR=$XDIR

idir=$1
[ -z $1 ] && idir=$THISDIR

$THISDIR/install_root_w_cmake.sh -g -d $idir
$THISDIR/install_root_w_cmake.sh -c -n -o -Dxrootd=OFF -o -Dldap=OFF -d $idir
$THISDIR/install_root_w_cmake.sh -b -d $idir
$THISDIR/install_root_w_cmake.sh -i -n -d $idir



