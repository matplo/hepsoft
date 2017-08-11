#!/bin/bash

#source /project/projectdirs/alice/ploskon/software/hepsoft/bin/tools.sh
hepsoft_dir=<hepsoft>
wdir=${hepsoft_dir}
savedir=$PWD
cd $wdir
source ${hepsoft_dir}/bin/tools.sh
pdsf_modules="gcc python cmake/$(config_value cmake)"
module_name=$(module_name $BASH_SOURCE)
clean=$(is_opt_set --clean)
do_build=$(is_opt_set --build)
do_make_module=$(is_opt_set --module)
do_download=$(is_opt_set --download)

[ $(is_opt_set --all) ] && clean="yes" && do_build="yes" && do_make_module="yes" && do_download="yes"

version=$(get_opt_with --version)
[ -z $version ] && version=$(config_value boost)
_version=$(echo $version | sed 's|\.|_|g')
unpack_dir=$wdir/${module_name}_${_version}
install_dir=${hepsoft_dir}/${module_name}/${version}
eval http_dir=$(config_value boost_http_dir)
echo "[i] http_dir is: $http_dir"
remote_file=${http_dir}/boost_${_version}.tar.gz
#remote_file=https://dl.bintray.com/boostorg/release/${version}/source/boost_${_version}.tar.gz
local_file=`basename $remote_file`

echo "[i] pdsf_modules: " $pdsf_modules
echo "[i] module_name : " $module_name
echo "[i] version     : " $version
echo "[i] local_file  : " $local_file

module use ${hepsoft_dir}/modules
if [ $(host_pdsf) ]; then
	module load ${pdsf_modules}
	[ $? ] && exit 1
else
	# module load cmake/3.9.0
	echo "[i] no extra modules loaded"
fi
module list

if [ $do_download ]; then
	cd ${module_dir}
	rm -rf ${local_file}
	wget $remote_file --no-check-certificate -O $local_file
	cd $wdir
fi

if [ $clean ]; then
	echo "[i] cleaning ${unpack_dir}..."
	rm -rf ${unpack_dir}
	echo "[i] done cleaning."
fi

if [ ${do_build} ]; then
	[ ! -e $local_file ] && echo "[e] file $local_file does not exist" && exit 1
	echo "[i] unpacking..."
	tar zxvf $local_file 2>&1 > /dev/null
	[ ! -d ${unpack_dir} ] && echo "[e] dir ${unpack_dir} does not exist" && exit 1
	cd ${unpack_dir}
	time ./bootstrap.sh --prefix=${install_dir}
	time ./b2 install
fi

echo "[i] install_dir: ${install_dir}"

[ $do_make_module ] && ${hepsoft_dir}/bin/make_module_from_current.sh -d ${install_dir} -n ${module_name} -v $version -o ${hepsoft_dir}/modules

cd $savedir
