#!/bin/bash
set -o nounset # exit on use of an uninitialised variable, same as -u
# set -x        # uncomment to debug

# ==============================================================================
# Configure this to point to the directory where you keep the Sonar Runner executable
# ------------------------------------------------------------------------------
SONAR_RUNNER_DIR='/home/ben/Desktop/dev/sonar-runner-1.3/bin'
# ==============================================================================

EXITSTATUS=0
declare RESULTS

# ==============================================================================
# ------------------------------------------------------------------------------
handleParams() {
	if [ "$#" -lt 1 ];then
		echo '-- Script expects one parameter, the directory of the project to run Sonar for.'
	  	echo "-- Usage: $0 /path/to/project"
        return 64
	else
        PROJECT_DIR=$1
	fi
}
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
run(){
    HERE=`pwd`

    cd $PROJECT_DIR
    sudo echo;
    
    echo "Starting: `date +"%Y%m%d-%R:%S"`"  > "$PROJECT_DIR/sonar.log"

    sudo $SONAR_RUNNER_DIR/sonar-runner 2>&1 >> "$PROJECT_DIR/sonar.log" &
    RESULT=$?
    
    echo "Stopped: `date +"%Y%m%d-%R:%S"`" >> "$PROJECT_DIR/sonar.log"

    cd $HERE
    
    return $RESULT
}
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
handleParams $@
EXITSTATUS=$?

if [ $EXITSTATUS = 0 ];then
	run
	EXITSTATUS=$?
    
    if [ $EXITSTATUS = 0 ];then
        tail -f "$PROJECT_DIR/sonar.log"
    fi

fi

exit $EXITSTATUS
# ==============================================================================

#EOF
