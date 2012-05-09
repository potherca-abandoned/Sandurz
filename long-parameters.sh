#!/bin/bash
set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

declare -a OPTIONS
declare -a PARAMETERS

COUNTER=-1
DEBUG=0
EXITCODE=0
NOPARAM='--//-- NO PARAM --\\--'

option=''
parameter=''

function echoDebug() {
	if [ "$DEBUG" != "0" ];then
		echo "$@"
	fi
}

function showParameters() {
	for (( C=0; C<=$COUNTER; C++ ))
	do
		PARAM=${PARAMETERS[$C]}
		if [ "$PARAM" == "$NOPARAM" ];then
			PARAM=
		fi
		#echo "$C : ${OPTIONS[$C]} : $PARAM"
		echo "${OPTIONS[$C]} $PARAM"
	done
}

function error() { 
	echo "$@" 1>&2 # Write to STDERR
	exit 1
}

function register() {
	if [ "$parameter" != "" ];then
		if [ "$option" = "" ];then
			error "ERROR: Parameter #$(($COUNTER+2)) has value \"$parameter\" without an accompanying Option!"
		else
			(( COUNTER++ )) || true # because of the -e flag we need to redirect the 1 returned by using a sub 
			OPTIONS[$COUNTER]=$option
			PARAMETERS[$COUNTER]=$parameter
			fi
		option=''
		parameter=''
	fi
}

function getParameters() {
	for string in "$@"
	do
		register
	
		if [ "$string" != "${string#--}" ];then
			# A Long Option
			option="${string#--}"
			if [[ "${string#--}" == *=* ]];then
				# A Long Option and Parameter combined
				option=${option%%=*}	# Deletes longest  match of "=" from back  of $option.
				parameter=${string#*=}	# Deletes shortest match of "=" from front of $string.
			fi
		elif [ "$string" != "${string#-}" ];then
			# A Short Option
			option="${string#-}"
			
			if [ ${#option} -gt 1 ];then
				# Group of Short Options
				options=$option

				for (( counter = 0 ; counter < ${#options} ; counter++ ))
				do
					option=${options:$counter:1}
					parameter=$NOPARAM
					register
				done	    	
			fi
		else
			parameter=$string
		fi
	done

	register
}

getParameters "$@"
showParameters

exit $EXITCODE

# test calling:
# clear;./long-params-test.sh --user ben barf -p -ltr -c 123 --password="foo=bar" --host "foo bar"

# getopts ":u(user):p(password)h(host)v(verbose)"

