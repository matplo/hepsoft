#!/bin/bash

BT_install_prefix=<hepsoft>
BT_module_paths=${BT_install_prefix}/modules
BT_modules="cmake boost cgal fastjet"

BT_name=fastjet_contrib
BT_version=1.027
BT_remote_file=http://fastjet.hepforge.org/contrib/downloads/fjcontrib-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	fjconf=$(executable_from_path fastjet-config)
	if [ $fjconf ]; then
		export BT_install_dir=$(fastjet-config --prefix)
		echo_padded_BT_var install_dir
		cd ${BT_src_dir}
		./configure --prefix=${BT_install_dir} CXXFLAGS="-shared -fPIC"
		make -j $(n_cores)
		make install
	else
		echo "[w] fastjet-config not found. stop." && do_exit ${BT_error_code}
	fi
}

function make_module()
{
	separator "no module for ${BT_name}"
}
