#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules cmake boost

BT_name=YODA
BT_version=1.7.0
BT_remote_file=http://www.hepforge.org/archive/yoda/YODA-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	cd ${BT_src_dir}
	./configure --prefix=${BT_install_dir}
	make -j $(n_cores) && make install
}
