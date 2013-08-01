#!/usr/bin/env bash

set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

declare -a aNonRepos
COUNTER=-1

BANNER="[47m[30m[4m____________________________UPDATE ALL SVN DIRECTORIES__________________________[0m"
DONE="[47m[30m[4m______________________________________DONE______________________________________[0m"
RULER="[47m[30m[4m________________________________________________________________________________[0m"

function svnUpdate {
    rootDir="$1"
    myDir=""
    for sDir in "$@"
    do
        myDir+="$sDir/"
    done

    echo $RULER
    echo "Updating: [1m`basename $rootDir`[0m"
    svn up $myDir
    if [ "$?" != 0 ];then
        echo [31mCould not Update Directory[0m
        # @TODO: Find specif error that is caused by SVN version mismatch
        #        and call the line below if that is the case.
        #./change-svn-wc-format.py ./$myDir/ 1.5 && svn up $myDir
    fi
}

#function listDir {
    echo $BANNER
    for myDir in `ls -d ./*/`
    do
        if [ -d "$myDir/.svn" ];then
            svnUpdate "$myDir"
        elif [ -d "$myDir/www/.svn" ];then
            svnUpdate "$myDir" "www"
        else
			(( COUNTER++ )) || true # because of the -e flag we need to redirect the 1 returned by using a sub
			aNonRepos[$COUNTER]=`basename $myDir`
        fi
    done

    echo $RULER
    echo "[1mThe following directories are not SVN repositories:[0m"
    echo "$aNonRepos"

    echo $DONE
#}
