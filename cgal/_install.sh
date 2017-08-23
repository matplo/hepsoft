#!/bin/bash


BT_install_prefix=<hepsoft>
BT_module_paths=${BT_install_prefix}/modules
BT_modules="cmake boost"

BT_name=cgal
BT_version=4.10
BT_remote_file=https://github.com/CGAL/cgal/archive/releases/CGAL-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}
BT_build_type=Release

function build()
{
	cmake -DCMAKE_INSTALL_PREFIX=${BT_install_dir} -DCMAKE_BUILD_TYPE=${BT_build_type} -DBOOST_ROOT=${BOOST_DIR} ${BT_src_dir}
	[ ${BT_clean} ] && make clean
	make -j $(n_cores)
	make install
	# cmake --build . -- -j ${BT_n_cores}
	# cmake -DCMAKE_INSTALL_PREFIX=${BT_install_dir} -P cmake_install.cmake
	ln -s ${BT_install_dir}/lib64 ${BT_install_dir}/lib
}
