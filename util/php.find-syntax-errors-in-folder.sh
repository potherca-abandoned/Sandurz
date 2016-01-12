#!/usr/bin/env bash
set -e
set -u

# Idea stolen from http://www.slideshare.net/nickgsuperstar/static-analysis-for-php

if [ $# -lt 1 ];then
    #@TODO: Proper usage description
    echo 'This script expects one parameter: the directory to check for PHP (syntax) errors.'
    exit 64
fi

DIR=$1

logFile='php-errors.log'

echo '' > $logFile

echo 'Will now check all files for syntax errors. This may take a while...'

# @TODO: Make excluding files/folders possible (helps with vendor code and false positives)

find "$DIR" -name '*.php' -exec php -l '{}' 2>&1 \; | grep -v '^No syntax errors detected in' >> $logFile

cat $logFile


# @TODO: Check file starts with either '<?' or '#!' (this includes no BOM!)

#EOF
