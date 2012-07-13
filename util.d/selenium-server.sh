#!/bin/bash

# ==============================================================================
# ------------------------------------------------------------------------------
logFile='selenium-server.log'
screenSize='1024x768x16'
displayNumber='22'
portNumber='4444'
# ==============================================================================

# ==============================================================================
# Stop the X virtual framebuffer
# ------------------------------------------------------------------------------
function stopXvfbServer() {
	displayNumber="$1"

    PID=`ps -eo pid,args  | grep "Xvfb.*:$displayNumber" | grep -v grep | awk '{ print $1 }'`
    echo 'Stopping the Xvfb Server for display $displayNumber...'
    if [ "$PID" = "" ];then
            echo 'The Xvfb  Server was not running'
    else
            kill "$PID"
            echo 'Xvfb Server stopped'
    fi
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
	    Xvfb -fp /usr/share/fonts/X11/misc/ :$displayNumber -screen 0 $screenSize 2>&1 &
	    export DISPLAY=:$displayNumber
    else
        echo  "There is already an Xvfb Server running on display $displayNumber"
    fi
}
# ==============================================================================


# ==============================================================================
# Start the Selenium Server
# ------------------------------------------------------------------------------
function startSeleniumServer() {
    startXvfbServer $displayNumber $screenSize

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
	    java -jar selenium-server-standalone-2.21.0.jar -port $portNumber >> $logFile 2>&1 &
    else
	    echo 'The Selenium Server is already running'
    fi
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
    else
	    kill "$PID"
	    echo 'Selenium Server stopped'
    fi

    stopXvfbServer $screenSize
}
# ==============================================================================


# ==============================================================================
function restartSeleniumServer() {
# ------------------------------------------------------------------------------
        stopSeleniumServer
        startSeleniumServer
}
# ==============================================================================


# ==============================================================================
function run() {
# ------------------------------------------------------------------------------
    case $1 in
        start)
            startSeleniumServer
           ;;
        stop)
            stopSeleniumServer
           ;;
        restart)
            restartSeleniumServer
           ;;
        *)
           echo 'Please select "start", "stop" or "restart"'
           ;;
    esac
}
# ==============================================================================

run $1

#EOF
