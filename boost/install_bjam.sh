#!/bin/bash

savedir=$PWD
hepsoft_dir=/project/projectdirs/alice/ploskon/software/hepsoft
source ${hepsoft_dir}/bin/tools.sh
process_variables $BASH_SOURCE $@
cd $wdir
echo_common_settings
process_modules
prep_build

function build()
{
	time ./bootstrap.sh --prefix=${install_dir}
	time ./b2 install
}

exec_build
make_module

cd $savedir
