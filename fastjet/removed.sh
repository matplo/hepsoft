#boost_libs=$(find $boostDIR/lib/ -name "*.so" -exec echo -l{} \; | sed "s|${boost}/lib/lib||g" | sed "s|.so||g" | xargs echo -n)
#boost_libs=$(find $boostDIR/lib/ -name "*.so" -exec echo -L{} \; | xargs echo -n)
#./configure --prefix=${install_dir} --enable-cgal --with-cgaldir=${CGALDIR} LDFLAGS=-Wl,-rpath,${boostDIR}/lib CPPFLAGS=-I${boostDIR}/include

#not working
#./configure --prefix=${install_dir} --enable-cgal --with-cgaldir=${CGALDIR} LDFLAGS=-L${boostDIR}/lib LIBS="\"${boost_libs}\"" CPPFLAGS=-I${boostDIR}/include
#./configure --prefix=${install_dir} --enable-cgal --with-cgaldir=${CGALDIR} LT_SYS_LIBRARY_PATH=${boostDIR}/lib:$LT_SYS_LIBRARY_PATH CPPFLAGS=-I${boostDIR}/include
#./configure --prefix=$install_dir
