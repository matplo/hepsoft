#!/bin/bash

# note this requires apt-get install tclx8.4-dev
# note CPPFLAGS needed for compilation - using depreciated feat

BT_install_prefix=<hepsoft>
BT_modules=

BT_name=envmodules
BT_version=3.2.10
BT_remote_file=https://sourceforge.net/projects/modules/files/Modules/modules-${BT_version}/modules-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	# cd ${BT_src_dir}
	${BT_src_dir}/configure --prefix=${BT_install_dir} CPPFLAGS="-DUSE_INTERP_ERRORLINE"
	make -j $(n_cores)
	make install
}
