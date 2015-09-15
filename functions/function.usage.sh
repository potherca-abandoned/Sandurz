#!/usr/bin/env bash

usage() {
    shortUsage "${@:-}"
}

# Displays all lines in main script that start with '##'
shortUsage() {
    [ "$*" ] && echo "$0: $*"
    sed -n '/^##/,/^$/s/^## \{0,1\}//p' "$0"
} #2>/dev/null

# Displays all lines in main script that start with '#/'
fullUsage() {
    grep '^#/' <"$0" | cut -c4-
}

if [ "${0}" = "${BASH_SOURCE}" ];then
    usage
fi # else file is included from another script

#EOF
