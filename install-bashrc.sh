#!/bin/bash
# set -o nounset # exit on use of an uninitialised variable, same as -u
# set -o errexit # exit on all and any errors, same as -e

# ==============================================================================
# ------------------------------------------------------------------------------
DIR="$( cd "$( dirname "$0" )" && pwd )"	# Current script directory
HOME=$(echo ~)
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
	echo "Creating symlinks for .bashrc, .dircolors and .git files"
	echo "	from $DIR"
	echo "	into $HOME"

	#@TODO: ask the user for input if this is correct...

	ln -s "$DIR/bash_aliases" "$HOME/.bash_aliases" && ln -s "$DIR/bashrc.d" "$HOME/.bashrc.d";
	ln -s "$DIR/git.d" "$HOME/.git.d" && ln -s "$HOME/.git.d/config" "$HOME/.gitconfig"

	ln -s "$DIR/vendor/dircolors/dircolors.ansi-light" "$HOME/.dircolors"
	
	# @FIXME: Using ln failed because of our "can't execute code from drive D:/ problem" using cp for now
	#ln -s --update "$DIR/vendor/git-remote-hg/git-remote-hg" "/usr/local/bin/" && sudo chmod +x '/usr/local/bin/git-remote-hg'
	#@TODO: use https://github.com/felipec/git instead
	#sudo cp --update "$DIR/vendor/git-remote-hg/git-remote-hg" "/usr/local/bin/" && sudo chmod +x '/usr/local/bin/git-remote-hg'
 

	if [ -f "$HOME/.bashrc" ]; then
		echoDebug "Found .bashrc in the home directory"
		BASHRC="$HOME/.bashrc"
	else 
		echo ""
		echo "Did not find a .bashrc file in the home directory."

		if [ -f "/etc/bash.bashrc" ]; then
			#Copy system .bashrc to home
			BASHRC="/etc/bash.bashrc"

			echo ""
			echo "Copying .bashrc"
			echo "	from $BASHRC"
			echo "	to $HOME/.bashrc"
			echo ""

			cp $BASHRC $HOME/.bashrc
		fi

		# @TODO: Make an educated guess at where .bashrc might be hiding?
	fi

	if [ $BASHRC ];then
		# Make sure that .bash_aliases is included from .bashrc
		RESULT=`grep bash_aliases $BASHRC`

		if [ "$RESULT" = "" ];then
			echoDebug "Did not find a reference to .bash_aliases in .bashrc"
			echoDebug "Appending reference of .bash_aliases to .bashrc"
			echo -e "\n# Include .bash_aliases\nif [ -f ".bash_aliases" ]; then\n\t. .bash_aliases\nfi" >> $HOME/.bashrc
		else
			echoDebug "Found reference to .bash_aliases in .bashrc"
		fi

		echoDebug "Calling $BASHRC for inclusion"
		source $BASHRC
	fi
}
# ==============================================================================

runInstall

#EOF
