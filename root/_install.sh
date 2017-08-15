#!/bin/bash

savedir=$PWD
hepsoft_dir=<hepsoft>
source ${hepsoft_dir}/bin/tools.sh
process_variables $BASH_SOURCE $@
cd $wdir

unpack_dir=${module_dir}/root.git
local_file=${unpack_dir}

echo_common_settings
process_modules

function prep_build()
{
	if [ $do_clean ]; then
		cd ${module_dir}
		if [ -d ${unpack_dir} ]; then
			echo "[i] cleaning ${unpack_dir}..."
			rm -rf ${unpack_dir}
		fi
		if [ -d ${build_dir} ]; then
			echo "[i] cleaning ${build_dir}..."
			rm -rf ${build_dir}
		fi
		echo "[i] done cleaning."
		cd $wdir
	fi

	if [ $do_download ]; then
		echo "[i] git commands... with ${remote_dir} and directory ${unpack_dir}"
		cd ${module_dir}
		[ ! -d ${unpack_dir} ] && git clone ${remote_dir} ${unpack_dir}
		cd ${unpack_dir}
		if [ $(git status -s -b | cut -f 2 -d " " | xargs echo -n) == ${version} ]; then
			echo "[i] already on ${version} branch..."
		else
			git checkout -b ${version} ${version}
			echo "[i] checking out version ${version}"
		fi
		cd $wdir
	fi

	mkdir -pv ${build_dir}
}

prep_build

function build()
{
	which gfortran
	which gcc
	[ $(host_pdsf) ] && config_opts="-Dxrootd=OFF -Dldap=OFF"
	compiler_opts="-DCMAKE_C_COMPILER=$(which gcc) -DCMAKE_CXX_COMPILER=$(which g++) -DCMAKE_Fortran_COMPILER=$(which gfortran)"
	cd ${build_dir}
	echo "[i] extra options: ${config_opts} ${compiler_opts}"
	cmake ${unpack_dir} ${config_opts} ${compiler_opts}
	cmake --build . -- -j $(n_cores)
	cmake -DCMAKE_INSTALL_PREFIX=${install_dir} -P cmake_install.cmake
}

exec_build
make_module

cd $savedir
