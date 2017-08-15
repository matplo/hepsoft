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
	echo "[i] build_dir is ${build_dir}"
	echo "[i] boost is at ${boostDIR}"
	cmake -DCMAKE_INSTALL_PREFIX=${install_dir} -DCMAKE_BUILD_TYPE=Release -DBOOST_ROOT=${boostDIR} ${unpack_dir}
	[ ${do_clean} ] && make clean
	make -j $(n_cores)
	make install
	# this step is needed for fastjet...
	ln -sv ${install_dir}/lib64 ${install_dir}/lib
}

exec_build
make_module

cd $savedir
