#!/usr/bin/env bash

# ==============================================================================
# Replaces the Prompt with a host name coloured depending on the environment
# ------------------------------------------------------------------------------
function colorPromptBasedOnHostname() {
    local sColor
    local sHostName=`uname -n`

    case "$sHostName" in
        *-vre-*)
            # should be a PRODCUTION machine, Color the promt red
            sColor=41
        ;;

        *dev*)
            # should be a DEV machine, Color the prompt yellow
            sColor=43
        ;;

        *ben*)
            # should be my LOCAL machine, Color the prompt green
            sColor=42
        ;;

        *)
            # We're no longer in Kansas, Dorothy! Color the promt blue
            sColor=44
        ;;
    esac

    echo -en "\033[${sColor}m$(whoami)@${sHostName}\033[00m"
}
# ------------------------------------------------------------------------------
#PROMPT_COMMAND=colorPrompt
# ==============================================================================

