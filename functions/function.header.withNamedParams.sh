#!/usr/bin/env bash
# ==============================================================================
#               Echo a "header" with a given string centered                   #
# ------------------------------------------------------------------------------
# If you want to put the header in a variable to re-use it, instead of echo it,
# you should use process substitution: VAR=$(header "YOUR WORD HERE")
#
# @TODO: Add text decoration as an optional parameter
# @TODO: make the header length an optional parameter
# @TODO: Validate that the given string is shorter than the iRulerLength
# ==============================================================================
function header {

    local iRulerLength=80

    local sBackgroundColor="BLACK"
    local sForegroundColor="WHITE"
    local sStyle="NORMAL"

#    while getopts "b(background):c(color):s(style):h(help)" PARAMETER; do
    while getopts ":b:c:s:h" PARAMETER; do

            case "$PARAMETER" in
                b)
                    sBackgroundColor="$OPTARG"
                ;;

                c)
                    sForegroundColor="$OPTARG"
                ;;

                s)
                    sStyle="$OPTARG"
                ;;

                h)
                    echo "Usage: @TODO"
                    exit
                ;;

                *|\?)
                    echo "Unknown argument: $OPTARG "
                ;;

                :)
                    echo "Argument requires a value: $OPTARG "
                ;;
            esac
    done
    shift $(($OPTIND - 1))

    # Split color on : so background can be set as well
    #    local POS=`expr index "$2" C:`
    #    if [ $POS -eq 0 ];then
    #        local sForegroundColor=$2
    #    else
    #        local sForegroundColor=${2%:*}
    #        local sBackgroundColor=${2#*:}
    #    fi

    local iSringLength=${#1}

    # set text color
    case "${sForegroundColor}" in
        white|WHITE)
            sForegroundColor="[1m"  # BOLD TEXT
        ;;

        black|BLACK)
            sForegroundColor="[30m" # BLACK TEXT
        ;;

        red|RED)
            sForegroundColor="[31m" # RED TEXT
        ;;

        green|GREEN)
            sForegroundColor="[32m" # GREEN TEXT
        ;;

        yellow|YELLOW)
            sForegroundColor="[33m" # YELLOW TEXT
        ;;

        blue|BLUE)
            sForegroundColor="[34m" # BLUE TEXT
        ;;

        purple|PURPLE)
            sForegroundColor="[35m" # PURPLE TEXT
        ;;

        cyan|CYAN)
            sForegroundColor="[36m" # CYAN TEXT
        ;;

        grey|gray|GREY|GRAY)
            sForegroundColor="[37m" # WHITE TEXT
        ;;

        *)
            echo "Unknown color: ${sForegroundColor}" >&2
        ;;
    esac


    # set background color
    if [ ! -z "$sBackgroundColor" ]; then
        case "$sBackgroundColor" in

            white|gray|grey|WHITE|GRAY|GREY)
                sBackgroundColor="[47m" # GRAY BACKGROUND
            ;;

            black|BLACK)
                sBackgroundColor="[40m" # BLACK BACKGROUND
            ;;

            red|RED)
                sBackgroundColor="[41m" # RED BACKGROUND
            ;;

            green|GREEN)
                sBackgroundColor="[42m" # GREEN BACKGROUND
            ;;

            yellow|YELLOW)
                sBackgroundColor="[43m" # YELLOW BACKGROUND
            ;;

            blue|BLUE)
                sBackgroundColor="[44m" # BLUE BACKGROUND
            ;;

            purple|PURPLE)
                sBackgroundColor="[45m" # PURPLE BACKGROUND
            ;;

            cyan|CYAN)
                sBackgroundColor="[46m" # CYAN BACKGROUND
            ;;

        *)
            echo "Unknown color: ${sBackgroundColor}" >&2
        ;;
        esac
    fi

#    local DECORATION=$3
#                sForegroundColor="[1m" # BOLD TEXT
#                sForegroundColor="[4m" # UNDERSCORED TEXT
#                sForegroundColor="[8m" # NO TEXT
#                sForegroundColor="[9m" # STRIKETHROUGH


    local sBuffer
    if [ "${iRulerLength}" -gt 0 ];then
        local sPart1=$(((${iRulerLength} - ${iSringLength})/2))
        local sPart2=$((${iRulerLength} - ${iSringLength} - ${sPart1}))

        local TMP1=$(printf "%"$sPart1"s")
        local TMP2=$(printf "%"$sPart2"s")

        sBuffer="[8m${sBackgroundColor}"${TMP1// /_}"[0m${sBackgroundColor}${sForegroundColor}${1}[0m${sBackgroundColor}[8m"${TMP2// /_}"[0m"
    else
        sBuffer="[0m${sBackgroundColor}${sForegroundColor}${1}[0m"
    fi

    echo -e "${sBuffer}";

}
# ==============================================================================

if [ "$0" = "$BASH_SOURCE" ];then
    # direct call to file
    header "$@"
fi # else file is included from another script

# ==============================================================================

#EOF
