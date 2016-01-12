#!/usr/bin/env bash
# ==============================================================================
# Fancy PWD display function
# ------------------------------------------------------------------------------
# The home directory (HOME) is replaced with a ~ and only the last iMaxLength
# characters of the PWD are displayed. Leading partial directory names are
# striped off
#
# EXAMPLES:
#
# if USER=me
#       /home/me/stuff          -> ~/stuff
#
# if iMaxLength=20
#       /usr/share/big_dir_name -> ../share/big_dir_name
# ------------------------------------------------------------------------------
function shorten_pwd {

    # How many characters of the $PWD should be kept
    local iMaxLength=25

    # Indicate that there has been dir truncation
    local sTruncateSymbol=".."
    local sDirectory="${PWD##*/}"
    local iMaxLength=$(( ( iMaxLength < ${#sDirectory} ) ? ${#sDirectory} : iMaxLength ))
    local sNewPwd="${PWD/#$HOME/~}"
    local iPwdOffset=$(( ${#sNewPwd} - iMaxLength ))

    if [ "${iPwdOffset}" -gt "0" ];then
        sNewPwd="${sNewPwd:$iPwdOffset:$iMaxLength}"
        sNewPwd="${sTruncateSymbol}/${sNewPwd#*/}"
    fi

    echo "${sNewPwd}"
}
# ------------------------------------------------------------------------------
#PS1="\$(shorten_pwd)$PS1"
# ==============================================================================

#EOF
