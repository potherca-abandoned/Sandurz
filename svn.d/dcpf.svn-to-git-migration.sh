#!/bin/bash
set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

# ==============================================================================
# ------------------------------------------------------------------------------
DEBUG=1
repoRootPath='/git/repos'               # <- devstar git version
#repoRootPath='/home/git/repositories'   # <- devstar gitolite version
#repoRootPath='/home/ben/Desktop/dev/DCPF/repos'

svnRepoPath="$repoRootPath/dcpf.svn"   
logPath="$repoRootPath/svn-to-git.log"
remoteGit='git@dcpf-dev'

declare -A subFolders
# subFolderfolder[repoName]='path/to/folder'
subFolders['dcpf-library']='library/DCPF'
subFolders['red']='rphp.library'
subFolders['dcpf-web-resources']='www/rsrc'

# Third-Party Folders
subFolders['dompdf']='library/dompdf'
subFolders['firephp']='library/FirePHP'
subFolders['jpgraph']='library/JPGraph'
subFolders['minify']='library/Minify'
subFolders['pear']='library/PEAR'

#excludeList='--exclude ".svn/"'
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function echoDebug() {
	if [ "$DEBUG" != "0" ];then
		echo "--> $@"
	fi
}
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function echoLog() {
    echo "$@"
    log "$@"
}
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function log() {
    if [ -f $logPath ];then
        echo "$@" >> $logPath
    fi
}
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
function error() { 
	echo "$@" 1>&2 # Write to STDERR
	exit 1
}
# ==============================================================================


# ==============================================================================
#   
# ------------------------------------------------------------------------------
function validateRepoPathExists() {
    echoLog "# ------------------------------------------------------------------------------"
    if [ ! -d "$repoRootPath" ];then
        echoLog "$repoRootPath does not exist. Trying to create."
        mkdir "$repoRootPath"
    fi
    echoLog "$repoRootPath exist."
}
# ==============================================================================



# ==============================================================================
#   Get the DCPF SVN repository
# ------------------------------------------------------------------------------
function fetchDcpfSvnRepository() {
    if [ -d "$repoRootPath/dcpf.git" ];then
        echoLog "DCPF git repo already exists. Deleting... "
        /bin/rm -rdf "$repoRootPath/dcpf.git"
    fi

    if [ -d "$repoRootPath/dcpf.svn" ];then
        echoLog "DCPF svn repo already exists. Deleting... "
        /bin/rm -rdf "$repoRootPath/dcpf.svn"
    fi

    echoLog "Exporting the SVN repo to '$svnRepoPath'."
    svn export https://intern.vrestmedical.com/svn/Projecten/DCPF/modern/ "$svnRepoPath" >> $logPath

#    if [ ! -d "$svnRepoPath" ];then
#        echoLog "Checking out the SVN repo to '$svnRepoPath'."
#        svn co https://intern.vrestmedical.com/svn/Projecten/DCPF/modern/ "$svnRepoPath" >> $logPath
#    else
#        echoLog "SVN repo exists at '$svnRepoPath'. Updating..." 
#        svn up "$svnRepoPath" >> $logPath
#    fi

}    
# ==============================================================================


# ==============================================================================
# Make git repositories for all requested DCPF sub-folders
# ------------------------------------------------------------------------------
function makeGitReposForSubfolders() {

    for repoName in "${!subFolders[@]}"
    do
        gitInit=true

        subFolder="${subFolders[$repoName]}"
        echoLog "# ------------------------------------------------------------------------------"
        echoLog "Repo   : $repoName"
        echoLog "Folder : $subFolder"


        if [ -d "$repoRootPath/$repoName.git" ];then
            echoLog "Git repository '$repoRootPath/$repoName.git' already exists. Deleting..."
            #gitInit=false
            rm -rdf "$repoRootPath/$repoName.git"
        fi

        #echoLog "rsync directory '$svnRepoPath/$subFolder' to git repository '$repoRootPath/$repoName.git'"
        #rsync --recursive --update --links --perms --times --compress --delete --human-readable "$svnRepoPath/$subFolder" "$repoRootPath/$repoName.git" #--dry-run 

        echoLog "Moving directory '$svnRepoPath/$subFolder' to git repository '$repoRootPath/$repoName.git'"
        mv "$svnRepoPath/$subFolder" "$repoRootPath/$repoName.git"

        if [ $gitInit = true ];then
            echoLog "Initialize git repository for '$repoRootPath/$repoName.git'"
            git init "$repoRootPath/$repoName.git"
        fi

        cd "$repoRootPath/$repoName.git"
        
        echoLog "Adding remote origin '$remoteGit:$repoName.git'"
        git remote add origin "$remoteGit:$repoName.git"
        
        echoLog "Committing contents of '$repoRootPath/$repoName.git' to git repository."
        git add -A
        git commit -a -s -m "Adding contents for $repoName." >> $logPath

        echoLog "Pushing '$repoName' to the server '$remoteGit:$repoName.git'"
        git push origin master

        #excludeList="$excludeList --exclude \"/$subFolder/\""
    done
}
# ==============================================================================


