#!/usr/bin/env bash

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/function.message.sh"

# ==============================================================================
function printRuler() {
# ------------------------------------------------------------------------------
    local sRuler
    local sCharacter

    case $1 in
        1)
            sCharacter='##'
        ;;
        2)
            sCharacter='=='
        ;;
        3)
            sCharacter='--'
        ;;
        4)
            sCharacter='- '
        ;;
        5)
            sCharacter='..'
        ;;
        6)
            sCharacter='. '
        ;;
        *)
            sCharacter=''
        ;;
    esac

    sRuler=$(printf -- "${sCharacter}%.0s" {1..40})

    message "${sRuler}"
}
# ==============================================================================


# ==============================================================================
if [ "${0}" = "${BASH_SOURCE}" ];then
    # direct call to file
    printRuler "$@"
fi # else file is included from another script
# ==============================================================================

#EOF
