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
enable_qt=$(is_opt_set --qt-gui)

[ $(is_opt_set --all) ] && do_clean="yes" && do_build="yes" && do_make_module="yes" && do_download="yes"

version=$(get_opt_with --version)
[ -z $version ] && version=3.9.1
unpack_dir=${module_dir}/${module_name}-${version}
install_dir=${module_dir}/${version}
local_file=cmake-${version}.tar.gz
remote_file=https://cmake.org/files/v3.9/${local_file}

echo "[i] module_name    : " $module_name
echo "[i] version        : " $version
echo "[i] local_file     : " $local_file
echo "[i] do_download    : " $do_download
echo "[i] do_clean       : " $do_clean
echo "[i] do_build       : " $do_build
echo "[i] do_make_module : " $do_make_module
echo "[i] enable qt      : " $enable_qt

module use ${hepsoft_dir}/modules
if [ $(host_pdsf) ]; then
	echo "[i] pdsf_modules   : " $pdsf_modules
	module load ${pdsf_modules}
	[ $? != 0 ] && exit 1
else
	echo "[i] no extra modules loaded"
fi
module list

if [ $do_download ]; then
	cd ${module_dir}
	rm -rf ${local_file}
	wget $remote_file --no-check-certificate -O $local_file
	cd $wdir
fi

if [ $do_clean ]; then
	cd ${module_dir}
	echo "[i] cleaning ${unpack_dir}..."
	rm -rf ${unpack_dir}
	echo "[i] done cleaning."
	cd $wdir
fi

if [ $do_build ]; then
	cd ${module_dir}
	[ ! -e $local_file ] && echo "[e] file $local_file does not exist" && exit 1
	echo "[i] unpacking..."
	tar zxvf $local_file 2>&1 > /dev/null
	[ ! -d ${unpack_dir} ] && echo "[e] dir ${unpack_dir} does not exist" && exit 1
	cd ${unpack_dir}
	if [ $enable_qt ]; then
		./configure --prefix=${install_dir} --parallel=4 --qt-gui
	else
		./configure --prefix=${install_dir} --parallel=4
	fi
	make -j $(n_cores)
	make install
	cd $wdir
fi

echo "[i] install_dir: ${install_dir}"

[ $do_make_module ] && ${hepsoft_dir}/bin/make_module_from_current.sh -d ${install_dir} -n ${module_name} -v $version -o ${hepsoft_dir}/modules

cd $savedir
