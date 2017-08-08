#!/bin/bash

XDIR="<dir to be set>"

if [ ! -d "$XDIR" ]; then
	echo "[error] $XDIR does not exist."
else
	for script in "install*.sh" "cleanup.sh" "setenv_*.sh clean_bin.sh make_module_from_current.sh"
	do
		rm -rfv $XDIR/bin/$script
	done
fi
