#!/usr/bin/env bash

# ==============================================================================
# This script provides a general mechanism to load various functions from the
# `functions` directory. It should be symlinked to the `$HOME` directory for
# easy usage.
#
# To load any function from a script, first source this file and then call
# `sourceFunction` with the name of the function to be loaded.
#
# For example, to load the `foo` function the following should be used:
#
#     source "${HOME}/.common.sh" && sourceFunction foo
# ==============================================================================

# ==============================================================================
function findRootDirectory() {

    local sScriptPath

    # Find out where we are located, following symlinks as the install script
    # symlinks the `common.sh` file to `~/.common.sh`
    if [ -f "${HOME}/.common.sh" ];then
        sScriptPath=$(readlink "${HOME}/.common.sh")
    elif [ -n "${BASH_SOURCE}" ]; then
        sScriptPath="${BASH_SOURCE}"
    elif [ -n "$ZSH_VERSION" ]; then
        setopt function_argzero
        sScriptPath="${0}"
    elif eval '[[ -n ${.sh.file} ]]' 2>/dev/null; then
        eval 'sScriptPath=${.sh.file}'
    else
        sOpenFile="$(lsof -F n -p $$ | sed -n '$s/^n//p')"
        if [ -n "$sOpenFile" ]; then
            sScriptPath="${sOpenFile}"
        else
            echo 1>&2 "Could not reliably determine script location. Aborting"
            exit 64
        fi
    fi

    sRootDirectory="$(dirname $(dirname ${sScriptPath}))"

    echo "${sRootDirectory}"
}
# ==============================================================================

# ==============================================================================
function sourceFunction() {
    local sFunction
    local sSourceFile

    local readonly sFunctionsDirectory="$(findRootDirectory)/functions/"

    for sFunction in "$@";do
        sSourceFile="${sFunctionsDirectory}/function.${sFunction}.sh"

        if [ -f "$sSourceFile" ]; then
            source "${sSourceFile}"
        else
            source "${sFunctionsDirectory}/function.printError.sh"
            printError "Could not find file for command '${sFunction}'"
        fi
    done
}
# ==============================================================================

#EOF
