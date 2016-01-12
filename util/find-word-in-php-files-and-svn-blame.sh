#!/usr/bin/env bash
set -e

if [ $# -lt 2 ];then
    #@TODO: Proper usage description
    echo "This script requires at least 2 parameters:"
    echo " the path to the local SVN working directory as first parameter"
    echo " the word to search for as second parameter"
    echo " any remaing parameters are passed to grep (which does the search for us)."
    echo ""
    echo "Currently only PHP files are searched"
    exit 64
fi

SvnRepoDirectory=$1
shift
WORD=$1
shift

# any remaing params are passed to grep

echo "Will now search '$SvnRepoDirectory' for occurences of '$WORD'. This might take some time..."

LIST=`grep -r -H "$@" --include '*.php' $WORD $SvnRepoDirectory  | cut -d: -f1`

LIST=`echo -e "$LIST" | sort -u`

for FILE in $LIST
do
    echo "$FILE"
    
    if [ -f "$FILE" ];then

        STATUS=`svn stat $FILE | cut -d ' ' -f1`
        if [ "$STATUS" = "I" ];then
           echo  "File is not under version control..."
           echo  -e `cat "$FILE" | grep "$WORD" -n`
           echo ""
        else
            RESULT=`svn blame "$FILE" | grep "$WORD" -n`
           echo  -e "$RESULT"
           echo ""       
        fi
    fi
done
