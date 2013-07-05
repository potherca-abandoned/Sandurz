#!/usr/bin/env bash
set -u
set -e

if [ $# != 2 ];then
    echo 'ERROR : This script expects two parameter:'
    echo ' -- the directory to run detection on'
    echo ' -- the directory to write the output to'
    exit 65
fi

#@TODO: Create output directory if it does not (yet) exist

SUBJECT_FOLDER="$1";
TARGET_FOLDER="$2";
IGNORE_LIST="system/plugins/";

echo "Gathering data for $SUBJECT_FOLDER and putting into $TARGET_FOLDER, ignoring $IGNORE_LIST";

phpmd "$SUBJECT_FOLDER" html codesize   --ignore="$IGNORE_LIST" --reportfile "$TARGET_FOLDER/phpmd/codesize.html";
phpmd "$SUBJECT_FOLDER" html design     --ignore="$IGNORE_LIST" --reportfile "$TARGET_FOLDER/phpmd/design.html";
phpmd "$SUBJECT_FOLDER" html naming     --ignore="$IGNORE_LIST" --reportfile "$TARGET_FOLDER/phpmd/naming.html";
phpmd "$SUBJECT_FOLDER" html unusedcode --ignore="$IGNORE_LIST" --reportfile "$TARGET_FOLDER/phpmd/unusedcode.html";
