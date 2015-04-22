#!/usr/bin/env bash

if [ "$(dircolors --version 2> /dev/null)" ];then
    eval `dircolors ~/.dircolors`
else
    echo 'dircolors is not installed' | indent
    # @TODO: Should the user be notified of the fact that dircolors is available
    # through coreutils which can be installed on mac using brew, etc. ?
fi

#EOF
