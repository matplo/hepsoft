#!/bin/bash

BT_install_prefix=<hepsoft>
# add_prereq_modules

BT_name=cmake
BT_version=3.9.1
BT_remote_file=https://cmake.org/files/v3.9/cmake-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	enable_qt=$(is_opt_set --qt-gui)
	echo "[i] enable qt      : " $BT_enable_qt
	if [ $(host_pdsf) ]; then
		echo "[i] this is PDSF"
		cd ${BT_src_dir}
		./configure --prefix=${BT_install_dir}
	else
		if [ "x${BT_enable_qt}" = "x" ]; then
			${BT_src_dir}/configure --prefix=${BT_install_dir} --parallel=4 --qt-gui
		else
			${BT_src_dir}/configure --prefix=${BT_install_dir} --parallel=4
		fi
	fi
	make -j $(n_cores)
	make install
}
