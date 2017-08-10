#!/bin/bash

source /project/projectdirs/alice/ploskon/software/hepsoft/bin/tools.sh

pdsf_modules="gcc python cmake/3.9.0"

cdir=$this_dir
module_name=$(strip_root_dir)
clean=$(is_opt_set --clean)
do_build=$(is_opt_set --build)
do_make_module=$(is_opt_set --module)
version=$(get_opt_with --version)
[ -z $version ] && version=1.64.0
_version=$(echo $version | sed 's|\.|_|g')
unpack_dir=$cdir/${module_name}_${_version}

remote_file=/boostorg/release/${version}/source/boost_${_version}.tar.gz
local_file=`basename $remote_file`
[ $(is_opt_set --download) ] && rm -rf ${local_file} && wget https://dl.bintray.com/$remote_file -O $local_file

if [ $clean ]; then
	echo "[i] cleaning ${unpack_dir}..."
	rm -rf ${unpack_dir}
	echo "[i] done cleaning."
fi

module use $up_dir/modules
if [ $(host_pdsf) ]; then
	module load ${pdsf_modules}
else
	# module load cmake/3.9.0
	echo "[i] no extra modules loaded"
fi
module list

if [ ${do_build} ]; then
	[ ! -e $local_file ] && echo "[e] file $local_file does not exist" && exit 1
	echo "[i] unpacking..."
	tar zxvf $local_file 2>&1 > /dev/null
	[ ! -d ${unpack_dir} ] && echo "[e] dir ${unpack_dir} does not exist" && exit 1
	cd ${unpack_dir}
	time ./bootstrap.sh --prefix=$cdir/$version
	time ./b2 install
fi

cd $cdir

$up_dir/bin/make_module_from_current.sh -d $this_dir/$version -n ${module_name} -v $version -o ../modules/