# ==============================================================================
# Make main DCPF git repository
# ------------------------------------------------------------------------------
function makeDcpfGitRepo() {

    gitInit=true
    repoName='dcpf'

    echoLog "# ------------------------------------------------------------------------------"

    if [ -d "$repoRootPath/$repoName.git" ];then
        echoLog "Git repository '$repoRootPath/$repoName.git' already exists. Deleting..."
        #gitInit=false
        rm -rdf "$repoRootPath/$repoName.git"
    fi

    # echoLog "rsync directory '$svnRepoPath' to git repository '$repoRootPath/$repoName.git'"
    # log "Exclude List = $excludeList"
    # rsync --recursive --update --links --perms --times --compress --delete --human-readable $excludeList "$svnRepoPath" "$repoRootPath/$repoName.git"

    echoLog "Moving directory '$svnRepoPath' to git repository '$repoRootPath/$repoName.git'"
    mv "$svnRepoPath" "$repoRootPath/$repoName.git"


    if [ $gitInit = true ];then
        echoLog "Initialize git repository for '$repoRootPath/$repoName.git'"
        git init "$repoRootPath/$repoName.git"
    fi

    cd "$repoRootPath/$repoName.git"

    echoLog "Adding remote origin '$remoteGit:$repoName.git'"
    git remote add origin "$remoteGit:$repoName.git"
    
    echoLog "Committing contents of '$repoRootPath/$repoName.git' to git repository."
    git add -A
    git commit -a -s -m "Adding contents for $repoName." >> $logPath

    echoLog "Pushing '$repoName' to the server '$remoteGit:$repoName.git'"
    git push origin master

}
# ==============================================================================


# ==============================================================================
# Make git subtrees in DCPF git repository
# ------------------------------------------------------------------------------
function makeGitSubtrees() {
    
    repoName='dcpf'
    
    cd "$repoRootPath/$repoName.git"
        
    echoLog "# ------------------------------------------------------------------------------"
    echoLog "Adding git subtree for all non-dcpf.git directories to their right location in dcpf.git"
    # Since the instructions are a little sparse, here’s how I installed and used it on Ubuntu:
    # git clone https://github.com/apenwarr/git-subtree.git
    # cd git-subtree
    # sudo ./install.sh 
    # all this does is copies a file to your git folder, i.e. /usr/lib/git-core
    # And then to use it to merge an existing separate git repository into your current one,

    for repoName in "${!subFolders[@]}"
    do
        subFolder="${subFolders[$repoName]}"
        
        echoLog "---- Adding git subtree for '$repoName.git' at location '$subFolder'"
        git subtree add --squash --message="DCPF-?? Adding $repoName as subtree" --prefix="$subFolder" "$repoRootPath/$repoName.git"
    done

}
# ==============================================================================


# ==============================================================================
# Make git subtrees in DCPF git repository
# ------------------------------------------------------------------------------
function makeGitSubmodules() {

    repoName='dcpf'
    
    echoLog "# ------------------------------------------------------------------------------"
    echoLog "Adding git submodules for all non-dcpf.git directories to their right location in dcpf.git"

    cd "$repoRootPath/$repoName.git"
    
    for repoName in "${!subFolders[@]}"
    do
        subFolder="${subFolders[$repoName]}"
        
        
        echoLog "---- Adding git submodule for '$repoName.git' at location '$subFolder'"

        git submodule add "../$repoName.git" "$subFolder"
        #git submodule add "$repoRootPath/$repoName.git" "$subFolder"
        #git submodule add "$remoteGit:$repoName.git" "$subFolder"
       
    done

    echoLog "Committing submodules to git repository."
    git add -A
    git commit -a -s -m "Adding git submodules." >> $logPath

    echoLog "Pushing submodlues to the server '$remoteGit:$repoName.git'"
    git push origin master
}
# ==============================================================================


# ==============================================================================
# Run DCPF -- SVN to git migration
# ------------------------------------------------------------------------------
function run() {
    validateRepoPathExists

    echo '' > "$logPath"
    echoLog 'DCPF -- SVN to git migration'

    fetchDcpfSvnRepository
    makeGitReposForSubfolders
    makeDcpfGitRepo
    makeGitSubmodules

    log '# ------------------------------------------------------------------------------'
    log 'Done.'
}
# ==============================================================================

run 

#EOF
