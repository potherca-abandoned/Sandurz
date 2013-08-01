#!/bin/bash
set -e
#set -x

function download()
{
    wget --progress=bar:force "$1"
}

BANNER='--------------------------------------------------------------------------------'

function getSeleniumServer() {
    echo $BANNER
    echo "Checking for the latest Selenium Server version"
    latestServerUrl=`wget --quiet -O- http://docs.seleniumhq.org/download/ | grep -o 'http://selenium.googlecode.com/files/selenium-server-standalone-[0-9\.]*.jar' | head -1`
    
    
    latestServerVersion=`echo "$latestServerUrl" | grep -o 'selenium-server-standalone-[0-9\.]*'`
    latestServerVersion="${latestServerVersion%?}"

    echo "Downloading $latestServerVersion from $latestServerUrl"
    echo "download \"$latestServerUrl\""
}
    
function run() {    
    if [ "$#" != "1" ];then
        echo 'This script expect exactly one paramter: the path of the directory where Selenium should be installed'
        exit 
    fi

    installDir=$1

    getSeleniumServer

    echo ""
    echo "The Selenium Server and utility scripts have been downloaded and installed to $installDir"
}

run $@
    
exit
    
#EOF
