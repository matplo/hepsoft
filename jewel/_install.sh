#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules lhapdf
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

BT_name=jewel
BT_version=2.2.0
BT_remote_file=http://www.hepforge.org/archive/jewel/jewel-${BT_version}.tar.gz

function build()
{
	cd ${BT_src_dir}
	echo_warning $PWD
	sedi 's|/home/lhapdf/install/lib|$(LHAPDF_DIR)/lib|g' Makefile
	make -j $(n_cores)

	if [ -e jewel-${BT_version}-vac ]; then
		echo_warning "creating ${BT_install_dir}/bin"
		mkdir -p ${BT_install_dir}/bin
		cp -v jewel-${BT_version}-vac ${BT_install_dir}/bin
	else
		echo_error "target of buid not found jewel-${BT_version}-vac"
	fi
	if [ -e jewel-${BT_version}-simple ]; then
		echo_warning "creating ${BT_install_dir}/bin"
		mkdir -p ${BT_install_dir}/bin
		cp -v jewel-${BT_version}-simple ${BT_install_dir}/bin
		echo_warning "copying .dat files to ${BT_install_dir}/config"
		mkdir -pv ${BT_install_dir}/config
		cp -v *.dat ${BT_install_dir}/config
	else
		echo_error "target of buid not found jewel-${BT_version}-vac"
	fi
}
