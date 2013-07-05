#!/bin/bash
set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e



# ==============================================================================
#    Instead of doing an SVN export and stripping out all the stuff we want into
#    seperate directories (thus losing the history) it would be nicer to do a 
#    seperate git svn clone for each directory (keeping the history intact) and
#    ignoring those directories in the final git svn clone of the main SVN repo.
# ==============================================================================


# ==============================================================================
# ------------------------------------------------------------------------------
# EDITABLE
DEBUG=1

# repoRootPath='/git/repos'               # <- devstar git version
## repoRootPath='/home/git/repositories'   # <- devstar gitolite version
repoRootPath='/home/ben/Desktop/dev/DCPF/repos'

svnAuthorsFile='svn-authors.txt'
svnRepoUrl='https://intern.vrestmedical.com/svn/Projecten/DCPF/modern'

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

# ------------------------------------------------------------------------------
# NON-EDITABLE
logPath="$repoRootPath/svn-to-git.log"
excludeList=''
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
function writeSvnAuthorFile() {
cat << 'TXT' > "$repoRootPath/$svnAuthorsFile"

akleene         = arjan             <akleene@vrest.nl>
GreveO          = olaf              <ogreve@vrest.nl>
HerlaarK        = kris              <kherlaar@vrest.nl>
HuijnenP        = paul              <phuijnen@vrest.nl>
OlthuisJL       = jos               <jolthuis@vrest.nl>
PeacheyB        = ben               <bpeachey@vrest.nl>
rvanginhoven    = robin             <rvanginhoven@vrest.nl>
thijs           = thijs             <trietman@vrest.nl>

(no author)     = Unknown Author    <black-hole@vrest.nl>

tuulia          = tuulia            <black-hole@vrest.nl>
clarinus        = clarinus          <black-hole@vrest.nl>
OudeKotteM      = mark              <black-hole@vrest.nl>

Frodo           = vrest-git-user    <black-hole@vrest.nl>
TXT
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
# Make git repositories for all requested DCPF sub-folders
# ------------------------------------------------------------------------------
function gitSvnCloneSubfolders() {

    for repoName in "${!subFolders[@]}"
    do
        subFolder="${subFolders[$repoName]}"
        echoLog "# ------------------------------------------------------------------------------"
        echoLog "Repo   : $repoName"
        echoLog "Folder : $subFolder"


        if [ -d "$repoRootPath/$repoName.git" ];then
            echoLog "Git repository '$repoRootPath/$repoName.git' already exists. Deleting..."
            rm -rdf "$repoRootPath/$repoName.git"
        fi

        echoLog "Cloning '$svnRepoUrl/$subFolder' to git repository '$repoRootPath/$repoName.git'"
        echo '---- This might take a while...'
                
        git svn clone                                       \
                                                            \
            --authors-file="$repoRootPath/$svnAuthorsFile"  \
            --trunk="$svnRepoUrl/$subFolder"                \
                                                            \
            "$repoRootPath/$repoName.git"  >> $logPath

#--no-follow-parent
        
        cd "$repoRootPath/$repoName.git"

        echoLog "Sorting out svn:ignore"
        git svn show-ignore > .gitignore                    
        git add .gitignore
        git commit -m 'Convert svn:ignore properties to .gitignore.'  >> $logPath
        
        echoLog "Remove SVN references"
        git config --remove-section svn-remote.svn
        git config --remove-section svn
        /bin/rm -rdf "$repoRootPath/$repoName.git/.git/svn/"
        git branch -dr trunk
                
        echoLog "Adding remote origin '$remoteGit:$repoName.git'"
        git remote add origin "$remoteGit:$repoName.git"
        
#        echoLog "Committing contents of '$repoRootPath/$repoName.git' to git repository."
#        git add -A
#        git commit -a -s -m "Adding contents for $repoName." >> $logPath

        echoLog "Pushing '$repoName' to the server '$remoteGit:$repoName.git'"
        echo "git push origin master  >> $logPath"

        excludeList="$excludeList|$subFolder/*"
    done
}
# ==============================================================================


# ==============================================================================
# Make main DCPF git repository
# ------------------------------------------------------------------------------
function gitSvnCloneDcpf() {

    repoName='dcpf'

    echoLog "# ------------------------------------------------------------------------------"

    if [ -d "$repoRootPath/$repoName.git" ];then
        echoLog "Git repository '$repoRootPath/$repoName.git' already exists. Deleting..."
        #gitInit=false
        rm -rdf "$repoRootPath/$repoName.git"
    fi

###############################
        echoLog "Cloning '$svnRepoUrl' to git repository '$repoRootPath/$repoName.git'"
        echo '---- This might take a while...'
        
        git svn clone                                       \
                                                            \
            --authors-file="$repoRootPath/$svnAuthorsFile"  \
            --trunk="$svnRepoUrl"                           \
            --ignore-paths="(?:$excludeList)"               \
                                                            \
            "$repoRootPath/$repoName.git"  >> $logPath

#--no-follow-parent
        
        cd "$repoRootPath/$repoName.git"

        echoLog "Sorting out svn:ignore"
        git svn show-ignore > .gitignore                    
        git add .gitignore
        git commit -m 'Convert svn:ignore properties to .gitignore.'  >> $logPath
        
        echoLog "Remove SVN references"
        git config --remove-section svn-remote.svn
        git config --remove-section svn
        /bin/rm -rdf "$repoRootPath/$repoName.git/.git/svn/"
        git branch -dr trunk
                
        echoLog "Adding remote origin '$remoteGit:$repoName.git'"
        git remote add origin "$remoteGit:$repoName.git"
        
#        echoLog "Committing contents of '$repoRootPath/$repoName.git' to git repository."
#        git add -A
#        git commit -a -s -m "Adding contents for $repoName." >> $logPath

        echoLog "Pushing '$repoName' to the server '$remoteGit:$repoName.git'"
        echo "git push origin master  >> $logPath"

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

    writeSvnAuthorFile
    gitSvnCloneSubfolders
    gitSvnCloneDcpf
    #makeGitSubmodules

    log '# ------------------------------------------------------------------------------'
    log 'Done.'
}
# ==============================================================================

run 

#EOF
