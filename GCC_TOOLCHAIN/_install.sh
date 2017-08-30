#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules binutils/2.25.1 gcc/4.9.3
echo_padded_BT_var modules
BT_module_dir=${BT_install_prefix}/modules/${BT_name}
BT_name=GCC_TOOLCHAIN
BT_version=GCC-v4.9.3
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
