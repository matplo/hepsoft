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
	enable_qt=$(is_opt_set --qt-gui)
	echo "[i] enable qt      : " $enable_qt
	if [ $enable_qt ]; then
		./configure --prefix=${install_dir} --parallel=4 --qt-gui
	else
		./configure --prefix=${install_dir} --parallel=4
	fi
	make -j $(n_cores)
	make install
}

exec_build
make_module

cd $savedir
