#!/usr/bin/env bash

source "${HOME}/.common.sh"
sourceFunction indent

# ==============================================================================
function printWarning() {
# ------------------------------------------------------------------------------
    echo
    echo " !     WARNING: $*" | indent 'no_first_line_indent'
    echo
}
# ==============================================================================


# ==============================================================================
if [ "${0}" = "${BASH_SOURCE}" ];then
    # direct call to file
    printWarning $@
fi # else file is included from another script
# ==============================================================================

#EOF
