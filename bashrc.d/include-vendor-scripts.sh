#!/usr/bin/env bash


function includeVendorScripts() {
    source "${HOME}/.common.sh"

    # ==============================================================================
    # All the scripts in the array below will be loaded when this script is called
    # ------------------------------------------------------------------------------
    aVendorScript[1]='git-flow-completion/git-flow-completion.bash'
    aVendorScript[2]='heroku_bash_completion/heroku_bash_completion.sh'
    aVendorScript[3]='symfony2-autocomplete/symfony2-autocomplete.bash'
    # ==============================================================================


    # ==============================================================================
    # Find out where we are located, following symlinks as the install script
    # symlinks the `bashrc.d/` directory to `~/.bashrc.d/`
    # ------------------------------------------------------------------------------
    if [ -n "${BASH_SOURCE}" ]; then
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
    # ==============================================================================


    # ==============================================================================
    # Source all the files in the array from the vendor directory
    # ------------------------------------------------------------------------------
    sVendorDir="$(dirname ${sScriptPath})/../vendor"

    sourceFunction indent
    sourceFunction printTopic
    sourceFunction printStatus

    printTopic "Including vendor scripts" | indent
    for sFile in "${aVendorScript[@]}"
    do
        printStatus "${sFile}" | indent
        source "${sVendorDir}/${sFile}" | indent
    done
    # ==============================================================================
}

includeVendorScripts

#EOF
