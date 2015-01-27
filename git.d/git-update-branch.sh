#!/bin/bash

g_sMaster='master'
g_sCurrentBranch=$(git rev-parse --abbrev-ref HEAD)

# @FIXME: $g_sCurrentBranch should be stored in a file in .git (and removed when done) in case a merge conflict kicks us out of a branch and leaves us branch-less
# @NOTE : if a merge conflict kicks us out of a branch, git co "$g_sCurrentBranch" defaults to "master" as that is the branch we'll be on.

function update () {
    if [ -d ".git/rebase-apply" ];then
        echo 'A patch application or another rebase seems to be in progress.'
        echo ''
        echo "If you just ran $(basename ${0}) and it stopped because of merge issues please run"
        echo -e '\tgit rebase --continue && git update'
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

