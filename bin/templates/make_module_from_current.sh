#!/bin/bash

source <hepsoft>/bin/tools.sh

function usage()
{
	echo "$BASH_SOURCE -d <targetdir> -n <name> -o <module outputdir>"
	exit 1
}

targetdir=
modfile_base=
outputdir=
version=default
has_pythonlib=

while getopts ":n:d:o:v:p:" opt; do
  case $opt in
    n)
      modfile_base=$OPTARG
      ;;
    d)
      targetdir=$OPTARG
      ;;
    o)
      outputdir=$OPTARG
      ;;
    v)
      version=$OPTARG
      ;;
    p)
      has_pythonlib=$OPTARG
      ;;
    \?)
      echo "[e] Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "[e] Option -$OPTARG requires an argument." >&2
      usage
      exit 1
      ;;
  esac
done

[ -z $targetdir ] && usage
[ -z $outputdir ] && usage
[ -z $modfile_base ] && usage

targetdir=`abspath $targetdir`
outputdir=`abspath $outputdir`
mkdir -p $outputdir/${modfile_base}
modfile=$outputdir/${modfile_base}/$version
echo "[i] modfile: "$modfile

rm -rf $modfile
touch $modfile

cat>>$modfile<<EOL
#%Module
proc ModulesHelp { } {
        global version
        puts stderr "   Setup <name> <version>"
    }

set     version <version>
setenv  <name>DIR <dir>
set-alias <name>_cd "cd <dir>"
EOL

echo 'setenv <name_to_upper>_ROOT <dir>' >> $modfile
echo 'setenv <name_to_upper>_DIR <dir>' >> $modfile
echo 'setenv <name_to_upper>DIR <dir>' >> $modfile

if [ -d $targetdir/lib ]; then
  cat >>$modfile<<EOL
prepend-path LD_LIBRARY_PATH <dir>/lib
prepend-path DYLD_LIBRARY_PATH <dir>/lib
EOL
fi

if [ -d $targetdir/lib64 ]; then
  cat >>$modfile<<EOL
prepend-path LD_LIBRARY_PATH <dir>/lib64
prepend-path DYLD_LIBRARY_PATH <dir>/lib64
EOL
fi

if [ ! -z ${has_pythonlib} ]; then
if [ -d $targetdir/lib64 ]; then
  cat >>$modfile<<EOL
prepend-path PYTHONPATH <dir>/lib64/${has_pythonlib}
EOL
fi
if [ -d $targetdir/lib ]; then
  cat >>$modfile<<EOL
prepend-path PYTHONPATH <dir>/lib/${has_pythonlib}
EOL
fi
fi

[ -d $targetdir/bin ] && echo "prepend-path PATH <dir>/bin" >> $modfile

sedi "s|<dir>|$targetdir|g" $modfile
sedi "s|<name_to_upper>|$(echo ${modfile_base} | awk '{print toupper($0)}')|g" $modfile
sedi "s|<name>|$modfile_base|g" $modfile
sedi "s|<version>|$version|g" $modfile

echo "if { [ module-info mode load ] } {" >> $modfile
mpaths=`module -t avail 2>&1 | grep : | sed "s|:||g"`
for mp in $mpaths
do
        echo "module use $mp" >> $modfile
done

#loaded=`module -t list 2>&1 | grep -v Current | grep -v $modfile | grep -v use.own`
loaded=`module -t list 2>&1 | grep -v Current | grep -v $modfile`
for m in $loaded
do
        #echo "prereq $m" >> $modfile
        echo "module load $m" >> $modfile
done
echo "}" >> $modfile
