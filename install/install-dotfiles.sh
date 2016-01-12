#!/usr/bin/env bash

set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

# @FIXME: Anything that does not symlink/install DOTFILES should be moved to a separate install script
# (Especially since *this* script should be called from an  parent "install" script that also installs other tools onto a new system (NIX or OSX supported, thusfar)


# ==============================================================================
# ------------------------------------------------------------------------------
# Get the current script directory
readonly sScriptDirectory="$( unset CDPATH && cd $( dirname $0 )/../ && pwd -P )"
DEBUG=1
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function symlinkCommonFunctionsFile() {
    echo 'Creating symlinks for common Bash utility functions script'

    #@TODO: ask the user for input if this is correct...

    ln -s -i "${sScriptDirectory}/functions/common.sh" "${HOME}/.common.sh" || true
}
# ------------------------------------------------------------------------------


# ==============================================================================
# ------------------------------------------------------------------------------
function importUtilities() {
  source "${sScriptDirectory}/functions/common.sh"

  sourceFunction indent
  sourceFunction printTopic
  sourceFunction printStatus
  sourceFunction printWarning
  #sourceFunction printDebug
  sourceFunction isMacOS
}
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function symlinkBashFiles() {
    printTopic 'Creating symlinks for Bash enhancements'

    #@TODO: ask the user for input if this is correct...

    ln -s -i "${sScriptDirectory}/bash_aliases" "${HOME}/.bash_aliases" \
        && ln -s -i "${sScriptDirectory}/bashrc" "${HOME}/.bashrc.d" || true
}
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function symlinkGitFiles() {
    printTopic 'Creating symlinks for .git files'

    #@TODO: ask the user for input if this is correct...
    echo "sScriptDirectory ${sScriptDirectory}"
    ln -s -i "${sScriptDirectory}/git" "${HOME}/.git.d" \
        && ln -s -i "${HOME}/.git.d/config" "${HOME}/.gitconfig" || true
}
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function symlinkDircolors() {
    printTopic 'Creating symlinks for dircolor files'

    # ------------------------------------------------------------------------------
    # dircolors is available through coreutils which can be installed with brew
    # @TODO: Prompt the user to install coreutils if not available
    # ------------------------------------------------------------------------------

    sTheme="${sScriptDirectory}/vendor/dircolors/dircolors.ansi-light"

    #@TODO: ask the user for input if this is correct...
    ln -s -i "${sTheme}" "${HOME}/.dircolors" || true
}
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function validateBashCompletion() {
    printTopic 'Validating bash-completion is installed'

    if [ -d /etc/bash_completion ] || [ -d /usr/local/etc/bash_completion.d ];then
        printStatus 'Bash completion is already installed'
    else
        printStatus 'Bash completion is not installed'
        if [ "$(brew --version > /dev/null 2>&1 && echo 1)" == "1" ];then
            printStatus "Using brew to install bash-completion"
            brew install bash-completion
        elif [ "$(apt-get --version > /dev/null && echo 1)" == "1" ];then
            printStatus 'Using apt-get to install bash-completion'
            sudo apt-get install bash-completion
        else
            printWarning 'Could not install bash-completion. Please install manually.'
        fi
    fi
}
# ==============================================================================


# ==============================================================================
# Make sure that .bash_aliases is included from .bash_profile
# ------------------------------------------------------------------------------
function validateBashAliases() {
    printTopic 'Validating .bash_aliases is included from .bash_profile'

    sProfilePath="${HOME}/.bash_profile"
    if [ -f "${sProfilePath}" ]; then
        printStatus "Found .bash_profile in the home directory"
    else
        printStatus "Did not find a .bash_profile file in the home directory."
        printStatus "Creating .bash_profile file in ${HOME}\n"

        echo '' > "${sProfilePath}"
    fi

    sResult="$(grep bash_aliases $sProfilePath || echo 1)"

    if [ "${sResult}" = "1" ];then
        printStatus "Did not find a reference to .bash_aliases in .bash_profile"
        printStatus "Appending reference of .bash_aliases to .bash_profile"

        echo -e "\n# Include .bash_aliases\nif [ -f '.bash_aliases' ]; then\n\t. .bash_aliases\nfi" >> $HOME/.bash_profile
    else
        printStatus 'Found reference to .bash_aliases in .bash_profile'
    fi
}
# ------------------------------------------------------------------------------


# ==============================================================================
# ------------------------------------------------------------------------------
function sourceFiles() {
    printTopic "Calling ${sProfilePath} for inclusion"
    source "${sProfilePath}"
}
# ------------------------------------------------------------------------------


# ==============================================================================
# ------------------------------------------------------------------------------
function runInstall() {

    echo 'Installing files'
    echo "from $sScriptDirectory"
    echo "into $HOME"

    symlinkCommonFunctionsFile
    importUtilities

    # ------------------------------------------------------------------------------
    if [[ "${BASH_VERSION:0:1}" == 3 ]];then
        if [[ isMacOS ]];then
            # @CHECKME: Install coreutils? If coreutils is used in scripts, that would mean
            #           those scripts can _only_ be used by others who also have coreutils installed.
            #           that might not be a desirable situation...
            printWarning "Older version of Bash is installed: ${BASH_VERSION%%(*}"
        #elif @TODO: What else? What if we *are* on an older Linux system?
        fi
    fi
    # @TODO: Check bash version and (especially when on OSX) install (newer) GNU version?
    #        This would require `brew`.
    # ------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------
    #@TODO: use https://github.com/felipec/git instead
    #ln -s -i "${sScriptDirectory}/vendor/git-remote-hg/git-remote-hg" "/usr/local/bin/" && sudo chmod +x '/usr/local/bin/git-remote-hg'
    # ------------------------------------------------------------------------------

    # @TODO: properly run `cd "${sScriptDirectory}" && git submodule init && git submodule update` to install vendor scripts
    symlinkBashFiles
    symlinkGitFiles
    symlinkDircolors

    validateBashAliases
    validateBashCompletion

    sourceFiles
}
# ==============================================================================

runInstall
echo 'Done.'

#EOF
