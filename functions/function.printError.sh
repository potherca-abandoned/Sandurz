#!/usr/bin/env bash

# ==============================================================================
# ------------------------------------------------------------------------------
function printError() {
  echo
  echo " !     ERROR: $*" 1>&2
  echo
}
# ==============================================================================


# ==============================================================================
if [ "${0}" = "${BASH_SOURCE}" ];then
    # direct call to file
    printDebug $@
fi # else file is included from another script
# ==============================================================================

#EOF
