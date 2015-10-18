#!/usr/bin/env bash

source "${HOME}/.common.sh"

sourceFunction indent
sourceFunction printStatus
sourceFunction printTopic

# ==============================================================================
function sourceFolder {
# ------------------------------------------------------------------------------
    # @TODO: Make `sExtension` an optional second parameter
    sExtension='.sh'
    printTopic "Sourcing all '${sExtension}' files from folder '$1'"

    iLength=${#1}

    aFiles=$(find "$1" -type f -name "*${sExtension}" | sort -d)

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