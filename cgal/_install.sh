#!/bin/bash


BT_install_prefix=<hepsoft>
BT_module_paths=${BT_install_prefix}/modules
BT_modules=boost

BT_name=cgal
BT_version=4.10
BT_remote_file=https://github.com/CGAL/cgal/archive/releases/CGAL-4.10.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	cmake -DCMAKE_INSTALL_PREFIX=${BT_install_dir} -DCMAKE_BUILD_TYPE=${BT_buid_type} -DBOOST_ROOT=${BOOSTDIR} ${BT_src_dir}
	[ ${BT_clean} ] && make clean
	make -j $(n_cores) VERBOSE=$BT_verbose
	make install
	# this step is needed for fastjet...
	ln -sv ${BT_install_dir}/lib64 ${BT_install_dir}/lib
}
