#!/bin/bash

BT_install_prefix=<hepsoft>
# add_prereq_modules

BT_name=binutils
BT_version=2.25.1
BT_remote_file=http://ftp.gnu.org/gnu/binutils/binutils-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	cd ${BT_src_dir}
	./configure --prefix=${BT_install_dir}
	make -j $(n_cores)
	make install
}
