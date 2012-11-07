#!/bin/bash

if [ $# != 1 ];then
    echo 'ERROR : This script expects exactly one parameter:  the directory to audit'
    exit 65
fi

time php -d error_reporting=0 /home/ben/Dropbox/www/playground/PhpSecurityAudit/phpsecaudit/run.php --src "$1"

#EOF
