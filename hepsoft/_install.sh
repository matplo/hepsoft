#!/bin/bash

BT_install_prefix=<hepsoft>
BT_module_paths=${BT_install_prefix}/modules
BT_modules="cmake root hepmc lhapdf boost cgal fastjet pythia8"
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

BT_name=hepsoft
BT_version=default
BT_install_dir=${BT_install_prefix}
BT_src_dir="$PWD"
#cumulative load
BT_do_preload_modules="yes"

function download()
{
	separator "nothing to download"
}

function build()
{
	separator "nothing to build"
}
