#!/bin/bash

BT_install_prefix=<hepsoft>
BT_module_paths=${BT_install_prefix}/modules
BT_modules="cmake boost cgal"

BT_name=fastjet
BT_version=3.3.0
BT_remote_file=http://fastjet.fr/repo/fastjet-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	cd ${BT_src_dir}
	if [ "x${CGAL_DIR}" == "x" ]; then
	    ./configure --prefix=${install_dir}
	else
		echo "[i] building using cgal at ${CGAL_DIR}"
	    ./configure --prefix=${BT_install_dir} --enable-cgal --with-cgaldir=${CGAL_DIR} LDFLAGS=-Wl,-rpath,${BOOST_DIR}/lib CXXFLAGS=-I${BOOST_DIR}/include CPPFLAGS=-I${BOOST_DIR}/include
	fi
	make -j $(n_cores)
	make install
}
