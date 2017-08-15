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
	if [ -e $(which root-config) ]; then
	    rsys=`root-config --prefix`
	    rsysinc=`root-config --incdir`
	    rsyslib=`root-config --libdir`
	    root_opt="--with-root=$rsys --with-root-lib=$rsyslib --with-root-include=$rsysinc"
	fi
	if [ ${hepmcDIR} ]; then
		hepmc_opt=--with-hepmc2=$hepmcDIR
	fi
	if [ ${lhapdfDIR} ]; then
		lhapdf_opt=--with-lhapdf5=$lhapdfDIR
	fi
	if [ ${fastjetDIR} ]; then
		fastjet_opt=--with-fastjet3=$fastjetDIR
	fi

    ./configure --prefix=${install_dir} ${root_opt} ${hepmc_opt} ${lhapdf_opt} --with-python

	[ ${do_clean} ] && make clean
	make -j $(n_cores)
	make install

	sedi "s|-std=c++98||g" ${install_dir}/share/Pythia8/examples/Makefile.inc
	echo "[w] pathed ${install_dir}/share/Pythia8/examples/Makefile.inc"
}

exec_build
make_module

cd $savedir
