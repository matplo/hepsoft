#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
# add_prereq_modules cmake boost cgal fastjet hepmc YODA root
add_prereq_modules cmake fj hepmc YODA root

BT_name=rivet
BT_version=2.6.0
BT_remote_file=http://www.hepforge.org/archive/rivet/Rivet-${BT_version}.tar.gz
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

function build()
{
	cd ${BT_src_dir}
	#boost_libs=$(ls ${BOOST_DIR}/lib | grep ".so" | xargs -d "." -n 1 | grep lib | sed 's:lib:-l:')

	# export LIBS=$(fastjet-config --libs)
	# export CXX_LDFLAGS="-rpath /usr/lib/x86_64-linux-gnu -lgmp"
	# export CXX_FLAGS="${CXX_FLAGS} -fPIC"
	# export CPP_FLAGS="${CPP_FLAGS} -fPIC"
	# export LDFLAGS="${LDFLAGS}"
	# echo_warning $(cat configure | grep AM_CPPFLAGS)
	# sedi 's:AM_CPPFLAGS="-I:AM_CPPFLAGS="-fPIC -I:g' configure
	# echo_warning $(cat configure | grep AM_CPPFLAGS)
	# ./configure --verbose --prefix=${BT_install_dir} --with-yoda=${YODA_DIR} --with-fastjet=${FASTJET_DIR} --with-hepmc=${HEPMC_DIR}
	#--with-root=${ROOT_DIR}

	./configure --verbose --prefix=${BT_install_dir} --with-yoda=${YODA_DIR} --with-hepmc=${HEPMC_DIR} --with-fastjet=${FJ_DIR}

	# separator "sed(ative) to Makefile in $PWD"
	# sedi 's:FASTJETLDFLAGS\s=.*:FASTJETLDFLAGS\ = \${FASTJETCONFIGLIBADD}:g' Makefile
	# sedi 's:FASTJETLDLIBS\s=.*:FASTJETLDLIBS=:g' Makefile
	# echo_warning $(cat Makefile | grep FASTJETLD)

	# cd ${BT_src_dir}/bin
	# separator "sed(ative) to Makefile in $PWD"
	# sedi 's:FASTJETLDFLAGS\s=.*:FASTJETLDFLAGS\ = \${FASTJETCONFIGLIBADD}:g' Makefile
	# sedi 's:FASTJETLDLIBS\s=.*:FASTJETLDLIBS=:g' Makefile
	# sedi 's:rivet_nopy_LDADD\s=:rivet_nopy_LDADD = -lgmp:g' Makefile

	# export extra_LIBS=$(fastjet-config --libs)
	# export extra_LIBS="-L/usr/lib/x86_64-linux-gnu -lgmp"
	# sedi "s:rivet_nopy_LDADD\s=:rivet_nopy_LDADD = ${extra_LIBS}:g" Makefile
	# sedi "s:\$(rivet_nopy_LDADD)\s\$(LIBS):\$(rivet_nopy_LDADD) \$(LIBS) ${extra_LIBS}:g" Makefile
	# sedi "s:rivet_nopy_LDFLAGS\s=:rivet_nopy_LDFLAGS = ${extra_LIBS}:g" Makefile
	# echo_warning $(cat Makefile | grep rivet_nopy_LDFLAGS)

	# cd ${BT_src_dir}/bin
	# separator "sed(ative) to Makefile.am in $PWD"
	# cat Makefile.am | grep CPPFLAGS
	# sedi "s:rivet_nopy_CPPFLAGS\s=\s-I\$(top_srcdir)/include\s\$(AM_CPPFLAGS):rivet_nopy_CPPFLAGS = -I\$(top_srcdir)/include \$(AM_CPPFLAGS) -fPIC:g" Makefile.am
	# cat Makefile.am | grep CPPFLAGS

	# echo_warning "before:"
	# cat Makefile.am | grep LDFLAGS
	# sedi "s:rivet_nopy_LDFLAGS\s=\s-L\$(HEPMCLIBPATH):rivet_nopy_LDFLAGS = -shared -L\$(HEPMCLIBPATH):g" Makefile.am
	# echo_warning "after:"
	# cat Makefile.am | grep LDFLAGS

	cd ${BT_src_dir}
	make -j $(n_cores) && make install
}
