#!/bin/bash

function see() {

    lastSeenTagName='__LAST_SEEN_CHANGE__'
    

    branchName="$(git symbolic-ref HEAD 2>/dev/null)";
    branchName=${branchName##refs/heads/}; 
    
    start="$lastSeenTagName.."
    
    # if $lastSeenTagName is not set we either need to set in on the first commit
    # or run git log without it/from the first commit
    result=`git tag | grep "$lastSeenTagName";echo $?`
    if [ "$result" = "1" ];then
        start=''
    fi

    result=`git log --patch --reverse --topo-order "$start$branchName"`
    if [ "$result" = '' ];then
        echo -e "\n\tNo unseen changes on branch '$branchName' \n"
    else
        # @NOTE: Command issued again to keep pretty formatting and whatnot
        git log --patch --reverse --topo-order "$start$branchName"
        git tag --force "$lastSeenTagName" "$branchName"
    fi
};

see

#EOF
