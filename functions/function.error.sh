#!/usr/bin/env bash
# ==============================================================================
# Error message handling
#
# When sourced (included) from another file, it is the responsibility of that
# file to declare the variables required by this script like this:
# declare -i g_iExitCode=0
# declare -i g_iErrorCount=0
# declare -a g_aErrorMessages
# ==============================================================================

# ==============================================================================
#                            APPLICATION VARS
# ------------------------------------------------------------------------------
declare -i -x g_iExitCode=0
declare -i -x g_iErrorCount=0
declare -a -x g_aErrorMessages
# ==============================================================================

# ==============================================================================
# Store given message in the ErrorMessage array
# ------------------------------------------------------------------------------
function error() {
    if [ ! -z ${2:-} ];then
        g_iExitCode=${2}
    elif [ ${g_iExitCode} -eq 0 ];then
        g_iExitCode=64
    fi

    g_iErrorCount=$((${g_iErrorCount}+1))

    g_aErrorMessages[${g_iErrorCount}]="${1}\n"

    return ${g_iExitCode};
}
# ==============================================================================

# ==============================================================================
if [ "$0" = "$BASH_SOURCE" ];then
    # direct call to file
    error "$@"
fi # else file is included from another script
# ==============================================================================

#EOF
