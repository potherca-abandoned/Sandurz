#!/bin/bash
#set -x

seleniumServerVersion='2.25.0'

# ==============================================================================
# Set up some defaults
# ------------------------------------------------------------------------------
logFile='/var/log/selenium-server.log'
screenSize='1024x768x16'
displayNumber='22'
portNumber='4444'
currentDir=`dirname $0`
SeleniumServer="${currentDir}/selenium-server-standalone-${seleniumServerVersion}.jar"
# ==============================================================================

# ==============================================================================
# Stop the X virtual framebuffer
# ------------------------------------------------------------------------------
function stopXvfbServer() {
	displayNumber="$1"

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
	    Xvfb -fp /usr/share/fonts/X11/misc/ :$displayNumber -screen 0 $screenSize >> $logFile 2>&1 &
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
# Start the Selenium Server
# ------------------------------------------------------------------------------
function startSeleniumServer() {
    startXvfbServer $displayNumber $screenSize
    RESULT=$?

    if [ "$RESULT" != "0" ];then
        echo 'ERROR: Can not start Selenium as the XvfbServer would not start'
        RESULT=1
    else

        PID=`ps -eo pid,args | grep "selenium.*-port $portNumber" | grep -v grep | awk '{ print $1 }'`

        if [ "$PID" = "" ];then
            # Remove last log
	        if [ -f "$logFile.previous" ];then
		        rm "$logFile.previous"
	        fi

            # Backup current log
	        if [ -f "$logFile" ];then
		        mv "$logFile" "$logFile.previous"
	        fi

	        # Start a new log
	        echo '' > $logFile

	        # Make sure the logs can be read by other users (over ssh for instance...)
	        # Does not work if in protected directory, so useless for now
	        #chmod 777 $logFile

	        # start the selenium server
	        echo 'Starting the Standalone Selenium Server...'
	        java -jar "$SeleniumServer" -port $portNumber >> "$logFile" 2>&1 &
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
            echo 'ERROR: Can not stop Selenium Server'
            RESULT=1
        else
    	    echo 'Selenium Server stopped'
                RESULT=0
        fi
    fi

    stopXvfbServer $screenSize
    XvfbRESULT=$?
    
    if [ "$XvfbRESULT" != "0" ];then
        echo 'ERROR: Can not stop the XvfbServer'
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
           echo 'Please select "start", "stop" or "restart"'
           ;;
    esac
    
    return $RESULT
}
# ==============================================================================

if [ `whoami` != "root" ];then
    echo "ERROR: Only allowed as root user"
    RESULT=1
else
    run $1
    RESULT=$?
    tail -f $logFile &
fi

exit $RESULT

#EOF
