#!/usr/bin/env bash

# ==============================================================================
function sourceFunction() {
    sFunction=$1

    # Find out where we are located, following symlinks as the install script
    # symlinks the `common.sh` file to `~/.common.sh`
    sScriptPath=$(readlink "${HOME}/.common.sh")

    sFunctionsDirectory="$(dirname ${sScriptPath})"
    sSourceFile="${sFunctionsDirectory}/function.${sFunction}.sh"

    if [ -f "$sSourceFile" ]; then
        source "${sSourceFile}"
    else
        source "${sFunctionsDirectory}/function.printError.sh"
        printError "Could not find file for command '${sFunction}'"
    fi
}

#EOF
