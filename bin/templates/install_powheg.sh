#!/bin/bash

savedir=$PWD

PKGNAME=POWHEG
#manual at http://th-www.if.uj.edu.pl/~erichter/POWHEG-BOX-V2/Docs/manual-BOX.pdf

XDIR="<dir to be set>"
working_dir="$XDIR/${PKGNAME}"
mkdir -p $working_dir

function write_setup_script()
{
    fname=setenv_${PKGNAME}_$2.sh
    outdir=$1/bin
    #outfile=$outdir/$fname
    mkdir -p $XDIR/scripts 
    outfile=$XDIR/scripts/$fname
    rm -rf $outfile

    cat>>$outfile<<EOF
#!/bin/bash

export ${PKGNAME}DIR=$1
export ${PKGNAME}_VERSION=$2    
export DYLD_LIBRARY_PATH=\$${PKGNAME}DIR/lib:\$DYLD_LIBRARY_PATH
export LD_LIBRARY_PATH=\$${PKGNAME}DIR/lib:\$LD_LIBRARY_PATH
export PATH=\$${PKGNAME}DIR/bin:\$PATH
EOF
}

function write_module_file()
{
    version=$2
    outfile=$XDIR/modules/${PKGNAME}/$version
    outdir=`dirname $outfile`
    mkdir -p $outdir
    rm -rf $outfile

    cat>>$outfile<<EOF
#%Module
proc ModulesHelp { } {
        global version
        puts stderr "   Setup ${PKGNAME} \$version"
    }

set     version $version
setenv  ${PKGNAME}DIR $1
setenv  ${PKGNAME}_VERSION $2    
prepend-path LD_LIBRARY_PATH $1/lib
prepend-path DYLD_LIBRARY_PATH $1/lib
prepend-path PATH $1/bin

EOF
}

if [ ! -d "$working_dir" ]; then
    echo "[error] $working_dir does not exist."
else
    version=$1
    [ -z $version ] && version=trunk
    install_dir="$working_dir/$version"

    cd $working_dir
    echo $PWD
    echo "[i] will install to: $install_dir"    
    echo "[i] installing ${PKGNAME} $version"

    fdfile="${PKGNAME}-$version.tar.gz"
    srcdir="${PKGNAME}-$version"
    echo "[i] file to download: $fdfile"
    echo "[i] source sub dir: $srcdir"
    if [ -e "./downloads/$fdfile" ]; then
        echo "[i] $fdfile exists - will not download"
    else
        mkdir -p ./downloads
        cd ./downloads
        wget http://${PKGNAME}.fr/repo/$fdfile
        cd -
    fi
    tar zxvf ./downloads/$fdfile
    cd $srcdir

    [ "$2" = "clean" ] && make clean    

    exec_configure $install_dir

    make && make install

    write_setup_script $install_dir $version
    write_module_file $install_dir $version

fi

cd $savedir
