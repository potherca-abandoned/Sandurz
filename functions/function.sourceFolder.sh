#!/usr/bin/env bash

source "${HOME}/.common.sh"

sourceFunction indent printStatus printTopic

# ==============================================================================
function sourceFolder {
# ------------------------------------------------------------------------------
    local sPath="$(readlink $1)"

    sExtension=".${2:-sh}"
    printTopic "Sourcing all '${sExtension}' files from folder '$sPath'"

    iLength=${#sPath}

    aFiles="$(find $sPath -type f -name \*${sExtension} | sort -d)"

    for sFile in $aFiles;do
        printStatus "${sFile:$iLength}" | indent
        source "${sFile}"
    done
}
# ==============================================================================

# ==============================================================================
if [ "${0}" = "${BASH_SOURCE}" ];then
    # direct call to file
    sourceFolder $@
fi # else file is included from another script
# ==============================================================================

#EOF
