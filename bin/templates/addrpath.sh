#!/bin/bash

plib=$1
[ -z $plib ] && plib=`root-config --libdir`
plib=`root-config --libdir`

if [ -d $plib ]; then
   for i in $plib/lib*.so $plib/lib*.dylib ; do
           if [ -e $i ]; then
                   echo $i
                   install_name_tool -add_rpath $plib $i
           fi
	done
fi
