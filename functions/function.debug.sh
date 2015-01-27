#!/usr/bin/env bash

# ==============================================================================
# @see: http://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_03.html
# ------------------------------------------------------------------------------
function debug() {
    echo -e "#[DEBUG] ${1}" >&1
}

# ==============================================================================
# set -o noexec     # Read commands in script, but do not execute them (syntax check), same as set -n
#
# set -x            # activate debugging from here
# ...               # your code here
# set +x            # stop debugging from here

function debugTrapMessage {
    debug "[${1}:${2}] ${3}"
}

if [ "${0}" = "${BASH_SOURCE}" ];then
    # direct call to file
    debug $@
fi # else file is included from another script

#EOF
