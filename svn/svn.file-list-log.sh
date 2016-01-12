#!/bin/bash
set -o nounset # exit on use of an uninitialised variable, same as -u
#set -o errexit # exit on all and any errors, same as -e

# Writes the SVN log of given files in a given repo to a log file.
# 
# The first parameter is the path to the local SVN working directory
# All supsequent parameters are the files to write logs for.

#@TODO: This thing is a mess. Missing param check, usage message, error checking, code structure, etc.

REPOPATH="$1"
SVNLOG="svn-files.log"

shift
TOTAL=$#
echo "Will process a total of $TOTAL files"

echo "" > "$SVNLOG"

COUNTER=0
for FILE in "$@"
do
    let "COUNTER=$COUNTER + 1"
    if [ "$COUNTER" -lt "10" ]; then
        _COUNTER="0$COUNTER"
    else
        _COUNTER="$COUNTER"
    fi
    
    echo "  ($_COUNTER/$TOTAL) -- $REPOPATH/$FILE"

    echo "===============================================================================" >> "$SVNLOG"
    echo "$FILE" >> "$SVNLOG"
    svn log "$REPOPATH/$FILE" >> "$SVNLOG"
    echo ""

done;

echo "Results have been written to $SVNLOG"

exit 0
