#!/usr/bin/env bash
# ==============================================================================
#
#
#
# ==============================================================================

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/function.error.sh"

# ==============================================================================
# Execute a given command, catching it's output and piping that to error() if
# the given command fails. Optionally an error message can be given.
# ------------------------------------------------------------------------------
function execute() {
    echo "${@}" >&1
    #@FIXME: Add option to do a dry-run
    #@FIXME: Add option not to output the command
    #@FIXME: Add option to hide the output
    sCommand="${1}"
    shift
    sOutput=$(${sCommand} ${@} 2>&1) || error "${2-}\n${sOutput}"
}
# ==============================================================================

if [ "${0}" = "${BASH_SOURCE}" ];then
    # direct call to file
    execute "$@"
    if [ ! ${#g_aErrorMessages[*]} -eq 0 ];then
        echo -e "\nErrors occurred:\n ${g_aErrorMessages[*]}" >&2
    else
        echo 'Done.'
    fi

    exit ${g_iExitCode}
fi # else file is included from another script

#EOF
