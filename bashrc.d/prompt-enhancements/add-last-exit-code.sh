#!/usr/bin/env bash

# ==============================================================================
#
# ------------------------------------------------------------------------------
function addLastErrorCode {
    local iErrorCode=$?
    local sStatusMessage

    if [[ ${iErrorCode} -ne 0 ]]; then
        iColor=31
        sStatusMessage="✘:${iErrorCode}"

        echo -ne "\033[0;${iColor}m${sStatusMessage}\033[0m ";
    fi
}

function addLastExitCode {
    local iErrorCode=$?
    local sStatusMessage

    if [[ ${iErrorCode} -eq 0 ]]; then
        iColor=32
        sStatusMessage="✔"
        #echo -ne "\033[0;32m${iErrorCode}\033[0m";
    else
        iColor=31
        sStatusMessage="✘:${iErrorCode}"
        #echo -ne "\033[0;31m${iErrorCode}\033[0m";
    fi

    echo -ne "\033[0;${iColor}m${sStatusMessage}\033[0m";
}
# ==============================================================================

#EOF
