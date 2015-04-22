source "${HOME}/.common.sh"

sourceFunction printStatus
sourceFunction printTopic
sourceFunction indent

# ==============================================================================
# To keep this file simple and clean, we put more complex scripts in `.bashrc.d`
# and include all the files from that directory from here
# ------------------------------------------------------------------------------
function includeFolder {
    printTopic "Including enhancements from $1"

    iLength=${#1}

    aFiles=$(find "$1" -type f -name '*.sh' | sort -d)

    for sFile in $aFiles;do
        printStatus "${sFile:$iLength}"
        source "$sFile" | indent
    done
}
# ==============================================================================

sDirectory="${HOME}"
includeFolder "$sDirectory/.bashrc.d/"

#EOF
