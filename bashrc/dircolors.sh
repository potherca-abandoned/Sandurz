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
        printStatus "Using 'osascript -e \"tell application \\\"Terminal\\\"\"' hack" | indent

        # color values are in '{R, G, B, A}' format, all 16-bit unsigned integers (0-65535)

        osascript <<EOF
            tell application "Terminal"
              set targetWindow to window 1

              set background color of targetWindow to {0, 7722, 9941, -10240}
              set normal text color of targetWindow to {28873, 33398, 33872, 65535}
              set bold text color of targetWindow to {33153, 37008, 37008, 65535}
              set cursor color of targetWindow to {28784, 33410, 33924, 65535}
              #set foreground color of targetWindow to {28873, 33398, 33872, 65535}
              # set selection color of targetWindow to {0, 10280, 12593, 65535}
              # set selected text color of targetWindow to {33153, 37008, 37008, 65535}
              # set cursor_text color of targetWindow to {0, 10207, 12694, 65535}
            end tell
EOF

        printStatus 'Using LSCOLORS fallback for OSX' | indent
        # Setting ls colors @see: https://github.com/seebi/dircolors-solarized/issues/10
        export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

    fi
fi

#EOF
