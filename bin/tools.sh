#!/bin/bash

export global_args="$@"

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

function thisdir()
{
	THISFILE=`abspath $BASH_SOURCE`
	XDIR=`dirname $THISFILE`
	if [ -L ${THISFILE} ];
	then
		target=`readlink $THISFILE`
		XDIR=`dirname $target`
	fi

	THISDIR=$XDIR
	echo $THISDIR
}

function get_opt_with()
{
	local do_echo=
	local retval=
	for g in $global_args
	do
		if [ ! -z $do_echo ] ; then
			if [[ ${g:0:1} != "-" ]]; then
				retval=$g
			fi
			do_echo=
		fi
		if [ $g == $1 ]; then
			do_echo="yes"
		fi
	done
	echo $retval
}

function is_opt_set()
{
	local retval=
	for g in $global_args
	do
		if [[ ${g:0:1} != "-" ]]; then
			continue
		fi
		if [ $g == $1 ]; then
			retval="yes"
		fi
	done
	echo $retval
}

this_file_dir=$(thisdir)
this_dir=$(abspath $this_file_dir)
up_dir=$(dirname $this_dir)

function os_linux()
{
	_system=$(uname -a | cut -f 1 -d " ")
	if [ $_system == "Linux" ]; then
		echo "yes"
	else
		echo 0
	fi
}

function os_darwin()
{
	_system=$(uname -a | cut -f 1 -d " ")
	if [ $_system == "Darwin" ]; then
		echo "yes"
	else
		echo
	fi
}

function host_pdsf()
{
	_system=$(uname -n | cut -c 1-4)
	if [ $_system == "pdsf" ]; then
		echo "yes"
	else
		echo
	fi
}

function sedi()
{
	[ $(os_darwin) ] && sed -i " " $@
	[ $(os_linux)  ] && sed -i'' $@
}

function strip_root_dir()
{
	local _this_dir=$1
	echo $(echo $_this_dir | sed "s|${up_dir}||" | sed "s|/||")
}

function module_name()
{
	local _this_dir=$1
	echo $(dirname $(echo $_this_dir | sed "s|${up_dir}||" | sed "s|/||" | sed "s|.||"))
}
