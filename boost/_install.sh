#!/bin/bash

BT_install_prefix=<hepsoft>
BT_module_paths=${BT_install_prefix}/modules
# BT_modules=cmake/3.9.1
BT_modules=cmake

BT_name=boost
BT_version=1.64.0
BT_version__=$(echo ${BT_version} | sed "s|\.|_|g")
BT_remote_file=https://dl.bintray.com/boostorg/release/${BT_version}/source/boost_${BT_version__}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	cd ${BT_src_dir}
	time ${BT_src_dir}/bootstrap.sh --prefix=${BT_install_dir}
	time ${BT_src_dir}/b2 install
}
