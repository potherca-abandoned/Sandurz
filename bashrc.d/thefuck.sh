#!/usr/bin/env bash
# ==============================================================================
# Corrects previous console command.
# ------------------------------------------------------------------------------

source "${HOME}/.common.sh"
sourceFunction isInstalled

if isInstalled 'thefuck';then
    eval "$(thefuck --alias)"
else
    sourceFunction printWarning
    printWarning 'thefuck (correction script) is not installed'
fi
# ==============================================================================

#EOF
