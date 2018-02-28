#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules cmake root hepmc lhapdf boost cgal fastjet pythia
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

BT_name=herwig
BT_version=7
#technically not true but...
BT_remote_file="installing_from_git"

function setup_src_dir()
{
	# fake the structure
	separator "do nothing for setup src dir"
	echo_info ${BT_sources_dir}
	echo_info ${BT_src_dir}

	BT_src_dir=${BT_sources_dir}
	# mkdir -p ${BT_src_dir}
	# BT_sources_dir=${BT_working_dir}/herwig_src_tmp
	mkdir -p ${BT_sources_dir}
}

function build()
{
	[ ! -f herwig-bootstrap ] && wget https://herwig.hepforge.org/herwig-bootstrap
	chmod +x herwig-bootstrap
	mkdir -p $(dirname ${BT_install_dir})
	./herwig-bootstrap -j 4 ${BT_install_dir} --with-boost=${BOOST_DIR} --with-lhapdf=${LHAPDF_DIR} --with-pythia=${PYTHIA8_DIR} --with-fastjet=${FASTJET_DIR} --with-hepmc=${HEPMC_DIR}
}
