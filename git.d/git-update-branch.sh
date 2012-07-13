#!/bin/bash

master='master'
gitUpdate='git-update'
currentBranch=`git branch | grep '^\*' | cut -d' ' -f2`;

# @FIXME: $currentBranch should be stored in a file in .git (and removed when done) in case a merge conflict kicks us out of a branch and leaves is branch-less
# @NOTE : if a merge conflict kicks us out of a branch, git co "$currentBranch" defaults to "master" as that is the branch we'll be on.

function update () {
    if [ -d ".git/rebase-apply" ];then
        echo 'A patch application or another rebase seems to be in progress.'
        echo ''
        echo "If you just ran $gitUpdate and it stopped because of merge issues please run"
        echo "  git rebase --continue && git update"
        echo ''
        echo 'If that is not the case, please remove the .git/rebase-apply directory'
        echo ''     
    else
        git stash && git co $master && git pull origin $master && git co "$currentBranch" && git rebase $master && git pull origin $currentBranch && git stash pop;
    fi
}

update

