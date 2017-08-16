#!/bin/bash

savedir=$PWD
hepsoft_dir=<hepsoft>
source ${hepsoft_dir}/bin/tools.sh
process_variables $BASH_SOURCE $@
cd $wdir
echo_common_settings
process_modules
prep_build

function get_PDFsets()
{
	savedir=$PWD
	if [ ! -d ${install_dir} ]; then
		echo "[w] no install dir ${install_dir} - making one.."
		mkdir -pv ${install_dir}
	fi
    cd ${module_dir}
    local _local_file=${module_dir}/PDFsets.tar.gz
    if [ -e ${_local_file} ]; then
        echo "[i] ${_local_file} exists - will not download"
    else
        wget --no-check-certificate https://dl.dropboxusercontent.com/u/14190654/PDFsets/PDFsets.tar.gz
    fi
    pdfsetdir=${install_dir}/share/lhapdf
    mkdir -p $pdfsetdir
    cd $pdfsetdir
    tar zxvf ${_local_file}
    ls -ltr $pdfsetdir/PDFsets
    echo "[i] installing PDFsets done."
    cd $savedir
    echo $PWD
}

function build()
{
	get_PDFsets
    ./configure --prefix=${install_dir}
	[ ${do_clean} ] && make clean
	make -j $(n_cores)
	make install
	make -j $(n_cores)
	make install
}

exec_build
make_module

cd $savedir
