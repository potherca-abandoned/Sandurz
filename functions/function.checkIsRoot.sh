#!/usr/bin/env bash

function checkIsRoot {
    GEBRUIKER="`whoami`"

    if [ $GEBRUIKER != 'root' ]; then
        echo You can only run this script as ROOT!
        endScript
    fi
}

#EOF
