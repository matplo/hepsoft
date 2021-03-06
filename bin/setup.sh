#!/bin/bash

function abspath()
{
  case "${1}" in
    [./]*)
    echo "$(cd ${1%/*}; pwd)/${1##*/}"
    ;;
    *)
    echo "${PWD}/${1}"
    ;;
  esac
}

savedir=$PWD

THISFILE=`abspath $BASH_SOURCE`
XDIR=`dirname $THISFILE`
if [ -L ${THISFILE} ];
then
    target=`readlink $THISFILE`
    XDIR=`dirname $target`
fi

THISDIR=$XDIR
[ ! -z $PATH ] && export PATH=$THISDIR:$PATH
[ -z $PATH ] && export PATH=$THISDIR

XDIR=`dirname $XDIR`

[ ! -z $1 ] && XDIR=$1

[ ! -d $XDIR ] && mkdir -p $XDIR

if [ -d $XDIR ]; then
    cd $XDIR
    echo "[i] setup in $PWD"
else
    echo "[error] $XDIR does not exist. stop here."
fi

# templates=`find $THISDIR/templates -name "make*.sh"`
# for TMPLATE in $templates
# do
#     cp $TMPLATE $THISDIR
#     XDIRr="${XDIR//\//\\/}"
#     FNAME=`basename $TMPLATE`
#     syst=$(uname -a | cut -f 1 -d " ")
#     if [ ${syst} = "Darwin" ]; then
#         sed -i '' "s|<dir to be set>|${XDIRr}|g" $THISDIR/$FNAME
#     else
#         sed -i "s|<dir to be set>|${XDIRr}|g" $THISDIR/$FNAME
#         sed -i 's|sed -i ""|sed -i |g' $THISDIR/$FNAME
#     fi
# done

source $THISDIR/tools.sh
HEPSOFTDIR=$(dirname ${THISDIR})
echo $THISDIR
echo "[i] finding templates..."
# templates=$(find ${HEPSOFTDIR} -maxdepth 2 -name "_install.sh")
config_ordered_modules=$(cat ${HEPSOFTDIR}/config/versions.cfg | cut -f 1 -d "=" | grep .)
echo $config_ordered_modules
echo "[i] processing..."
#for t in $templates
for t in $config_ordered_modules
do
    [ ! -f ${HEPSOFTDIR}/${t}/_install.sh ] && continue
    #new_file=$(dirname $t)/install.sh
    new_file="${HEPSOFTDIR}/${t}/install.sh"
    #sed "/<hepsoft>/c\${HEPSOFTDIR}" $t > $new_file
    sed "s|<hepsoft>|${HEPSOFTDIR}|g" "${HEPSOFTDIR}/${t}/_install.sh" > ${new_file}
    chmod +x ${new_file}
    echo "    -> ${new_file} created."
done
mmscript=${HEPSOFTDIR}/bin/templates/make_module_from_current.sh
new_file=${HEPSOFTDIR}/bin/make_module_from_current.sh
sed "s|<hepsoft>|${HEPSOFTDIR}|g" $mmscript > $new_file
chmod +x $new_file
echo "    -> $new_file created."

mmscript=${HEPSOFTDIR}/bin/make_modules.sh
rm -f $mmscript
for mod in $config_ordered_modules
do
    [ ! -f ${HEPSOFTDIR}/${mod}/_install.sh ] && continue
    echo "${HEPSOFTDIR}/${mod}/install.sh --module" >> ${mmscript}
done
chmod +x ${mmscript}
echo "    -> ${mmscript} created."

mmscript=${HEPSOFTDIR}/bin/install_all.sh
rm -f $mmscript
for mod in $config_ordered_modules
do
    [ ! -f ${HEPSOFTDIR}/${mod}/_install.sh ] && continue
    echo "${HEPSOFTDIR}/${mod}/install.sh --all" >> ${mmscript}
done
chmod +x ${mmscript}
echo "    -> ${mmscript} created."

mmscript=${HEPSOFTDIR}/bin/cleanup.sh
rm -f $mmscript
#for mod in $config_ordered_modules
#do
#    [ ! -f ${HEPSOFTDIR}/${mod}/_install.sh ] && continue
#    echo "${HEPSOFTDIR}/${mod}/install.sh --clean" >> ${mmscript}
#done
echo "rm -rfv ${HEPSOFTDIR}/downloads" >> ${mmscript}
echo "rm -rfv ${HEPSOFTDIR}/srcs" >> ${mmscript}
echo "rm -rfv ${HEPSOFTDIR}/builds" >> ${mmscript}
chmod +x ${mmscript}
echo "    -> ${mmscript} created."

echo "[i] done."

echo "[i] HEPSOFTDIR: ${HEPSOFTDIR}"
[ ! -d "${HEPSOFTDIR}/modules" ] && mkdir -pv ${HEPSOFTDIR}/modules

cd $savedir
