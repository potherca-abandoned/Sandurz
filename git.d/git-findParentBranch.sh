#!/bin/bash

# The following code *assumes* you are using git flow. See FIXME tag below...

function findParentBranch() {
     branch_name="$(git symbolic-ref HEAD 2>/dev/null)";
     branch_name=${branch_name##refs/heads/};
     
     if [ "$branch_name" = "master" ];then
        echo -e "\n\tYou are currently on branch 'master'. Please switch to another branch and try again.\n"
        exit 65
     elif [ "$branch_name" = "develop" ];then # @FIXME: If we are not in a git-flow repo this is irrelevant!
        firstCommonCommit=$(git log $branch_name..master --pretty=%H | head -1)    
    else
        firstCommonCommit=$(git log master..$branch_name --pretty=%H | head -1)     
    fi
     
     result=$(git branch --contains $firstCommonCommit^1 | grep '^[^\*]')
     echo -ne "\n\t The parent branch for '$branch_name' most likely is : $result \n"
}

findParentBranch

#EOF
