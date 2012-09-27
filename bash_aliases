# ==============================================================================
# Color the promt depending on our environment
# ------------------------------------------------------------------------------
function colorPromt {
    hostname=`uname -n`
    
    case "$hostname" in
        *-vre-*)
            # should be a PRODCUTION machine, Color the promt red
            COLOR=41
        ;; 

        *dev*)
            # should be a DEV machine, Color the prompt yellow
            COLOR=43
        ;; 
        
        *ben*) 
            # should be my LOCAL machine, Color the prompt green
            COLOR=42
        ;; 
        
        *)
            # We're no longer in Kansas, Dorothy! Color the promt blue
            COLOR=44
        ;; 
    esac

    PS1="\e[$COLOR;37m$PS1\e[m"
}
colorPromt
# ==============================================================================

# ==============================================================================
# To keep this file simple and clean, we put more complex scripts in .bashrc.d 
# and include all the files from that directory from here
# ------------------------------------------------------------------------------
HERE=$(pwd)
cd ~
for FILE in .bashrc.d/*; 
do
	source $FILE
done
cd $HERE
# ==============================================================================



# ==============================================================================
# Yes, I know, but I grew up on DOS and some habits just never die, mmmkay?
# ------------------------------------------------------------------------------
alias cls='clear && ls'
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
alias del='/bin/rm'
alias rm='mv -t ~/.local/share/Trash/files/'
# ==============================================================================


# ==============================================================================
# Sometimes I just like to go "back"
# ------------------------------------------------------------------------------
alias back='cd -'
# ==============================================================================


# ==============================================================================
# Restore the $ we stripped of earlier
# ------------------------------------------------------------------------------
PS1="$PS1\$ "
# ==============================================================================

# ==============================================================================
# Add an "alert" alias for long running commands.  Use like so:
# ------------------------------------------------------------------------------
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# ==============================================================================



#EOF
