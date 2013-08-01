#!/bin/bash

# Stop the Selenium Server
PID=`ps -eo pid,args | grep "selenium.*-port 4444" | grep -v grep | awk '{ print $1 }'`

echo 'Stopping the Selenium Server...'
if [ "$PID" = "" ];then
	echo 'The Selenium Server was not running'
else
	kill "$PID"
	echo 'Selenium Server stopped'
fi

# Stop the X virtual framebuffer
PID=`ps -eo pid,args  | grep "Xvfb.*:22" | grep -v grep | awk '{ print $1 }'`
echo 'Stopping the Xvfb Server for display 22...'
if [ "$PID" = "" ];then
        echo 'The Xvfb  Server was not running'
else
        kill "$PID"
        echo 'Xvfb Server stopped'
fi

#EOF
