#!/bin/bash

#source /project/projectdirs/alice/ploskon/software/hepsoft/bin/tools.sh
hepsoft_dir=<hepsoft>
wdir=${hepsoft_dir}
savedir=$PWD
cd $wdir
source ${hepsoft_dir}/bin/tools.sh
module_name=$(module_name $BASH_SOURCE)
	pdsf_modules=$(config_value ${module_name}_pdsf_modules)
module_deps=$(config_value ${module_name}_deps)
module_dir=${hepsoft_dir}/${module_name}
do_clean=$(is_opt_set --clean)
do_build=$(is_opt_set --build)
do_make_module=$(is_opt_set --module)
do_download=$(is_opt_set --download)
enable_qt=$(is_opt_set --qt-gui)
version=$(get_opt_with --version)
[ -z $version ] && version=$(config_value ${module_name})
unpack_dir=${module_dir}/${module_name}-${version}
install_dir=${module_dir}/${version}
local_file=${module_name}-${version}.tar.gz
remote_file=$(config_value ${module_name}_http_dir)/${local_file}

[ $(is_opt_set --all) ] && do_clean="yes" && do_build="yes" && do_make_module="yes" && do_download="yes"

echo_common_settings
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
