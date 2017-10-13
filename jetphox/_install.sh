#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules root lhapdf cernlib/2005p
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

BT_name=jetphox
# BT_remote_file=https://lapth.cnrs.fr/PHOX_FAMILY/src/jetphox_root_1.3.1_1.tar.gz
# BT_version=1.3.1_1

BT_version=1.3.1_3
BT_remote_file=https://lapth.cnrs.fr/PHOX_FAMILY/src/jetphox_1.3.1_3.tar.gz

function build()
{
	# cd ${BT_src_dir}
	# cd basesv5.1
	# echo_warning $PWD
	# make -f Makefile_gfortran.linux
	# cd ${BT_src_dir}
	# cd frag
	# echo_warning $PWD
	# make FC=gfortran
	# cd ${BT_src_dir}
	# cd pdfa
	# echo_warning $PWD
	# make FC=gfortran
	# cd ${BT_src_dir}
	# cd working
	# echo_warning $PWD
	# sedi "s|/usr/bin/root-config|root-config|g" Makefile
	# sedi 's|$(PATHLHAPDF)/lib/libLHAPDF.so|${LHAPDFDIR}/lib/libLHAPDF.so|g' Makefile
	# sedi 's|$(PATHCERNLIB)/cernlib|cernlib|g' Makefile
	# sed -i '/#LIBS          =/ s/.*/#patched/' Makefile
	# sed -i '/LIBS          =/ s/.*/LIBS          = $(ROOTLIBS)/' Makefile
	# # sedi '/-L\/usr\/lib64\/root/c\LIBS\ =\ $(ROOTLIBS)' Makefile
	# make

	cd ${BT_src_dir}
	cd working
	echo_warning $PWD
	echo_warning "Now calling the perl script"
	# sedi "s|/usr/bin/root-config|root-config|g" Makefile - this is for 1.3.1_1
	sedi "s|/LINUX/LAPPSL5/64bits/Root/pro/bin/root-config|root-config|g" Makefile
	sedi 's|$(PATHLHAPDF)/lib/libLHAPDF.so|${LHAPDFDIR}/lib/libLHAPDF.so|g' Makefile
	#sed -i '/#LIBS          =/ s/.*/#patched/' Makefile
	#sed -i '/LIBS          =/ s/.*/LIBS          = $(ROOTLIBS)/' Makefile
	#sedi 's|$(PATHCERNLIB)/cernlib|cernlib|g' Makefile
	sedi 's|/usr/lib/gcc/x86_64-redhat-linux/4.4.4|/usr/common/usg/software/gcc/4.8.1/lib64|g' Makefile
	perl start.pl
}
