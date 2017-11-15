#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules root
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

BT_name=mcorrelations
BT_version=0.9
BT_remote_file=http://www.nbi.dk/~cholm/mcorrelations/correlations-${BT_version}.tar.gz

function build()
{
	cd ${BT_src_dir}
	echo_warning $PWD
	make install PREFIX=${BT_install_dir}
}
