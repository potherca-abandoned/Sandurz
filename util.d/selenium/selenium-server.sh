#!/usr/bin/env bash
set -e
#set -x

# ==============================================================================
#                               Selenium Server
# ------------------------------------------------------------------------------
# This script will start, stop or restart an instance of the Selenium Standalone
# Server, utilizing Xvfb.

# This script expects one command-line argument, 'start', 'stop' or 'restart'
#
# ------------------------------------------------------------------------------
# The following ExitCodes are used:
#
# 64  : General Error
#
# 65 : Incorrect param(s) given
# 66 : Selenium Standalone Server JAR file could not be found
# 67 : Could not start XvfbServer
# 68 : Script not run as root user
# 69 : Could not stop Selenium Standalone Server
# 70 :
#
# ==============================================================================

# ==============================================================================
# Set up some defaults
# ------------------------------------------------------------------------------
sLogFile='/var/log/selenium-server.log'
screenSize='1024x768x16'
displayNumber='22'
portNumber='4444'
currentDir=`dirname $0`
SeleniumServer=''

# ==============================================================================

# ==============================================================================
# Stop the X virtual framebuffer
# ------------------------------------------------------------------------------
function stopXvfbServer() {
	displayNumber="$1"

    #@CHECKME: Does this command always find the process when it is running?
    PID=`ps -eo pid,args  | grep "Xvfb.*:$displayNumber" | grep -v grep | awk '{ print $1 }'`
    echo "Stopping the Xvfb Server for display $displayNumber..."
    if [ "$PID" = "" ];then
            echo 'The Xvfb  Server was not running'
	        RESULT=0
    else
            kill "$PID"
            RESULT=$?
            echo 'Xvfb Server stopped'
    fi
    return $RESULT
}
# ==============================================================================

# ==============================================================================
# Start a X virtual framebuffer server
# ------------------------------------------------------------------------------
function startXvfbServer() {
	displayNumber="$1"
	screenSize="$2"

    PID=`ps -eo pid,args  | grep "Xvfb.*:$displayNumber" | grep -v grep | awk '{ print $1 }'`

    if [ "$PID" = "" ];then
	    echo "Starting the Xvfb Server on display $displayNumber..."
	    Xvfb -fp /usr/share/fonts/X11/misc/ :$displayNumber -screen 0 $screenSize >> "${sLogFile}" 2>&1 &
	    RESULT=$?
	    export DISPLAY=:$displayNumber
    else
        echo  "There is already an Xvfb Server running on display $displayNumber"
	    RESULT=0
    fi

    return $RESULT
}
# ==============================================================================


# ==============================================================================
# Locate the Selenium Server `jar` file
# ------------------------------------------------------------------------------
function locateSeleniumServer(){

    local sSeleniumJarFile=$(ls | grep -P -o 'selenium-server-standalone-[0-9\.]*.jar' | head -1)

    if [ "${sSeleniumJarFile}" == "" ];then
        echo "[ERROR]: Could not find selenium-server-standalone JAR file in '${currentDir}'"
        exit 66
    else
        SeleniumServer="${currentDir}/${sSeleniumJarFile}"
    fi
}
# ==============================================================================


# ==============================================================================
# Start the Selenium Server
# ------------------------------------------------------------------------------
function startSeleniumServer() {

    if [ ! -f "${sLogFile}" ];then
        echo '' > ${sLogFile}
    fi

    locateSeleniumServer

    startXvfbServer $displayNumber $screenSize
    RESULT=$?

    if [ "$RESULT" != "0" ];then
        echo '[ERROR]: Can not start Selenium as the XvfbServer would not start'
        RESULT=67
    else

        PID=`ps -eo pid,args | grep "selenium.*-port $portNumber" | grep -v grep | awk '{ print $1 }'`

        if [ "$PID" = "" ];then
            # Remove last log
	        if [ -f "${sLogFile}.previous" ];then
		        rm "${sLogFile}.previous"
	        fi

            # Backup current log
	        if [ -f "${sLogFile}" ];then
		        mv "${sLogFile}" "${sLogFile}.previous"
	        fi

	        # Start a new log
	        echo '' > ${sLogFile}

	        # Make sure the logs can be read by other users (over ssh for instance...)
	        # Does not work if in protected directory, so useless for now
	        #chmod 777 ${sLogFile}

	        # start the selenium server
	        echo 'Starting the Standalone Selenium Server...'
	        java -jar "$SeleniumServer" -port $portNumber >> "${sLogFile}" 2>&1 &
	        RESULT=$?
        else
	        echo 'The Selenium Server is already running'
	        RESULT=0
        fi
    fi

    return $RESULT
}
# ==============================================================================


# ==============================================================================
# Stop the Selenium Server
# ------------------------------------------------------------------------------
function stopSeleniumServer() {
    PID=`ps -eo pid,args | grep "selenium.*-port $portNumber" | grep -v grep | awk '{ print $1 }'`

    echo 'Stopping the Selenium Server...'
    if [ "$PID" = "" ];then
	    echo 'The Selenium Server was not running'
        RESULT=0
    else
	    kill "$PID"
        RESULT=$?

        if [ "$RESULT" != "0" ];then
            echo '[ERROR]: Can not stop Selenium Server'
            RESULT=69
        else
    	    echo 'Selenium Server stopped'
                RESULT=0
        fi
    fi

    stopXvfbServer $screenSize
    XvfbRESULT=$?

    if [ "$XvfbRESULT" != "0" ];then
        echo '[ERROR]: Can not stop the XvfbServer'
        XvfbRESULT=1
    fi

    return $(expr $RESULT + $XvfbRESULT);
}
# ==============================================================================


# ==============================================================================
function restartSeleniumServer() {
# ------------------------------------------------------------------------------
    stopSeleniumServer
    StopResult=$?

    startSeleniumServer
    StartResult=$?

    return $(expr $StopResult + $StartResult);
}
# ==============================================================================


# ==============================================================================
function run() {
# ------------------------------------------------------------------------------
    case $1 in
        start)
            startSeleniumServer
            RESULT=$?
           ;;
        stop)
            stopSeleniumServer
            RESULT=$?
           ;;
        restart)
            restartSeleniumServer
            RESULT=$?
           ;;
        *)
           echo 'Available options are "start", "stop" or "restart"'
           RESULT=65
           ;;
    esac

    return $RESULT
}
# ==============================================================================

if [ `whoami` != "root" ];then
    echo "[ERROR]: Only allowed as root user"
    RESULT=68
else
    run $1
    RESULT=$?
    tail -f ${sLogFile} &
fi

exit $RESULT

#EOF
