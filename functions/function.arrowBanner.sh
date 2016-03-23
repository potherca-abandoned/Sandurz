#!/usr/bin/env bash

# ==============================================================================
#
# ------------------------------------------------------------------------------
function arrowBanner {
    local readonly sText=${1:-''}
    local readonly iTextColor=${2:-37} # white text
    local readonly iBackgroundColor=${3:-42} # Green Background

    local readonly iTailColor=${4:-30} # Black Text
    local readonly iHeadColor=${5:-32} # # Green Text
    local readonly iType=${6:-'1'} # Bold
    local readonly sDivider=${7:-'▶'} # ▄ 	░▒▓█◼◾► 	▶	◙⬤●◉◎○◌	◢◣◤◥	❯	⭑⭒

    local readonly sReset="\033[0m"

    echo -en "\033[${iTailColor};${iBackgroundColor}m${sDivider}\033[${iType};${iTextColor}m ${sText} ${sReset}\033[${iNextColor};${iHeadColor}m${sDivider}${sReset} "

}
# ==============================================================================

# ==============================================================================
if [ "${0}" = "${BASH_SOURCE}" ];then
    # direct call to file
    arrowBanner "$@"
fi # else file is included from another script
# ==============================================================================

#EOF