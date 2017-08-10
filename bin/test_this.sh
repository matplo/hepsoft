#!/bin/bash

source /project/projectdirs/alice/ploskon/software/hepsoft/bin/tools.sh

echo "arg with -a: "$(get_opt_with -a)
echo "is -a set? "$(is_opt_set -a)

echo "this file dir is:"$this_file_dir
echo "this dir:"$this_dir
echo "up this dir:"$up_dir

echo "is pdsf? "$(host_pdsf)
echo "is Linux? "$(os_linux)
echo "is Darwin? "$(os_darwin)

[ $(os_linux) ] && echo "This is linux..."
[ $(os_darwin) ] && echo "This is mac os x..."
[ $(host_pdsf) ] && echo "This is pdsf..."

test_file=test_file.txt
cat>>$test_file<<EOF
this is a text
EOF

cat $test_file

sedi s:text:changedtext:g $test_file

cat $test_file
rm $test_file
