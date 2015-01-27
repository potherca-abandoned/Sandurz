# ==============================================================================
# Add an "alert" alias for long running commands.  Use like so:
# ------------------------------------------------------------------------------
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# ==============================================================================



# ==============================================================================
# Aliasses for popular destinations
# ------------------------------------------------------------------------------
alias playground="cd ~/Dropbox/www/Playground/$1"
# ==============================================================================



# ==============================================================================
# Yes, I know, but I grew up on DOS and some habits just never die, mmmkay?
# ------------------------------------------------------------------------------
alias cls='clear && ls'
# ==============================================================================



# ==============================================================================
# Lets make ls respond in a way more to my liking.
# ------------------------------------------------------------------------------
# -l = use a long listing format
# -X = sort alphabetically by entry extension
alias ls='ls -lX --color=auto --group-directories-first --human-readable --indicator-style=slash'
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
alias rm='mv --target-directory=~/.local/share/Trash/files/'
# ==============================================================================



# ==============================================================================
# Sometimes I just like to go "back"
# ------------------------------------------------------------------------------
alias back='cd -'
# ==============================================================================


    
#EOF
