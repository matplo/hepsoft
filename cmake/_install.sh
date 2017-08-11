#!/bin/bash

#source /project/projectdirs/alice/ploskon/software/hepsoft/bin/tools.sh
hepsoft_dir=<hepsoft>
wdir=${hepsoft_dir}
savedir=$PWD
cd $wdir
source ${hepsoft_dir}/bin/tools.sh
pdsf_modules="gcc python qt"
module_name=$(module_name $BASH_SOURCE)
module_dir=${hepsoft_dir}/${module_name}
do_clean=$(is_opt_set --clean)
do_build=$(is_opt_set --build)
do_make_module=$(is_opt_set --module)
do_download=$(is_opt_set --download)

[ $(is_opt_set --all) ] && do_clean="yes" && do_build="yes" && do_make_module="yes" && do_download="yes"

version=$(get_opt_with --version)
[ -z $version ] && version=3.9.0
unpack_dir=${module_dir}/${module_name}-${version}
install_dir=${module_dir}/${version}
local_file=cmake-${version}.tar.gz
remote_file=https://cmake.org/files/v3.9/${local_file}

echo "[i] pdsf_modules: " $pdsf_modules
echo "[i] module_name : " $module_name
echo "[i] version     : " $version
echo "[i] local_file  : " $local_file
echo "[i] do_download : " $do_download

module use ${hepsoft_dir}/modules
if [ $(host_pdsf) ]; then
	module load ${pdsf_modules}
	[ $? != 0 ] && exit 1
else
	# module load cmake/3.9.0
	echo "[i] no extra modules loaded"
fi
module list

if [ "$do_download"="yes" ]; then
	echo $do_download
	cd ${module_dir}
	rm -rf ${local_file}
	wget $remote_file --no-check-certificate -O $local_file
	cd $wdir
fi

if [ "${do_clean}"="yes" ]; then
	cd ${module_dir}
	echo "[i] cleaning ${unpack_dir}..."
	rm -rf ${unpack_dir}
	echo "[i] done cleaning."
	cd $wdir
fi

if [ "${do_build}"="yes" ]; then
	cd ${module_dir}
	[ ! -e $local_file ] && echo "[e] file $local_file does not exist" && exit 1
	echo "[i] unpacking..."
	tar zxvf $local_file 2>&1 > /dev/null
	[ ! -d ${unpack_dir} ] && echo "[e] dir ${unpack_dir} does not exist" && exit 1
	cd ${unpack_dir}
	./configure --prefix=${install_dir} --parallel=4 --qt-gui
	make -j
	make install
	cd $wdir
fi

echo "[i] install_dir: ${install_dir}"

[ $do_make_module ] && ${hepsoft_dir}/bin/make_module_from_current.sh -d ${install_dir} -n ${module_name} -v $version -o ${hepsoft_dir}/modules

cd $savedir
