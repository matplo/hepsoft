#!/bin/bash

savedir=$PWD

PKGNAME=POWHEGV2
#manual at http://th-www.if.uj.edu.pl/~erichter/POWHEG-BOX-V2/Docs/manual-BOX.pdf
# http://powhegbox.mib.infn.it

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

function get_powheg()
{
    version=$1
    [ -z $version ] && version=trunk
    processess=$@
    rm -rf ./POWHEG-BOX-V2
    # svn checkout:
    svn checkout --username anonymous --password anonymous svn://powhegbox.mib.infn.it/$version/POWHEG-BOX-V2
    # list processess:
    # svn list --username anonymous --password anonymous svn://powhegbox.mib.infn.it/$version/User-Processes-V2
    # DMGG/ DMS/ DMS_tloop/ DMV/ DYNNLOPS/ HJ/ HJJ/ HW/ HWJ/ HZ/ HZJ/ ST_tch/ ST_tch_4f/ VBF_H/ VBF_HJJJ/ VBF_Wp_Wm/ VBF_Z_Z/ W/ W2jet/ WW/ WZ/ W_ew-BMNNP/ Wbb_dec/ Wbbj/ Wgamma/ Wj/ Wp_Wp_J_J/ Z/ Z2jet/ ZZ/ Z_ew-BMNNPV/ Zj/ bbH/ dijet/ dislepton-jet/ disquark/ ggHZ/ gg_H/ gg_H_2HDM/ gg_H_MSSM/ gg_H_quark-mass-effects/ hvq/ trijet/ ttH/ ttb_NLO_dec/ ttb_dec/ vbf_wp_wp/ weakinos/
    # checkout some processes:
    cd ./POWHEG-BOX-V2

    for i; do 
        if [ $i != $1 ]; then
            echo $i
            svn co --username anonymous --password anonymous svn://powhegbox.mib.infn.it/$version/User-Processes-V2/$i
        fi
    done
}

function build_install()
{
    echo "[i] build install..."
    cd ./POWHEG-BOX-V2

    cdir=$PWD
    for i; do 
        cd $cdir
        svn cd $i
        make clean
        make
        mkdir -p $working_dir/bin
        cd $working_dir/bin
        ln -s $cdir/$i/pwhg_main "pwhg_main_$i"
    done

    cd $cdir
}

if [ ! -d "$working_dir" ]; then
    echo "[error] $working_dir does not exist."
else
    version=$1
    [ -z $version ] && version=trunk
    install_dir="$working_dir"

    cd $working_dir
    echo $PWD
    echo "[i] will install to: $install_dir"    
    echo "[i] installing ${PKGNAME} $version"

    mkdir -p ./downloads
    cd ./downloads

    processes=$2
    processes="hvq Z"
    get_powheg $version $processes
    build_install $processes

    write_setup_script $install_dir $version
    write_module_file $install_dir $version

fi

cd $savedir
