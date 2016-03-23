#!/usr/bin/env bash


# ==============================================================================
function checkIsRoot {
# ------------------------------------------------------------------------------
    if [ "$(whoami)" != 'root' ]; then
        source "${HOME}/.common.sh"
        sourceFunction printWarning
        printWarning 'Script can only be run as ROOT'
        exit 65;
    fi
}
# ==============================================================================

# ==============================================================================
if [ "${0}" = "${BASH_SOURCE}" ];then
    # direct call to file
    checkIsRoot
fi # else file is included from another script
# ==============================================================================

#EOF
