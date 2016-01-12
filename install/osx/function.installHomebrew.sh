#!/usr/bin/env bash

set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

source "${HOME}/.common.sh"

sourceFunction indent isInstalled isMacOS printStatus printTopic

#==============================================================================#
# Install Hombrew
#------------------------------------------------------------------------------#
function installHomebrew () {
    local readonly sInstallUrl='https://raw.githubusercontent.com/Homebrew/install/master/install'

    printTopic 'Installing Brew'

    if [[ isMacOs ]];then
        if isInstalled 'brew';then
            printStatus 'Brew is already installed'
        else
            printStatus 'Downloading and running the Homebrew install script'
            ruby -e "$(curl -fsSL ${sInstallUrl})" | indent
        fi

        printStatus 'Checking Homebrew for potential problems'
        brew doctor | indent

        printStatus 'Checking Homebrew is up to date'
        brew update | indent

        printStatus 'Upgrading any already-installed formulae'
        brew upgrade --all | indent
    else
        printStatus 'Not on OSX. Not installing Brew.'
    fi
}
#==============================================================================#


#==============================================================================#
if [ "${0}" = "${BASH_SOURCE}" ];then
    # direct call to file
    installBrew
fi # else file is included from another script
#==============================================================================#

#EOF
