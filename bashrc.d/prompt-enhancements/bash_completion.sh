
if [ -d /etc/bash_completion ];then
    source /etc/bash_completion && echo 'Bash completion enabled'
elif [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion && echo 'Bash completion enabled'
else
    echo ' !! WARNING: Bash completion is not installed'
fi
