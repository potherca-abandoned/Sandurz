#!/usr/bin/env bash
# ==============================================================================
#                   
# ------------------------------------------------------------------------------
# This script will try to build check wether there have been new or changed .yml
# files in a directory. It achieves this by searching for '.dev' files, looking
# if there is a mirror file "sans" .dev extension and outputting the diff 
# between both.
# 
# It takes one parameter, the path to the folder to check files in.
# ------------------------------------------------------------------------------
# The following ExitCodes are used:
#
# 64  : General Error
#
# 65 : Not enough params given
# 66 : The given path is not a directory
#
# ==============================================================================


# ==============================================================================
#                               CONFIG VARS
# ------------------------------------------------------------------------------
set -o nounset # exit on use of an uninitialised variable, same as "set -u"
set -o errexit # exit on all and any errors, same as -e

declare g_sFolderPath
# ==============================================================================


# ==============================================================================
#                            APPLICATION VARS
# ------------------------------------------------------------------------------
declare -i g_iExitCode=0
declare -i g_iErrorCount=0
declare -a g_aErrorMessages

readonly T_BOLD=`tput bold`
readonly T_NORMAL=`tput sgr0`
readonly T_ERROR=`tput setab 1`   # red background

# ==============================================================================

################################################################################
#                              UTILITY FUNCTIONS
################################################################################
# ==============================================================================
function handleParams() {
# ------------------------------------------------------------------------------
    iExitCode=${g_iExitCode}
    
    if [ ! "$#" -eq 1 ];then
        error 'This script expects one argument: the path to the folder to check.'
        iExitCode=65
    elif [ ! -d "$1" ];then
        error "The given path is not a directory: '$4'"
        iExitCode=66
    else
        g_sFolderPath="$1"
    fi
    
    return ${iExitCode}
}
# ==============================================================================

################################################################################
#                           FUNCTIONS
################################################################################
# ==============================================================================
function printHeader() {
# ------------------------------------------------------------------------------
    p_sTitle=$1

    echo ''
    echo '================================================================='
    echo " ${T_BOLD}${p_sTitle}${T_NORMAL}"
    echo '-----------------------------------------------------------------'
}
# ==============================================================================

# ==============================================================================
function runCheck() {
# ------------------------------------------------------------------------------
    aFileList=`find "$g_sFolderPath" -name '*.dev'`
    
    for t_sFile in ${aFileList}; do
        sFilename="${t_sFile%.*}"

        if [ ! -f "${sFilename}" ];then
            printHeader ${sFilename}
            echo "  --${T_ERROR} There is no mirror file ${T_NORMAL}"
        else
            if [ "`diff --brief  -- ${t_sFile} ${sFilename}; `" ];then
            printHeader ${sFilename}
                sOptions='--ignore-space-change --ignore-all-space --ignore-blank-lines'
                echo -e "`diff ${sOptions} -- ${t_sFile} ${sFilename}`"
            fi
        fi
    done    
    echo '================================================================='
}
# ==============================================================================

################################################################################
#                            RUN SCRIPT
################################################################################
handleParams $@
g_iExitCode=$?

if [ ${g_iExitCode} -eq 0 ];then
    runCheck
fi

if [ ! ${#g_aErrorMessages[*]} -eq 0 ];then
    outputErrorMessages ${g_aErrorMessages[*]}
else
    echo 'Done.'
fi

exit ${g_iExitCode}


#EOF
