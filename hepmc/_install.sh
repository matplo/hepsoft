#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules cmake
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

BT_name=hepmc
BT_version=2.06.09
BT_remote_file=http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-${BT_version}.tar.gz

function build()
{
    cd ${BT_src_dir}
    ./configure --prefix=${BT_install_dir} --with-momentum=GEV --with-length=CM
	make -j $(n_cores)
	make install
}
