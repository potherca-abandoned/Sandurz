#!/bin/bash
#set -e
#set -x

function quitOrContinue() {
        echo ""
        echo -e "\tPress any key to continue"
        echo -e "\tPress q to quit"
        read -s -n1 userInput

        if [ "$userInput" = "q" ];then
            exit
        fi
}

function incomingForBranch() {
    branchName=$1
    remote=`git config "branch.$branchName.remote"`
    
    clear
    
    if [ "$remote" = "" ];then
        echo ""
        echo -e "\tBranch $branchName does not have a remote branch"
        quitOrContinue
    else
        git fetch "$remote" "$branchName"

        changes=`git log --decorate "$branchName..$remote/$branchName"`
        if [ "$changes" = "" ];then
            echo -e "\n\n\tNo incoming changes for $branchName from $remote/$branchName"
            quitOrContinue
        else
            echo ""
            echo -e "\tPress any key to see incoming changes for '$branchName'"
            echo ""
            echo -e "\tPress s to skip"
            echo -e "\tPress q to quit"
            
            read -s -n1 userInput
            
            if [ "$userInput" = "q" ];then
                exit
            elif [ "$userInput" != "s" ];then
                
                # FIXME: This breaks if the remote branch has a different name than the local one
                
                git log --decorate "$branchName..$remote/$branchName"
            fi
        fi
    fi
}


function incomingForRef() {
    currentRef=$1
    branchName=${currentRef##refs/heads/}; 
    incomingForBranch $branchName
}


function incomingForAllBranches() {
    declare -a branches
    eval "$(git for-each-ref --shell --format='branches+=(%(refname))' refs/heads/)"
    
    for branchName in "${branches[@]}"; do
        branchName=${branchName##refs/heads/}; 

        incomingForBranch $branchName
    done    
}


if [ "$1" = "--all" ];then
    incomingForAllBranches
else
    currentRef="$(git symbolic-ref HEAD 2>/dev/null)";
    incomingForRef $currentRef
fi

#EOF
