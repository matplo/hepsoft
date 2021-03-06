#!/bin/bash

BT_install_prefix=<hepsoft>
add_prereq_module_paths "${BT_install_prefix}/modules"
add_prereq_modules cmake
BT_module_dir=${BT_install_prefix}/modules/${BT_name}

BT_name=lhapdf
BT_version=5.9.1
BT_remote_file=http://www.hepforge.org/archive/lhapdf/lhapdf-5.9.1.tar.gz
BT_pythonlib=python2.7/site-packages

function get_PDFsets()
{
	savedir=$PWD
    check_install_paths
    check_download_paths
    cd ${BT_download_dir}
    local _local_file=${BT_download_dir}/PDFsets.tar.gz
    if [ -e ${_local_file} ]; then
        echo "[i] ${_local_file} exists - will not download"
    else
        # wget --no-check-certificate https://dl.dropboxusercontent.com/u/14190654/PDFsets/PDFsets.tar.gz
        wget --no-check-certificate http://portal.nersc.gov/project/alice/ploskon/static/static_extra/PDFsets/PDFsets.tar.gz
    fi
    pdfsetdir=${BT_install_dir}/share/lhapdf
    mkdir -p $pdfsetdir
    cd $pdfsetdir
    tar zxvf ${_local_file}
    ls -ltr $pdfsetdir/PDFsets
    echo "[i] installing PDFsets done."
    cd $savedir
}

function build()
{
    cd ${BT_src_dir}
    ./configure --prefix=${BT_install_dir}
    echo_warning patching pyext/lhapdf_wrap.cc
    sedi "s/PyExc_RuntimeError,[[:blank:]]mesg/PyExc_RuntimeError,\"%s\",mesg/g" ./pyext/lhapdf_wrap.cc
    make -j $(n_cores)
    make install
    get_PDFsets
}
