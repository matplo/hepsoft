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
echo $modules_dir
module use $modules_dir
module avail

fentries=$(find $modules_dir -name "*")
for fdir in $fentries
do
    if [ -d $fdir ]; then
	fmod=$(basename $fdir)
	if [ $fmod != "hepsoft" ]; then
	    module load $fmod
	fi
    fi
done

module list

version=latest
${hepsoft_dir}/bin/make_module_from_current.sh -d ${hepsoft_dir} -n hepsoft -v $version -o ${modules_dir}

cd $cdir
