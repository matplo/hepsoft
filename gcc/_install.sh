#!/bin/bash

BT_install_prefix=<hepsoft>
#add_prereq_modules binutils/2.25.1
#add_prereq_module_paths /project/projectdirs/alice/ploskon/software/hepsoft/modules

BT_name=gcc
#BT_version=4.9.3
BT_version=9.1.0
BT_remote_file=ftp.gnu.org/gnu/gcc/gcc-${BT_version}/gcc-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	cd ${BT_src_dir}
	./configure --prefix=${BT_install_dir} --enable-languages=c,c++,fortran --disable-multilib
	make -j $(n_cores) && make install
}
