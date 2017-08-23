#!/bin/bash

savedir=$PWD

BT_install_prefix=<hepsoft>
BT_module_paths=${BT_install_prefix}/modules
BT_modules="cmake"
BT_module_dir=${BT_install_prefix}/modules/${BT_name}
BT_name=root
BT_version=v5-34-36
BT_remote_dir=http://root.cern.ch/git/root.git
BT_remote_file="installing_from_git"
BT_pythonlib=/
BT_build_type=Release
BT_local_file=${BT_src_dir}

function download()
{
	if [ $(bool ${BT_download}) ]; then
		separator "clone ${BT_name}/${BT_version}"
		setup_src_dir
		echo "[i] git commands... with ${BT_remote_dir} and sources directory ${BT_sources_dir}"
		echo "    and src directory ${BT_sources_dir}"
		if [ -d ${BT_src_dir} ]; then
			warning "sources dir exists ${BT_src_dir}"
		fi
		git clone ${BT_remote_dir} ${BT_src_dir}
		cd ${BT_src_dir}
		if [ $(git status -s -b | cut -f 2 -d " " | xargs echo -n) == "${BT_version}" ]; then
			echo "[i] already on ${BT_version} branch..."
		else
			git checkout -b ${BT_version} ${BT_version}
			echo "[i] checking out version ${BT_version}"
		fi
		cd ${BT_working_dir}
	fi
}

function build()
{
	cd ${BT_build_dir}
	module list
	which cmake
	echo $PWD
	local _gff=$(which gfortran)
	local _gcc=$(which gcc)
	local _gpp=$(which g++)
	[ $(host_pdsf) ] && config_opts="-Dxrootd=OFF -Dldap=OFF"
	compiler_opts="-DCMAKE_C_COMPILER=${_gcc} -DCMAKE_CXX_COMPILER=${_gpp} -DCMAKE_Fortran_COMPILER=${_gff}"
	echo "[i] extra options: ${config_opts} ${compiler_opts}"
	echo ${BT_src_dir}
	echo $(resolve_directory ${BT_src_dir})
	cmake -DCMAKE_BUILD_TYPE\=${BT_build_type} ${compiler_opts} ${config_opts} ${BT_src_dir}
	cmake --build . -- -j ${BT_n_cores}
	cmake -DCMAKE_INSTALL_PREFIX=${BT_install_dir} -P cmake_install.cmake
}
