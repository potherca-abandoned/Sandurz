#!/usr/bin/env bash

if [ $# != 2 ];then
    echo 'ERROR : This script expects two parameter:'
    echo ' -- the directory to audit'
    echo ' -- the directory to write the output to'
    exit 65
fi

time php -d error_reporting=0 /home/ben/Dropbox/www/playground/PhpSecurityAudit/phpsecaudit/run.php --src "$1" --outdir "$2"

#EOF
