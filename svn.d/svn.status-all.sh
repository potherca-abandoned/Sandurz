#!/usr/bin/env bash

set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

BANNER="[47m[30m[4m__________________________SVN STATUS FOR ALL DIRECTORIES________________________[0m"
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
    echo "Status for: [1m`basename $rootDir`[0m"
    echo ""
    svn status $myDir

    if [ "$?" != 0 ];then
        echo "[31mCould not get Status for Directory[0m"
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
        fi
    done
    echo $DONE
#}

#EOF
