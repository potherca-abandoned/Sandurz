#!/usr/bin/env bash
# ==============================================================================
# Enhance prompt when inside git repos
# http://railstips.org/blog/archives/2009/02/02/bedazzle-your-bash-prompt-with-git-info/
# ------------------------------------------------------------------------------
function parse_git_branch {
    local sColor
    local sRef=$(git symbolic-ref HEAD 2> /dev/null) || return
    local sBranch="${sRef#refs/heads/}"

    case "${sBranch}" in
        master)
            # On the MASTER branch, Color the promt red
            sColor=31
        ;;

        develop)
            # On the DEVELOP branch, Color the prompt yellow
            sColor=33
        ;;

        feature/*)
            # On a FEATURE branch, Color the prompt green
            sColor=32
        ;;

        gh-pages)
            # On a FEATURE branch, Color the prompt magenta
            sColor=35
        ;;

        *)
            # We're no longer in Kansas, Dorothy! Color the promt blue
            sColor=34
        ;;
    esac

    if [ "${sBranch}" != "" ];then
        echo -ne " (\033[${sColor}m${sBranch}\033[00m)"
    fi

}

# ------------------------------------------------------------------------------
#PS1="$PS1\$(parse_git_branch)"
# ==============================================================================

#EOF
