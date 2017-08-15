#!/bin/bash

savedir=$PWD
hepsoft_dir=<hepsoft>
source ${hepsoft_dir}/bin/tools.sh
process_variables $BASH_SOURCE $@
cd $wdir
echo_common_settings
process_modules
prep_build

function build()
{
	if [ -z ${cgalDIR} ]; then
	    ./configure --prefix=${install_dir}
	else
		echo "[i] building using cgal at ${cgalDIR}"
	    ./configure --prefix=${install_dir} --enable-cgal --with-cgaldir=${cgalDIR} LDFLAGS=-Wl,-rpath,${boostDIR}/lib CXXFLAGS=-I${boostDIR}/include CPPFLAGS=-I${boostDIR}/include
	fi
	[ ${do_clean} ] && make clean
	make -j $(n_cores)
	make install
}

exec_build
make_module

cd $savedir