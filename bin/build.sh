#!/bin/bash

cmake_version=3.9.1

install_prefix=$HOME/software/hepsoft

savedir=$PWD
#rm -rf build_hepsoft
mkdir -p build_hepsoft
cd build_hepsoft

# [ ! -f ./bt.sh ] && wget https://raw.github.com/matplo/buildtools/master/bt.sh && chmod +x ./bt.sh
cp -v ~/devel/buildtools/bt.sh .
source ./bt.sh

[ $(is_opt_set --help) == "yes" ] && ./bt.sh --help && exit 0

for arg in $@
do
	install_sh_templ=$(file_dir $BASH_SOURCE)/../${arg}/_install.sh
	# echo "[i] checking ${install_sh_templ}"
	if [ -f ${install_sh_templ} ]; then
		echo "[i] processing ${install_sh_templ}"
		install_sh=${PWD}/${arg}_install.sh
		cp -v ${install_sh_templ} ${install_sh}
		sedi "s|<hepsoft>|${install_prefix}|g" ${install_sh}
		./bt.sh BT_script=${install_sh} "$@"
		echo "[i] done with ${install_sh_templ}"
	else
		# echo "[w] skipping ${arg}"
		true
	fi
done

cd $savedir