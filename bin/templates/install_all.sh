#!/bin/bash

XDIR="<dir to be set>"
mkdir -p $XDIR/logs

ropts=""
syst=`uname -n`
if [ ${syst:0:4} == "pdsf" ]; then
	ropts="-o -Dxrootd=OFF -o -Dldap=OFF"
fi

rversion="v5-34-34"
$XDIR/bin/install_root_w_cmake.sh -g -d $XDIR $ropts -v $rversion
$XDIR/bin/install_root_w_cmake.sh -cn -d $XDIR $ropts -v $rversion
$XDIR/bin/install_root_w_cmake.sh -b -d $XDIR $ropts -v $rversion
$XDIR/bin/install_root_w_cmake.sh -i -d $XDIR $ropts -v $rversion
. $XDIR/root/$rversion/bin/thisroot.sh

if [ ${`uname -n`:0:4} == "pdsf" ]; then
	echo "[i] no add rpath on pdsf"
else
	$XDIR/bin/addrpath.sh
fi

$XDIR/bin/install_hepmc.sh 		2>&1 | tee $XDIR/logs/install_hepmc.log
$XDIR/bin/install_lhapdf.sh 	2>&1 | tee $XDIR/logs/install_lhapdf.log
$XDIR/bin/install_fastjet.sh	2>&1 | tee $XDIR/logs/install_fastjet.log

. $XDIR/scripts/setenv_fastjet_3.2.1.sh
. $XDIR/scripts/setenv_hepmc_2.06.09.sh
. $XDIR/scripts/setenv_lhapdf_5.9.1.sh

$XDIR/bin/install_pythia8.sh 8215 2>&1 | tee $XDIR/logs/install_pythia8.log
