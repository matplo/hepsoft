#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules cmake boost cgal

BT_name=fastjet
BT_version=3.3.2
BT_remote_file=http://fastjet.fr/repo/fastjet-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}
python_version=$(python3 --version | cut -f 2 -d' ' | cut -f 1-2 -d.)
BT_pythonlib=python${python_version}/site-packages

function build()
{
	cd ${BT_src_dir}
	if [ "x${CGAL_DIR}" == "x" ]; then
	    ./configure --prefix=${BT_install_dir} --enable-allcxxplugins
	else
		echo "[i] building using cgal at ${CGAL_DIR}"
	    ./configure --prefix=${BT_install_dir} --enable-allcxxplugins \
	    --enable-cgal --with-cgaldir=${CGAL_DIR} \
	    --enable-pyext \
	    LDFLAGS=-Wl,-rpath,${BOOST_DIR}/lib CXXFLAGS=-I${BOOST_DIR}/include CPPFLAGS=-I${BOOST_DIR}/include
	fi
	make -j $(n_cores)
	make install
}
