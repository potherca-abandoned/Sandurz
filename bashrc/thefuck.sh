#!/usr/bin/env bash
# ==============================================================================
# Corrects previous console command.
# ------------------------------------------------------------------------------

source "${HOME}/.common.sh"
sourceFunction isInstalled printWarning

if isInstalled 'thefuck';then
    eval "$(thefuck --alias)"
else
    printWarning 'The correction script "thefuck" is not installed'
fi
# ==============================================================================

#EOF
