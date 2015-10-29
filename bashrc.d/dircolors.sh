#!/usr/bin/env bash

source "${HOME}/.common.sh"

if [ "$(dircolors --version 2> /dev/null)" ];then
    eval $(dircolors ~/.dircolors)
else
    # @TODO: Should the user be notified of the fact that dircolors is available
    # through coreutils which can be installed on mac using brew, etc. ?
    # Or should this (also) be part of the install script?

    sourceFunction printWarning
    sourceFunction isMacOS

    printWarning 'dircolors is not installed'

    if [ isMacOS ];then
        sourceFunction printStatus

        printStatus 'Using LSCOLORS fallback for OSX' | indent

        # @see: https://github.com/seebi/dircolors-solarized/issues/10
        export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
    fi
fi

#EOF
