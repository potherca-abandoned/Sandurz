#!/bin/bash

g_sMaster='master'
g_sGitUpdate='git-update'
g_sCurrentBranch=$(git rev-parse --abbrev-ref HEAD)

# @FIXME: $g_sCurrentBranch should be stored in a file in .git (and removed when done) in case a merge conflict kicks us out of a branch and leaves us branch-less
# @FIXME: The branch where we want to update from needs to be a parameter!
# @FIXME: The remote where we want to update from needs to be a parameter!
# @FIXME: We need to take git pull -rebase and git rebase into account here! We don't always just want to pul (fetch/merge) as verbose merges screw with the history tree
# @NOTE : if a merge conflict kicks us out of a branch, git co "$g_sCurrentBranch" defaults to "master" as that is the branch we'll be on.

function update () {
    if [ -d ".git/rebase-apply" ];then
        echo 'A patch application or another rebase seems to be in progress.'
        echo ''
        echo "If you just ran ${g_sGitUpdate} and it stopped because of merge issues please run"
        echo "  git rebase --continue && git update"
        echo ''
        echo 'If that is not the case, please remove the .git/rebase-apply directory'
        echo ''
    else
        git stash \
            && git co $g_sMaster \
            && git pull origin $g_sMaster \
            && git co "$g_sCurrentBranch" \
            && git rebase $g_sMaster \
            && git pull origin $g_sCurrentBranch \
            && git stash pop
    fi
}

update

