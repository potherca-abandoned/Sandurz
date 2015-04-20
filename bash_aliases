
# ==============================================================================
# To keep this file simple and clean, we put more complex scripts in `.bashrc.d`
# and include all the files from that directory from here
# ------------------------------------------------------------------------------
function includeFolder {
    echo "Including enhancements from $1"

    iLength=${#1}

    aFiles=$(find "$1" -type f -name '*.sh' | sort -d)

    for sFile in $aFiles;do
        echo "--> ${sFile:$iLength}"
        source "$sFile"
    done
}
# ==============================================================================

sDirectory="${HOME}"
includeFolder "$sDirectory/.bashrc.d/"

#EOF
