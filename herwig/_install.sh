#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
# add_prereq_modules cmake root hepmc lhapdf boost cgal fastjet pythia8 YODA
# add_prereq_modules cmake root hepmc lhapdf fj pythia8 YODA rivet
add_prereq_modules cmake boost hepmc YODA
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

function remind()
{
echo_warning "THE HERWIG installation NEEDS SUBVERSION for openloops installation..."
echo_warning "info next is about PDF sets..."
cat << EOF
****************************************************************
IMPORTANT INFORMATION ABOUT PDF SETS

LHAPDF no longer bundles PDF set data in the package tarball.
The sets are instead all stored online at
  http://www.hepforge.org/archive/lhapdf/pdfsets/6.2/
and you should install those that you wish to use into
  /home/ploskon/software/hepsoft/herwig/7.x/share/LHAPDF

The downloadable PDF sets are packaged as tarballs, which
must be expanded to be used. Here is an example of how to
retrieve and install a PDF set from the command line:

 wget http://www.hepforge.org/archive/lhapdf/pdfsets/6.2/CT10nlo.tar.gz -O- | tar xz -C /home/ploskon/software/hepsoft/herwig/7.x/share/LHAPDF

****************************************************************
EOF
}

function build()
{
	[ ! -f herwig-bootstrap ] && wget https://herwig.hepforge.org/herwig-bootstrap
	chmod +x herwig-bootstrap
	mkdir -p $(dirname ${BT_install_dir})
	# ./herwig-bootstrap -j 4 ${BT_install_dir} --with-boost=${BOOST_DIR} --with-lhapdf=${LHAPDF_DIR} --with-pythia=${PYTHIA8_DIR} --with-fastjet=${FJ_DIR} --with-hepmc=${HEPMC_DIR} --with-yoda=${YODA_DIR} --with-rivet=${RIVET_DIR}
	# ./herwig-bootstrap -j 4 ${BT_install_dir} --with-boost=${BOOST_DIR} --with-pythia=${PYTHIA8_DIR} --with-fastjet=${FJ_DIR} --with-hepmc=${HEPMC_DIR} --with-yoda=${YODA_DIR} --with-rivet=${RIVET_DIR}
	./herwig-bootstrap -j 4 ${BT_install_dir} --with-boost=${BOOST_DIR} --with-hepmc=${HEPMC_DIR} --with-yoda=${YODA_DIR}
	remind
}
