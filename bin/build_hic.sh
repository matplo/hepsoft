#!/bin/bash

# cmake_version=3.9.1
cmake_version=3.15.1
boost_version=1.68.0
cgal_version=4.14
fastjet_version=3.3.2
fastjet_contrib_version=1.041
fj_version=3.3.2
fj_contrib_version=1.041
lhapdf_version=5.9.1
lhapdf_version=6.2.3
hepmc_version=2.06.09
hepmc3_version=3.0.0
root5_version=v5-34-36
#root6_version=v6-12-04
root6_version=v6-18-00
root_version=${root6_version}
pythia8_version=8235
hepsoft_version=r6
envmodules_version=3.2.10
jewel_version=2.2.0
mcorrelations_version=0.9
YODA_version=1.7.0
rivet_version=2.6.0
#rivet_version=3.0.0alpha1
herwig_version=7.x
gcc_version=7.4.0

install_prefix=/home/software/hepsoft
_this_source=$BASH_SOURCE

savedir=$PWD
#rm -rf build_hepsoft
mkdir -p ./build_hepsoft
cd ./build_hepsoft
# [ ! -f ./bt.sh ] && wget --no-check-certificate https://raw.github.com/matplo/buildtools/master/bt.sh && chmod +x ./bt.sh
if [[ ! -f ./bt.sh ]]; then
	git clone git@github.com:matplo/buildtools.git bt
	ln -s ./bt/bt.sh .
fi
# cp -v ~/devel/buildtools/bt.sh .
source ./bt.sh

function python()
{
	python3 $@
}
export -f python
python -V

if [ $(os_darwin) ]; then
	warning "system is darwin"
else
	if [ $(os_linux) ]; then
		warning "system is linux"
	else
		warning "system is unknown?"
	fi
fi

cd $savedir
_abspath=$(dirname $(abspath ${_this_source}))
_this_dir_resolved=$(resolve_directory ${_abspath})
cd ./build_hepsoft

[ $(is_opt_set --help) == "yes" ] && ./bt.sh --help && exit 0

echo "[i] $BASH_SOURCE directory: ${_this_dir_resolved}"

_packages=""
if [ $(os_darwin) ]; then
	export BOOST_DIR=/usr/local
	export CGAL_DIR=/usr/local
	[ $(is_opt_set --all) == "yes" ] && _packages="fastjet fastjet_contrib root lhapdf hepmc pythia8 hepsoft"
else
	[ $(is_opt_set --all) == "yes" ] && _packages="gcc cmake boost cgal fastjet fastjet_contrib root lhapdf hepmc pythia8 hepsoft"
fi
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
for _cmnd in clean download build module cleanup
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
		./bt.sh BT_script=${install_sh} ${_commands}
		echo "[i] done with ${install_sh_templ}"
	else
		echo "[w] skipping ${_pack} - no: ${install_sh_templ}"
	fi
done

cd $savedir
