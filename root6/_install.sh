#!/bin/bash

savedir=$PWD

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules cmake
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

BT_name=root6
BT_version=v6-12-04
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

function python_settings
{
	export PYTHON_EXECUTABLE=`which python`
	#export PYTHON_INCLUDE_DIR=$(echo "from sysconfig import get_paths; info = get_paths(); print(info['include'])" | python)
	#export PYTHON_LIBRARY=$(echo "from sysconfig import get_paths; info = get_paths(); print(info['stdlib'])" | python)/config/libpython2.7.dylib
	export PYTHON_INCLUDE_DIR=$(python-config --includes | cut -f 1 -d " " | cut -c 3-)
	export PYTHON_LIBRARY_DIR=$(python-config --ldflags | cut -f 1 -d " " | cut -c 3-)
	export PYTHON_LIBRARY=${PYTHON_LIBRARY_DIR}/$(ls ${PYTHON_LIBRARY_DIR} | grep .dylib)
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
	[ $(os_darwin) ] && python_settings && config_opts="-DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE} -DPYTHON_INCLUDE_DIR=${PYTHON_INCLUDE_DIR} -DPYTHON_LIBRARY=${PYTHON_LIBRARY}"
	echo_warning "PYTHON_EXECUTABLE=$PYTHON_EXECUTABLE"
	echo_warning "PYTHON_INCLUDE_DIR=$PYTHON_INCLUDE_DIR"
	echo_warning "PYTHON_LIBRARY=$PYTHON_LIBRARY"
	compiler_opts="-DCMAKE_C_COMPILER=${_gcc} -DCMAKE_CXX_COMPILER=${_gpp} -DCMAKE_Fortran_COMPILER=${_gff}"
	echo "[i] extra options: ${config_opts} ${compiler_opts}"
	echo ${BT_src_dir}
	echo $(resolve_directory ${BT_src_dir})
	cmake -DCMAKE_BUILD_TYPE\=${BT_build_type} ${compiler_opts} ${config_opts} ${BT_src_dir}
	cmake --build . -- -j ${BT_n_cores}
	cmake -DCMAKE_INSTALL_PREFIX=${BT_install_dir} -P cmake_install.cmake
}
