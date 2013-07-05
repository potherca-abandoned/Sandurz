#!/usr/bin/env bash

declare -a RESULTS
EXITSTATUS=0

handleParams() {
	if [ "$#" -lt 2 ];then
		echo "-- Script needs exactly two parameters, the names of the Databases to compare."
	  	echo "-- Usage: $0 DB1 DB2"
		return 1
	else
		USER=
		PASS=

		HOST='-h dcpf-dev'	# Define a remote host here and uncommend to use

		#VERBOSE=''			# Verbose by Default
		VERBOSE='--brief'	# Not Verbose by Default

		#TODO: username, password and host should be parameters
		DATABASES="$@"
	fi
}

dumpDatabases() {
	#dump all requested databases
	for DB in $DATABASES
	do
		echo "-- Dumping $DB"
		mysqldump $HOST --user=$USER --password=$PASS $DB --no-data=true --add-drop-table=false > dump-$DB.sql
		if [ $? -gt 0 ];then
			echo 'Dump Failed, quiting'
			return 2
		fi
	done
}

diffBetweenDumps() {
	#diff between dumps
	for (( COUNTER=1; COUNTER<=$#; COUNTER++ ))
	do
		if [ $COUNTER != 1 ]; then
			eval PREVIOUS=\$$(expr $COUNTER - 1)
			eval CURRENT=\$$COUNTER
		
			FILE1="dump-$PREVIOUS.sql"
			FILE2="dump-$CURRENT.sql"
		
			echo "-- Comparing $FILE1 and $FILE2"
			#TODO: Clean this line up...
			RESULTS[$COUNTER]=$(diff $FILE1 $FILE2 $VERBOSE --ignore-matching-lines='^-- \(Host:\|Dump completed on\) .*' &&  echo "Files $FILE1 and $FILE2 are the same")

			if [ $? -gt 0 ];then
				return 3
			fi
		fi
	done
}


cleanup() {
	for DB in $DATABASES
	do
		echo "-- Deleting dump-$DB.sql"
		rm dump-$DB.sql
	done
}

showResults() {
	echo ""
	echo "-- ${RESULTS[*]}"
}


handleParams $@
EXITSTATUS=$?

if [ $EXITSTATUS = 0 ];then
	dumpDatabases
	
	EXITSTATUS=$?
	if [ $EXITSTATUS = 0 ];then	
		diffBetweenDumps
		cleanup
		showResults
	fi
fi

exit $EXITSTATUS

#EOF
