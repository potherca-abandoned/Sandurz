#!/usr/bin/env bash
set -e
#set -x

g_sInstallDir='.'

function download()
{
    wget --directory-prefix="${g_sInstallDir}" --progress=bar:force "$1"
}

BANNER='--------------------------------------------------------------------------------'

function getSeleniumServer() {
    echo $BANNER

    echo 'Checking for the latest Selenium Standalone Server version from "seleniumhq.org"'

    latestServerUrl=`wget --quiet -O- http://docs.seleniumhq.org/download/ | grep -o 'http://selenium.googlecode.com/files/selenium-server-standalone-[0-9\.]*.jar' | head -1`


    latestServerVersion=`echo "$latestServerUrl" | grep -o 'selenium-server-standalone-[0-9\.]*'`
    latestServerVersion="${latestServerVersion%?}"

    echo "Latest Version of Selenium Standalone Server is \"$latestServerVersion\""
    echo "Downloading $latestServerVersion from $latestServerUrl"

    download "$latestServerUrl"
}

function run() {
    if [ "$#" != "1" ];then
        echo 'This script expect exactly one parameter: the path of the directory where Selenium should be installed'
        exit 1
    elif [ ! -d "$1" ];then
        echo 'The given directory does not exist'
        exit 2
    fi

    g_sInstallDir=$1


    echo $BANNER
    echo "The best way to run Selenium is in combination with Xvfb."

    if [ ! "$(which Xvfb)" ];then
        echo 'Xvfb is not yet installed on this system.'
        echo 'Xvfb will be installed through "apt-get".'
        sudo apt-get install xvfb
    else
        echo 'Xvfb is already installed on this system.'
    fi

    getSeleniumServer

    #@TODO: Copy/Echo utility script to ${g_sInstallDir}

    echo ""
    echo "The Selenium Server and utility scripts have been downloaded and installed to ${g_sInstallDir}"
    echo ""

}

run $@

exit

#EOF
