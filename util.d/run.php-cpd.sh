#!/usr/bin/env bash
set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

# ==============================================================================
#                               CONFIG VARS
# ------------------------------------------------------------------------------
if [ $# -lt 1 ];then
    #@TODO: Proper usage description
    echo 'This script expects one parameters: '
    echo '    - The directory to run detection on'
    exit 64
fi

SUBJECT_FOLDER="$1"
# ==============================================================================

# ==============================================================================
# RUN
# ------------------------------------------------------------------------------
phpcpd \
    --log-pmd cp.log \
    --exclude "$SUBJECT_FOLDER/system/plugins/" \
    "$SUBJECT_FOLDER"

# ==============================================================================
#EOF
