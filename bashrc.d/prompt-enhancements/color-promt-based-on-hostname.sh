#!/bin/bash

# ==============================================================================
# Color the promt depending on our environment
# ------------------------------------------------------------------------------
function colorPromt {
    hostname=`uname -n`
    
    case "$hostname" in
        *-vre-*)
            # should be a PRODCUTION machine, Color the promt red
            COLOR=41
        ;; 

        *dev*)
            # should be a DEV machine, Color the prompt yellow
            COLOR=43
        ;; 
        
        *ben*) 
            # should be my LOCAL machine, Color the prompt green
            COLOR=42
        ;; 
        
        *)
            # We're no longer in Kansas, Dorothy! Color the promt blue
            COLOR=44
        ;; 
    esac

    PS1="\e[$COLOR;37m$PS1\e[m"
}
colorPromt
# ==============================================================================

