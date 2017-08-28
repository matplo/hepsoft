#!/bin/bash

savedir=$PWD
#rm -rf build_hepsoft
mkdir -p ./build_hepsoft
cd ./build_hepsoft
# [ ! -f ./bt.sh ] && wget --no-check-certificate https://raw.github.com/matplo/buildtools/master/bt.sh && chmod +x ./bt.sh
rm -rf ./bt
git clone git@github.com:matplo/buildtools.git bt

cd $savedir
