#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules cmake root hepmc lhapdf boost cgal fastjet
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

BT_name=pythia8
BT_version=8226
BT_remote_file=http://home.thep.lu.se/~torbjorn/pythia8/pythia${BT_version}.tgz

function build()
{
	cd ${BT_src_dir}
	if [ -e $(which root-config) ]; then
	    rsys=`root-config --prefix`
	    rsysinc=`root-config --incdir`
	    rsyslib=`root-config --libdir`
	    root_opt="--with-root=$rsys --with-root-lib=$rsyslib --with-root-include=$rsysinc"
	fi
	if [ ! -z ${hepmcDIR} ]; then
		hepmc_opt=--with-hepmc2=$hepmcDIR
	fi
	if [ ! -z ${lhapdfDIR} ]; then
		lhapdf_opt=--with-lhapdf5=$lhapdfDIR
	fi
	if [ ! -z ${fastjetDIR} ]; then
		fastjet_opt=--with-fastjet3=$fastjetDIR
	fi

	# python_inc_dir=/usr/include/python2.7
	python_inc_dir=$(python-config --includes | cut -d' ' -f 1 | cut -dI -f 2)
	python_exec=$(which python)
	python_bin_dir=$(dirname ${python_exec})
    ./configure --prefix=${BT_install_dir} ${root_opt} ${hepmc_opt} ${lhapdf_opt} \
    	--with-python-include=${python_inc_dir} --with-python-bin=${python_bin_dir}

	make -j $(n_cores)
	make install

	sedi "s|-std=c++98||g" ${BT_install_dir}/share/Pythia8/examples/Makefile.inc
	echo "[w] pathed ${BT_install_dir}/share/Pythia8/examples/Makefile.inc"
}
