#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules cmake
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

BT_name=LHAPDF
BT_version=6.2.3
BT_fname="${BT_NAME}-${BT_version}"
BT_remote_file=https://lhapdf.hepforge.org/downloads/?f=${BT_fname}.tar.gz -O ${BT_fname}.tar.gz
python_version=$(python3 --version | cut -f 2 -d' ' | cut -f 1-2 -d.)
BT_pythonlib=python${python_version}/site-packages

function build()
{
    cd ${BT_src_dir}
    ./configure --prefix=${BT_install_dir}
    make -j $(n_cores) && make install
}
