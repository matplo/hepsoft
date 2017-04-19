#!/bin/bash

savedir=$PWD

XDIR="<dir to be set>"
working_dir="$XDIR/hydjet"
mkdir -p $working_dir

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

function exec_configure()
{
    rsys=`root-config --prefix`
    rsysinc=`root-config --incdir`
    rsyslib=`root-config --libdir`
    ./configure --prefix=$install_dir \
        --enable-shared \
        --with-root=$rsys \
        --with-root-lib=$rsyslib \
        --with-root-include=$rsysinc \
        --with-hepmc2=$HEPMCDIR \
        --with-fastjet3=$fjpath
}

function write_setup_script()
{
    fname=setenv_hydjet_$2.sh
    outdir=$1/bin
    #outfile=$outdir/$fname
    mkdir -p $XDIR/scripts
    outfile=$XDIR/scripts/$fname
    rm -rf $outfile

    cat>>$outfile<<EOF
#!/bin/bash

export HYDJETDIR=$1
export HYDJET_VERSION=$2
export DYLD_LIBRARY_PATH=\$HYDJETDIR/lib:\$DYLD_LIBRARY_PATH
export LD_LIBRARY_PATH=\$HYDJETDIR/lib:\$LD_LIBRARY_PATH
export PATH=\$HYDJETDIR/bin:\$PATH
EOF
}

function write_module_file()
{
    version=$2
    outfile=$XDIR/modules/hydjet/$version
    outdir=`dirname $outfile`
    mkdir -p $outdir
    rm -rf $outfile

    cat>>$outfile<<EOF
#%Module
proc ModulesHelp { } {
        global version
        puts stderr "   Setup hydjet \$version"
    }

set     version $version
setenv  HYDJETDIR $1
setenv  HYDJET_VERSION $2
prepend-path PATH $1

EOF
}

if [ ! -d "$working_dir" ]; then
    echo "[error] $working_dir does not exist."
else
    version=$1
    [ -z $version ] && version=2_3
    install_dir="$working_dir/$version"

    cd $working_dir
    echo $PWD
    echo "[i] will install to: $install_dir"
    echo "[i] install for PYTHIA version $version"

	fdfile="HYDJET++$version.ZIP"
    srcdir="hydjet$version"
    echo "[i] file to download: $fdfile"
    echo "[i] source sub dir: $srcdir"
    if [ -e "./downloads/$fdfile" ]; then
        echo "[i] $fdfile exists - will not download"
    else
        mkdir -p ./downloads
        cd ./downloads
		wget http://lokhtin.web.cern.ch/lokhtin/hydjet++/$fdfile
        cd -
    fi
    pwd
    mkdir -p $install_dir
    cd $install_dir
    unzip $working_dir/downloads/$fdfile

    # exec_configure $install_dir
    sed "s/-print-file-name=libgfortran.so/-print-file-name=-lgfortran/g" -i Makefile | tee Makefile

    [ "$2" = "clean" ] && make clean
    make
    # && make install

    # chmod +x $install_dir/bin/hydjet8-config

    write_setup_script $install_dir $version
    write_module_file $install_dir $version
fi
cd $savedir
