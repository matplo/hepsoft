#!/bin/bash


BT_install_prefix=<hepsoft>
BT_module_paths=${BT_install_prefix}/modules
BT_modules="cmake boost"

BT_name=cgal
BT_version=4.10
BT_remote_file=https://github.com/CGAL/cgal/archive/releases/CGAL-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	if [ $(host_pdsf) ]; then
		cd ${BT_src_dir}
		cmake -DCMAKE_INSTALL_PREFIX=${BT_install_dir} -DCMAKE_BUILD_TYPE=${BT_buid_type} -DBOOST_ROOT=${BOOST_DIR} .
	else
		cmake -DCMAKE_INSTALL_PREFIX=${BT_install_dir} -DCMAKE_BUILD_TYPE=${BT_buid_type} -DBOOST_ROOT=${BOOST_DIR} ${BT_src_dir}
	fi
	[ ${BT_clean} ] && make clean
	make -j $(n_cores) all
	make install
	# this step is needed for fastjet...
	ln -sv ${BT_install_dir}/lib64 ${BT_install_dir}/lib
}
