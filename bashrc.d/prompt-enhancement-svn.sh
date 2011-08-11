# ==============================================================================
# Enhance prompt when inside SVN working directories
# 
# Inside SVN working directories this will check for updates after each time you 
# execute a command. If the response from the server is slow, this can cause 
# latency in the prompt cursor appearing. You can disable this by calling the 
# following command from the commandline:
#
# 	toggleSvnPromptDisplayUpdate off
#
# You might also want to change the default setting below...
# ------------------------------------------------------------------------------
if [  -n "$CHECK_REMOTE_SVN" ]; then
	CHECK_REMOTE_SVN=1
fi
# ------------------------------------------------------------------------------

function toggleSvnPromptDisplayUpdate {
	if [ ! -n "$1" -a  "$CHECK_REMOTE_SVN" = "0" ] || [ "$1" = "on" -o "$1" = 1 ]; then
		CHECK_REMOTE_SVN=1;
	else #if [ ! -n "$1" -a "$CHECK_REMOTE_SVN" = "1" ] || [ "$1" = "off" -o "$1" = "0" ]; then
		CHECK_REMOTE_SVN=0;
	fi
}
# ------------------------------------------------------------------------------

function get_svn_revision {

	LOCAL_REVISION=$(svn info  2> /dev/null | grep Revision | cut -c11-)
	
	if [ -n "$LOCAL_REVISION" ]; then
		if [ "$CHECK_REMOTE_SVN" = "1" ]; then

			# REMOTE_REVISION should be written and read from a file stuffed in 
			# the .svn folder and only be refreshed at set intervals (we could 
			# stat the file for a last-checked-date). Users can still use the 
			# toggle, but it would save a whole lot of latency
	
			REMOTE_REVISION=$(svn info -r HEAD | grep -i "Revision" | cut -c11-)

			if [ "$LOCAL_REVISION" = "$REMOTE_REVISION"  ]; then
				# We are up to date, display revisiom number in green
				echo -e  '\E[0;32m'"\033[3m($LOCAL_REVISION) \033[0m"
			else
				# We are out of date, display revisiom number in red
				echo -e  '\E[0;31m'"\033[3m($LOCAL_REVISION) \033[0m"
			fi
		else
			# No update checking is done, display revisiom number in blue
			echo -e  '\E[0;34m'"\033[3m($LOCAL_REVISION) \033[0m"
		fi
	fi

}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
PS1="$PS1\$(get_svn_revision)"
# ==============================================================================

#EOF
