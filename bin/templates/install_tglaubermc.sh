#!/bin/bash

savedir=$PWD

XDIR="<dir to be set>"
working_dir="$XDIR/tglaubermc"
mkdir -p $working_dir

function exec_configure()
{
	./configure --prefix=$1
}

function write_setup_script()
{
    fname=setenv_tglaubermc_$2.sh
    outdir=$1/bin
    #outfile=$outdir/$fname
    mkdir -p $XDIR/scripts 
    outfile=$XDIR/scripts/$fname
    rm -rf $outfile

    cat>>$outfile<<EOF
#!/bin/bash

export TGLAUBERMCDIR=$1
export TGLAUBERMC_VERSION=$2    
export DYLD_LIBRARY_PATH=\$TGLAUBERMCDIR:\$DYLD_LIBRARY_PATH
export LD_LIBRARY_PATH=\$TGLAUBERMCDIR:\$LD_LIBRARY_PATH
export PATH=\$TGLAUBERMCDIR:\$PATH
EOF
}

function write_module_file()
{
    version=$2
    outfile=$XDIR/modules/tglaubermc/$version
    outdir=`dirname $outfile`
    mkdir -p $outdir
    rm -rf $outfile

    cat>>$outfile<<EOF
#%Module
proc ModulesHelp { } {
        global version
        puts stderr "   Setup tglaubermc \$version"
    }

set     version $version
setenv  TGLAUBERMCDIR $1
setenv  TGLAUBERMC_VERSION $2    
prepend-path LD_LIBRARY_PATH $1
prepend-path DYLD_LIBRARY_PATH $1
prepend-path PATH $1/bin

EOF
}

function write_compile_macro()
{
    cat>>compile.C<<EOF
{
    gSystem->Load("libMathMore");
    gROOT->ProcessLine(".L runglauber_v$1.C+");
}
EOF
    rm -v rootlogon.C
    cat>>rootlogon.C<<EOF
{
    gSystem->Load("libMathMore");
    gROOT->LoadMacro("runglauber_v2.3.C+");
}
EOF

}

if [ ! -d "$working_dir" ]; then
    echo "[error] $working_dir does not exist."
else
    version=$1
    [ -z $version ] && version=2.3
    install_dir="$working_dir/$version"

    cd $working_dir
    echo $PWD
    echo "[i] will install to: $install_dir"    
    echo "[i] installing tglaubermc $version"

    fdfile="TGlauberMC-$version.tar.gz"
    #srcdir="tglaubermc-$version"
    echo "[i] file to download: $fdfile"
    echo "[i] source sub dir: $srcdir"
    if [ -e "./downloads/$fdfile" ]; then
        echo "[i] $fdfile exists - will not download"
    else
        mkdir -p ./downloads
        cd ./downloads
        echo $PWD
        wget http://www.hepforge.org/archive/tglaubermc/$fdfile
        wget -p --convert-links -nH -nd -ParXiv http://export.arxiv.org/api/query?id_list=1408.2549
        mv -v "./arXiv/query?id_list=1408.2549" "./arXiv/1408.2549.xml"
        cd -
    fi
    #cd $srcdir

    [ "$2" = "clean" ] && make clean    

    #exec_configure $install_dir
    #make && make install
    rm -rf $install_dir
    mkdir -p $install_dir
    cd $install_dir
    tar zxvf ../downloads/$fdfile
    write_compile_macro $version
    #root -l compile.C -q
    root -l -q
    ln -sf "runglauber_v${version}_C.so" runglauber.so
    ln -sf "runglauber_v${version}_C.so" libTGlauberMC.so
    write_setup_script $install_dir $version
    write_module_file $install_dir $version

fi

cd $savedir
