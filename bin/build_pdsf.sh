#!/bin/bash

cmake_version=3.9.1
boost_version=1.64.0
cgal_version=4.10
fastjet_version=3.3.0
fastjet_contrib_version=1.027
lhapdf_version=5.9.1
hepmc_version=2.06.09
root_version=v5-34-36
pythia8_version=8226
hepsoft_version=default

_this_source=$BASH_SOURCE

savedir=$PWD
#rm -rf build_hepsoft
mkdir -p ./build_hepsoft
cd ./build_hepsoft
# [ ! -f ./bt.sh ] && wget --no-check-certificate https://raw.github.com/matplo/buildtools/master/bt.sh && chmod +x ./bt.sh
if [[ ! -f ./bt/bt.sh ]]; then
	git clone git@github.com:matplo/buildtools.git bt
fi
# cp -v ~/devel/buildtools/bt.sh .
source ./bt/bt.sh

install_prefix=$HOME/software/hepsoft
if [ $(host_pdsf) ]; then
	install_prefix=/project/projectdirs/alice/ploskon/software/hepsoft
	add_prereq_modules gcc python git qt
fi

cd $savedir
_abspath=$(dirname $(abspath ${_this_source}))
#_this_dir_resolved=$(resolve_directory ${_abspath})
_this_dir_resolved=${_abspath}
cd ./build_hepsoft

[ $(is_opt_set --help) == "yes" ] && ./bt.sh --help && exit 0

echo "[i] $BASH_SOURCE directory: ${_this_dir_resolved}"

_packages=""
[ $(is_opt_set --all) == "yes" ] && _packages="cmake boost cgal fastjet fastjet_contrib root lhadpdf hepmc pythia8 hepsoft"
for _p in "$@"
do
	if [ ${_p:0:2} == "--" ]; then
		continue
	fi
	if [ "x${_packages}" == "x" ]; then
		_packages="${_p}"
	else
		_packages="${_packages} ${_p}"
	fi
done

_commands=""
for _cmnd in clean download build module cleanup debug
do
	if [ $(is_opt_set "--${_cmnd}") == "yes" ]; then
		if [ "x${_commands}" == "x" ]; then
			_commands="--${_cmnd}"
		else
			_commands="${_commands} --${_cmnd}"
		fi
	fi
done

echo "[i] recognized commands: ${_commands}"
echo "[i] packages: ${_packages}"

for _pack in ${_packages}
do
	install_sh_templ=${_this_dir_resolved}/../${_pack}/_install.sh
	# echo "[i] checking ${install_sh_templ}"
	if [ -f ${install_sh_templ} ]; then
		echo "[i] processing ${install_sh_templ}"
		install_sh=${PWD}/${_pack}_install.sh
		cp -v ${install_sh_templ} ${install_sh}
		sedi "s|<hepsoft>|${install_prefix}|g" ${install_sh}
		eval _ver=$(get_var_value ${_pack}_version)
		sedi "s|BT_version=.*|BT_version=${_ver}|g" ${install_sh}
		./bt/bt.sh BT_script=${install_sh} ${_commands}
		echo "[i] done with ${install_sh_templ}"
	else
		echo "[w] skipping ${_pack} - no: ${install_sh_templ}"
	fi
done

cd $savedir
