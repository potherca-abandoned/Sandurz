source "${HOME}/.common.sh"

sourceFunction sourceFolder

# ==============================================================================
# To keep this file simple and clean, we put more complex scripts in `.bashrc.d`
# and include all the files from that directory from here
# ------------------------------------------------------------------------------
sDirectory="${HOME}"
sourceFolder "$sDirectory/.bashrc.d/"
# ==============================================================================

#PS1="$PS1\$(parse_svn_branch)\$(get_svn_revision)"
# use [\!] to see the history number of this command
# use [\v] to see the version of bash
# For more options see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html

# Reset the prompt
PS1=""

# Add enhancements
PS1="$PS1\$(addLastErrorCode)"
PS1="$PS1\$(colorPromptBasedOnHostname)"
PS1="$PS1:\$(shorten_pwd)"
PS1="$PS1\$(parse_git_branch)"

# Restore the "$"
PS1="$PS1 \$ "

#EOF

