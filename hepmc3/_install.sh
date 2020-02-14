#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
#add_prereq_modules cmake pythia8 root6
add_prereq_modules pythia8 root
BT_module_dir=${BT_install_prefix}/modules/${BT_name}/3

BT_name=hepmc
BT_version=3.0.0
# BT_remote_file=http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-${BT_version}.tar.gz
BT_remote_file=http://hepmc.web.cern.ch/hepmc/releases/hepmc${BT_version}.tgz

function build()
{
    cd ${BT_src_dir}
    # ./configure --prefix=${BT_install_dir} --with-momentum=GEV --with-length=CM
	cmake -DCMAKE_INSTALL_PREFIX=${BT_install_dir} \
	      -DHEPMC_BUILD_EXAMPLES=ON \
	      -DPYTHIA8_ROOT_DIR=${PYTHIADIR} \
	      -DROOT_DIR=${ROOTDIR}

	make -j $(n_cores)
	make install
}
