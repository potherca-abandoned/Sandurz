#!/usr/bin/env bash

if [ "$(dircolors --version 2> /dev/null)" ];then
    eval $(dircolors ~/.dircolors)
else
    source "${HOME}/.common.sh"

    sourceFunction printWarning isMacOS printStatus

    # @TODO: Should the user be notified of the fact that dircolors is available
    # through coreutils which can be installed on mac using brew, etc. ?
    # Or should this (also) be part of the install script?

    printWarning 'dircolors is not installed'

    if [ isMacOS ];then
        printStatus "Using 'osascript -e \"tell application \\\"Terminal\\\"\"' hack" | indent

        # color values are in '{R, G, B, A}' format, all 16-bit unsigned integers (0-65535)

        osascript <<EOF
            tell application "Terminal"
              set targetWindow to window 1

              set background color of targetWindow to {0, 7722, 9941, -10240}
              set normal text color of targetWindow to {28873, 33398, 33872, 65535}
              set bold text color of targetWindow to {33153, 37008, 37008, 65535}
              set cursor color of targetWindow to {28784, 33410, 33924, 65535}

              set the font name of targetWindow to "Inconsolata"
              set the font size of targetWindow to 12

              # set foreground color of targetWindow to {28873, 33398, 33872, 65535}
              # set selection color of targetWindow to {0, 10280, 12593, 65535}
              # set selected text color of targetWindow to {33153, 37008, 37008, 65535}
              # set cursor_text color of targetWindow to {0, 10207, 12694, 65535}
            end tell
EOF
    #osascript -e "tell application \"Terminal\" to set the font name of window 1 to \"$1\""
    #osascript -e "tell application \"Terminal\" to set the font size of window 1 to $2"

        printStatus 'Using LSCOLORS fallback for OSX' | indent
        # Setting ls colors @see: https://github.com/seebi/dircolors-solarized/issues/10
        export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

    fi
fi

#EOF
