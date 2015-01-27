
# ==============================================================================
# To keep this file simple and clean, we put more complex scripts in .bashrc.d 
# and include all the files from that directory from here
# ------------------------------------------------------------------------------
function includeFolder {
    HERE=$(pwd)
    cd ~
    for FILE in "$1/*";
    do
        if [ -d "$FILE" ];then
            includeFolder "$1/$FILE"
        else
    	    source $FILE
	    fi
    done
    cd $HERE
}
# ==============================================================================

includeFolder '.bashrc.d'

#EOF
