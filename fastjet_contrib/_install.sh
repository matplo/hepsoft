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
	fjconf=$(executable_from_path fastjet-config)
	if [ $fjconf ]; then
		install_dir=$(fastjet-config --prefix)
		[ ${do_clean} ] && make clean
		./configure --prefix=$install_dir CXXFLAGS="-shared -fPIC"
		make -j $(n_cores)
		make install
	else
		echo "[w] fastjet-config not found. stop." && exit 1
	fi
}

exec_build
# make_module - no module for this one - installed where the fastjet sits

cd $savedir
