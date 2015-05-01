#!/usr/bin/env bash

source "${HOME}/.common.sh"

sourceFunction indent
sourceFunction printStatus

if [ -d /etc/bash_completion ];then
    source /etc/bash_completion && printStatus 'Bash completion enabled' | indent
elif [ -f $(brew --prefix)/etc/bash_completion ]; then
    # There's an unbound variable in the bash_completion script called
    # BASH_COMPLETION_DEBUG so we need to temporarily disable errexit
    set +u
    . $(brew --prefix)/etc/bash_completion && printStatus 'Bash completion enabled' | indent
    set -u
else
    sourceFunction printWarning

    printWarning 'Bash completion is not installed'
fi

#EOF
