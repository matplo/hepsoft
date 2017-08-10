#!/bin/bash

cdir=$PWD

version=3.3.0
local_file=fastjet-${version}.tar.gz
[ ! -e ${local_file} ] && wget http://fastjet.fr/repo/${local_file}
local_dir=fastjet-${version}
rm -rf ${local_dir}
tar zxvf ${local_file}
cd $local_dir
install_dir=$cdir/$version

modules_dir=$(dirname $cdir)/modules
module use $modules_dir
 [ $(uname -n | cut -c 1-4) = "pdsf" ] && module load CGAL/4.10
#[ $(uname -n | cut -c 1-4) = "pdsf" ] && module load gcc python
module list

rm -rf $install_dir
#make clean
boost_libs=$(find $boostDIR/lib/ -name "*.so" -exec echo -l{} \; | sed "s|${boost}/lib/lib||g" | sed "s|.so||g" | xargs echo -n)
boost_libs=$(find $boostDIR/lib/ -name "*.so" -exec echo -L{} \; | xargs echo -n)
#./configure --prefix=${install_dir} --enable-cgal --with-cgaldir=${CGALDIR} LDFLAGS=-Wl,-rpath,${boostDIR}/lib CPPFLAGS=-I${boostDIR}/include
./configure --prefix=${install_dir} --enable-cgal --with-cgaldir=${CGALDIR} LDFLAGS=-Wl,-rpath,${boostDIR}/lib CXXFLAGS=-I${boostDIR}/include
#./configure --prefix=${install_dir} --enable-cgal --with-cgaldir=${CGALDIR} LDFLAGS=-L${boostDIR}/lib LIBS="\"${boost_libs}\"" CPPFLAGS=-I${boostDIR}/include
#./configure --prefix=${install_dir} --enable-cgal --with-cgaldir=${CGALDIR} LT_SYS_LIBRARY_PATH=${boostDIR}/lib:$LT_SYS_LIBRARY_PATH CPPFLAGS=-I${boostDIR}/include
#./configure --prefix=$install_dir
make -j && make install
$cdir/../bin/make_module_from_current.sh -d $install_dir -n fastjet -v $version -o $cdir/../modules/

cd $cdir
