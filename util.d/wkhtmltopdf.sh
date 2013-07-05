#!/usr/bin/env bash

screenSize='1024x768x16'
displayNumber='22'

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

#xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf $*
startXvfbServer $displayNumber $screenSize
wkhtmltopdf $*

#EOF
