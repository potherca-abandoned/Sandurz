#!/usr/bin/env bash

if [ "$(dircolors --version > /dev/null || echo 1)" == "1" ];then
    echo 'dircolors is not installed'
    # @TODO: Should the user be notified of the fact that dircolors is available
    # through coreutils which can be installed on mac using brew, etc. ?
else
    eval `dircolors ~/.dircolors`
fi

#EOF
