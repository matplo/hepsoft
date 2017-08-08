#!/bin/bash

savedir=$PWD

XDIR="<dir to be set>"
working_dir="$XDIR/fastjet"
mkdir -p $working_dir

function find_cgal()
{
    local ext="so"
    local syst=`uname -n`
    [ ${syst} = "Darwin" ] && ext="dylib"
    local libpath=$1
    local result=$2
    local cgaldir=""
    # too wild..? - ok for macports /usr/lib
    IFS=:
    for p in ${libpath}; do
    	echo " - checking for libCGAL.${ext} in ${p}"
    	local libcgal="${p}/libCGAL.${ext}"
    	if [ -e "${libcgal}" ]; then
            echo "[i] found CGAL: ${libcgal}"
            cgaldir=`dirname ${p}`
            break
    	fi
    done
    if [[ "$result" ]]; then
    	eval $result=$cgaldir
    else
        echo $cgaldir
    fi
}

function exec_configure()
{
    cgaldep=""
    find_cgal "${LD_LIBRARY_PATH}:${DYLD_LIBRARY_PATH}:/opt/local/lib:/usr/lib:/usr/local/lib" cgaldir
    if [ -z $cgaldir ]; then
    	./configure --prefix=$1
    else
	   ./configure --prefix=$1 --enable-cgal --with-cgaldir=$cgaldir
    fi
}

function write_setup_script()
{
    fname=setenv_fastjet_$2.sh
    outdir=$1/bin
    #outfile=$outdir/$fname
    mkdir -p $XDIR/scripts
    outfile=$XDIR/scripts/$fname
    rm -rf $outfile

    cat>>$outfile<<EOF
#!/bin/bash

export FASTJETDIR=$1
export FASTJET_VERSION=$2
export DYLD_LIBRARY_PATH=\$FASTJETDIR/lib:\$DYLD_LIBRARY_PATH
export LD_LIBRARY_PATH=\$FASTJETDIR/lib:\$LD_LIBRARY_PATH
export PATH=\$FASTJETDIR/bin:\$PATH
EOF
}

function write_module_file()
{
    version=$2
    outfile=$XDIR/modules/fastjet/$version
    outdir=`dirname $outfile`
    mkdir -p $outdir
    rm -rf $outfile

    cat>>$outfile<<EOF
#%Module
proc ModulesHelp { } {
        global version
        puts stderr "   Setup fastjet \$version"
    }

set     version $version
setenv  FASTJETDIR $1
setenv  FASTJET_VERSION $2
prepend-path LD_LIBRARY_PATH $1/lib
prepend-path DYLD_LIBRARY_PATH $1/lib
prepend-path PATH $1/bin

EOF
}

if [ ! -d "$working_dir" ]; then
    echo "[error] $working_dir does not exist."
else
    version=$1
    #[ -z $version ] && version=3.1.2
    [ -z $version ] && version=3.2.2
    install_dir="$working_dir/$version"

    cd $working_dir
    echo $PWD
    echo "[i] will install to: $install_dir"
    echo "[i] installing fastjet $version"

    fdfile="fastjet-$version.tar.gz"
    srcdir="fastjet-$version"
    echo "[i] file to download: $fdfile"
    echo "[i] source sub dir: $srcdir"
    if [ -e "./downloads/$fdfile" ]; then
        echo "[i] $fdfile exists - will not download"
    else
        mkdir -p ./downloads
        cd ./downloads
        wget http://fastjet.fr/repo/$fdfile
        cd -
    fi
    tar zxvf ./downloads/$fdfile
    cd $srcdir

    [ "$2" = "clean" ] && make clean

    [ -d $XDIR/modules/CGAL ] && module use $XDIR/modules && module load CGAL

    exec_configure $install_dir

    #make && make install

    #write_setup_script $install_dir $version
    # write_module_file $install_dir $version
    #$XDIR/bin/make_module_from_current.sh -d $install_dir -n fastjet -v $version -o $XDIR/modules/
fi

cd $savedir
