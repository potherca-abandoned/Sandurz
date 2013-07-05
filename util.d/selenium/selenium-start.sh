#!/bin/bash

# Start a X virtual framebuffer server
PID=`ps -eo pid,args  | grep "Xvfb.*:22" | grep -v grep | awk '{ print $1 }'`

if [ "$PID" = "" ];then
	echo 'Starting the Xvfb Server on display 22...'
	Xvfb -fp /usr/share/fonts/X11/misc/ :22 -screen 0 1024x768x16 2>&1 &
	export DISPLAY=:22
else
        echo  'There is already an Xvfb Server running on display 22'
fi


# Sttart the Selenium Server
PID=`ps -eo pid,args | grep "selenium.*-port 4444" | grep -v grep | awk '{ print $1 }'`

if [ "$PID" = "" ];then
        if [ -f "selenium-server.previous.log" ];then
                rm "selenium-server.previous.log"
        fi

	if [ -f "selenium-server.log" ];then
		mv "selenium-server.log" "selenium-server.previous.log"
	fi

	# Clear out the log
	echo '' > "selenium-server.log"

	# Make sure the logs can be read by other users (over ssh for instance...)
	chmod 777 "selenium-server.log"

	# start the selenium server
	echo 'Starting the Standalone Selenium Server...'
	java -jar selenium-server-standalone-2.21.0.jar -port 4444 >> "selenium-server.log" 2>&1 &
else
	echo 'The Selenium Server is already running'
fi

#EOF
