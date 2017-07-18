#!/bin/bash

savedir=$PWD

optstring="bcd:ghinv:o:m"

function usage
{
	ex=`basename $BASH_SOURCE`
	echo "[i] usage: $ex $optstring"
	echo "    directory   <-d> < "$xdir" >"
	echo "    version     <-v> < "$version" >"
	echo "    git clone   [-g] [ "$clone" ]"
	echo "    configure   [-c] [ "$configure" ]"
	echo "    config_opts [-o] < "$config_opts" >"
	echo "    build       [-b] [ "$build" ]"
	echo "    install     [-i] [ "$install" ]"
	echo "    clean       [-n] [ "$clean" ]"
	echo "    make module [-m] [ "$makemodule" ]"
	echo "    help        [-h] [ "$help" ]"
}

cmndargs=$*
function check_for_errors
{
	#opts=${@:2}
	#echo "check_for_errors optstring:" $optstring "opts:" $cmndargs
	#args=`getopt $optstring $cmndargs 2>&1 > /dev/null` ; errcode=$?; set -- $args
	args=`getopt $optstring $cmndargs` ; errcode=$?; set -- $args
	if [ $errcode != 0 ]; then
		echo "[e] unknown or invalid argument(s) given"
		usage
		return 2
	fi
	return $errcode
}

function is_arg_set
{
	pattern=$1
	args=`getopt $optstring $cmndargs` ; errcode=$?; set -- $args
	#echo "[is_arg_set] args found: $args"
	for o in $args
	do
		case $o in
				$pattern )
					#echo "$pattern is set"
					echo "yes"
					;;
				-- )
					break;;
		esac
	done
	echo ""
}

function arg_with
{
	pattern=$1
	args=`getopt $optstring $cmndargs` ; errcode=$?; set -- $args
	#echo "[arg_with] found args are:"$args
	oarg=""
	let inext=0
	declare -a arr=($args)
	for o in $args
	do
		let inext=inext+1
		case "$o" in
				$pattern )
					#echo "[get_arg] arg for $pattern is" ${arr[$inext]}
					if [ -z $oarg ]; then
						oarg=${arr[$inext]}
					else
						oarg=$oarg" "${arr[$inext]}
					fi
					;;
				-- )
					break;;
		esac
	done
	echo $oarg
}

check_for_errors
if [ $? != 0 ]; then exit 2; fi
#if is_arg_set "-h"; then help=true; fi
help=`is_arg_set "-h"`
config_opts=`arg_with "-o"`
clone=`is_arg_set "-g"`
build=`is_arg_set "-b"`
configure=`is_arg_set "-c"`
install=`is_arg_set "-i"`
version=`arg_with "-v"`
clean=`is_arg_set "-n"`
xdir=`arg_with -d`
makemodule=`is_arg_set -m`

[ $help ] && usage && exit 0
#[ -z $version ] && echo "[e] version not specified" && usage && exit 0
#[ -z $version ] && version=v5-34-34 && echo "[w] using default version"
[ -z $version ] && version=v6-10-02 && echo "[w] using default version"
[ -z $xdir ] && xdir=$PWD && echo "[w] using PWD as working/install directory"
usage

function write_module_file()
{
    outfile=$HOME/privatemodules/root/$version
    outdir=`dirname $outfile`
    mkdir -p $outdir
    rm -rf $outfile

    cat>>$outfile<<EOF
#%Module
proc ModulesHelp { } {
        global version
        puts stderr "   Setup root \$version"
    }

set     version $version
setenv  ROOTSYS $1
setenv  ROOTDIR $1
setenv  ROOT_VERSION $2
prepend-path LD_LIBRARY_PATH $1/lib
prepend-path DYLD_LIBRARY_PATH $1/lib
prepend-path PATH $1/bin
prepend-path PYTHONPATH $1/lib

EOF
}

# from https://root.cern.ch/get-root-sources
# https://root.cern.ch/building-root

wdir=$xdir
mkdir -p $wdir
gitdir=$xdir/rootgit
bdir="$gitdir/build_$version"
idir=$xdir/root/$version

if [ "$clone" == "yes" ]; then
	mkdir -p $gitdir
	cd $gitdir
	git clone http://root.cern.ch/git/root.git
	cd $gitdir/root
	git pull
	# git checkout tags/$version
	# git checkout $version
	# cd $gitdir
	pwd
	git checkout -b $version
fi

if [ "$configure" == "yes" ]; then
	cd $wdir
	if [ "$clean" == "yes" ]; then
		rm -rf $bdir
	fi
	mkdir -p $bdir && cd $bdir && cmake $gitdir/root -Droofit=ON -Drpath=OFF $config_opts
fi

if [ "$build" == "yes" ]; then
	cd $bdir && cmake --build .
fi

if [ "$install" == "yes" ]; then
	cd $bdir && cmake -DCMAKE_INSTALL_PREFIX=$idir -P cmake_install.cmake && write_module_file $idir $version
	#ln -s $idir/bin/thisroot.sh "/usr/local/bin/root-$version"
fi

if [ "$makemodule" == "yes" ]; then
	write_module_file $idir $version
fi

cd $savedir


