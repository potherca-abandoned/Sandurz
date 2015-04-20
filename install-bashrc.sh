#!/usr/bin/env bash

set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

# ==============================================================================
# ------------------------------------------------------------------------------
DIR="$( cd "$( dirname "$0" )" && pwd )"    # Current script directory
DEBUG=1
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function indent() {
    c='s/^/       /'
    case $(uname) in
        Darwin) sed -l "$c";;
        *)      sed -u "$c";;
    esac
}
function topic() {
    echo
    echo "=====> $*"
}

function status() {
    echo "-----> $*"
}

function warning() {
  echo
  echo " !     WARNING: $*" | indent no_first_line_indent
  echo
}

function debug() {
    if [ "$DEBUG" != "0" ];then
        echo "[DEBUG] $*" >&1
    fi
}
# ==============================================================================

# ==============================================================================
# ------------------------------------------------------------------------------
function runInstall() {

    # ------------------------------------------------------------------------------
    topic 'Creating symlinks for .profile, .dircolors and .git files'
    echo "from $DIR" | indent
    echo "into $HOME" | indent

    #@TODO: ask the user for input if this is correct...

    ln -s -i "$DIR/bash_aliases" "$HOME/.bash_aliases" && ln -s -i "$DIR/bashrc.d" "$HOME/.bashrc.d";
    ln -s -i "$DIR/git.d" "$HOME/.git.d" && ln -s -i "$HOME/.git.d/config" "$HOME/.gitconfig"
    ln -s -i "$DIR/vendor/dircolors/dircolors.ansi-light" "$HOME/.dircolors" || echo -n ''
    # ------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------
    #@TODO: use https://github.com/felipec/git instead
    #ln -s -i "$DIR/vendor/git-remote-hg/git-remote-hg" "/usr/local/bin/" && sudo chmod +x '/usr/local/bin/git-remote-hg'
    # ------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------
    # Make sure that .bash_aliases is included from .profile
    # ------------------------------------------------------------------------------
    topic 'Validating .bash_aliases is included from .profile'

    sProfilePath="$HOME/.profile"
    if [ -f "${sProfilePath}" ]; then
        status "Found .profile in the home directory"
    else
        status "Did not find a .profile file in the home directory."
        status "Creating .profile file in ${HOME}\n"

        echo '' > "${sProfilePath}"
    fi

    sResult="$(grep bash_aliases $sProfilePath || echo 1)"

    if [ "${sResult}" = "1" ];then
        status "Did not find a reference to .bash_aliases in .profile"
        status "Appending reference of .bash_aliases to .profile"

        echo -e "\n# Include .bash_aliases\nif [ -f ".bash_aliases" ]; then\n\t. .bash_aliases\nfi" >> $HOME/.profile
    else
        status "Found reference to .bash_aliases in .profile"
    fi
    # ------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------
    topic 'Validating bash-completion is installed'

    if [ -d /etc/bash_completion ] || [ -d /usr/local/etc/bash_completion.d ];then
        status 'Bash completion is already installed'
    else
        status 'Bash completion is not installed'
        if [ "$(brew --version > /dev/null && echo 1)" == "1" ];then
            status "Using brew to install bash-completion"
            brew install bash-completion
        elif [ "$(apt-get --version > /dev/null && echo 1)" == "1" ];then
            status 'Using apt-get to install bash-completion'
            sudo apt-get install bash-completion
        else
            warning 'Could not install bash-completion. Please install manually.'
        fi
    fi
    # ------------------------------------------------------------------------------


    # ------------------------------------------------------------------------------
    topic "Calling $sProfilePath for inclusion"
    source "${sProfilePath}"
    # ------------------------------------------------------------------------------
}
# ==============================================================================

runInstall

#EOF
