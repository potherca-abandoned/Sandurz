
# ==============================================================================
# To keep this file simple and clean, we put more complex scripts in `.bashrc.d`
# and include all the files from that directory from here
# ------------------------------------------------------------------------------
function includeFolder {
    echo "Including enhancements from $1"

    iLength=${#1}

    for FILE in $(find "$1" -type f -name '*.sh' | sort -d);do
        echo "--> ${FILE:$iLength}"
        source "$FILE"
    done
}
# ==============================================================================

includeFolder "$(pwd)/.bashrc.d/"

#EOF
