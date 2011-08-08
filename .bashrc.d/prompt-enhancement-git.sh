# ==============================================================================
# Enhance prompt when inside git repos
# http://railstips.org/blog/archives/2009/02/02/bedazzle-your-bash-prompt-with-git-info/
# ------------------------------------------------------------------------------
function parse_git_branch {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	# Display branch name in blue
	echo -e  '\E[0;34m'"\033[1m("${ref#refs/heads/}") \033[0m"
}
# ------------------------------------------------------------------------------
PS1="$PS1\$(parse_git_branch)"
# ==============================================================================

#EOF
