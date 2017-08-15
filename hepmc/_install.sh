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
    ./configure --prefix=${install_dir} --with-momentum=GEV --with-length=CM
	[ ${do_clean} ] && make clean
	make -j $(n_cores)
	make install
}

exec_build
make_module

cd $savedir
