
# ==============================================================================
# Alias for my most popular destination
# ------------------------------------------------------------------------------
alias playground='function cdToPlayground() { cd "$HOME/Dropbox/www/playground/${1:-}"; result=$?; unset -f cdToPlayground; return $result; }; cdToPlayground'
# ------------------------------------------------------------------------------
# Add completions for directories in the playground
# For more details see: https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html
complete -o dirnames -W "$(pushd $HOME/Dropbox/www/playground;\ls -d */;popd)" playground
# ==============================================================================

#EOF