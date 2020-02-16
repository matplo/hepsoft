#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
#add_prereq_modules cmake root hepmc lhapdf boost cgal fastjet pythia8
add_prereq_modules root hepmc LHAPDF boost cgal fastjet pythia8
echo_padded_BT_var modules
BT_module_dir=${BT_install_prefix}/modules/${BT_name}
BT_name=hepsoft
BT_version=default
BT_install_dir=${BT_install_prefix}
BT_src_dir="$PWD"
#cumulative load
BT_do_preload_modules="no"

function download()
{
	separator "download"
	note "nothing to download"
}

function build()
{
	separator "build"
	note "nothing to build"
}
