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
function echoDebug() {
    if [ "$DEBUG" != "0" ];then
        echo "--> $@"
    fi
}
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function runInstall() {

    echo ""
    echo "Creating symlinks for .profile, .dircolors and .git files"
    echo "    from $DIR"
    echo "    into $HOME"

    #@TODO: ask the user for input if this is correct...

    ln -s -i "$DIR/bash_aliases" "$HOME/.bash_aliases" && ln -s -i "$DIR/bashrc.d" "$HOME/.bashrc.d";
    ln -s -i "$DIR/git.d" "$HOME/.git.d" && ln -s -i "$HOME/.git.d/config" "$HOME/.gitconfig"

    ln -s -i "$DIR/vendor/dircolors/dircolors.ansi-light" "$HOME/.dircolors"

    #@TODO: use https://github.com/felipec/git instead
    #ln -s -i "$DIR/vendor/git-remote-hg/git-remote-hg" "/usr/local/bin/" && sudo chmod +x '/usr/local/bin/git-remote-hg'

	sProfilePath="$HOME/.profile"
    if [ -f "${sProfilePath}" ]; then
        echoDebug "Found .profile in the home directory"
    else
        echo -e "Did not find a .profile file in the home directory.\n"
        echo -e "Creating empty .profile file in ${HOME}\n"

        echo '' > "${sProfilePath}"
    fi

    # Make sure that .bash_aliases is included from .profile
    sResult="$(grep bash_aliases $sProfilePath || echo 1)"

    if [ "${sResult}" = "1" ];then
        echoDebug "Did not find a reference to .bash_aliases in .profile"
        echoDebug "Appending reference of .bash_aliases to .profile"
        echo -e "\n# Include .bash_aliases\nif [ -f ".bash_aliases" ]; then\n\t. .bash_aliases\nfi" >> $HOME/.profile
    else
        echoDebug "Found reference to .bash_aliases in .profile"
    fi

    echoDebug "Calling $sProfilePath for inclusion"
    source $sProfilePath
}
# ==============================================================================

runInstall

#EOF
