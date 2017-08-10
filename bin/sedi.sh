#!/bin/bash

system_name=`uname -a | cut -f 1 -d " "`

if [ ${system_name} == "Darwin" ]; then
	sed -i " " $@
else
	sed -i'' $@
fi
