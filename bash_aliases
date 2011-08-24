# ==============================================================================
# To keep this file simple and clean, we put more complex scripts in .bashrc.d 
# and include all the files from that directory from here
# ------------------------------------------------------------------------------
HERE=$(pwd)
cd ~
for FILE in .bashrc.d/*; 
	do	. $FILE
done
cd $HERE
# ==============================================================================



# ==============================================================================
# Yes, I know, but I grew up on DOS and some habits just never die, mmmkay?
# ------------------------------------------------------------------------------
alias cls='clear'
# ==============================================================================



# ==============================================================================
# Lets make ls respond in a way more to my liking.
# ------------------------------------------------------------------------------
alias ls='ls -hlpX  --group-directories-first --color=auto'
# ==============================================================================



# ==============================================================================
# To help me not accidentally delete important stuff we just move it to the 
# trash can. sudo rm will still kill you though. If you need more controll use 
# trash-cli @see http://code.google.com/p/trash-cli/wiki/Download
#
# The only downsides to this is that directories are moved indiscrimanately 
# (meanig, without specifying them using the -d flag).
# ------------------------------------------------------------------------------
alias rm="mv -t ~/.local/share/Trash/files/"
# ==============================================================================



# ==============================================================================
# Restore the $ we stripped of earlier
# ------------------------------------------------------------------------------
#PS1="$PS1\$ "
# ==============================================================================



#EOF
