#~/bin/bash

# Idea stolen from http://www.slideshare.net/nickgsuperstar/static-analysis-for-php

$logFile='parse-errors.log'

echo '' > $logFile

echo 'Will now check all files for syntax errors'

find . -name '*.php' -exec php -l '{}' 2>&1 \; | grep -v '^No syntax errors detected in' >> $logFile

cat $logFile


# @TODO: Check file starts with either '<?' or '#!'

#EOF
