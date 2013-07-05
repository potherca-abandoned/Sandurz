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

svnRepoPath="$repoRootPath/dcpf.svn"   
logPath="$repoRootPath/svn-submodule-export.log"

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
# Make main DCPF git repository
# ------------------------------------------------------------------------------
function makeDcpfGitRepo() {

    repoName='dcpf'

    echoLog "# ------------------------------------------------------------------------------"

    if [ -d "$repoRootPath/$repoName.git" ];then
        echoLog "Git repository '$repoRootPath/$repoName.git' already exists. Deleting..."
        #gitInit=false
        rm -rdf "$repoRootPath/$repoName.git"
    fi

    echoLog "Moving directory '$svnRepoPath' to git repository '$repoRootPath/$repoName.git'"
    mv "$svnRepoPath" "$repoRootPath/$repoName.git"


    echoLog "Initialize git repository for '$repoRootPath/$repoName.git'"
    git init "$repoRootPath/$repoName.git"

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
# Run DCPF -- SVN submodule export
# ------------------------------------------------------------------------------
function run() {
    validateRepoPathExists

    echo '' > "$logPath"
    echoLog 'DCPF -- SVN Submodule export'

    fetchDcpfSvnRepository
    makeDcpfGitRepo

    log '# ------------------------------------------------------------------------------'
    log 'Done.'
}
# ==============================================================================

run 

#EOF
