#!/usr/bin/env bash
set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

if [ $# != 2 ];then
    echo 'ERROR : This script expects two parameter:'
    echo ' -- the directory to run detection on'
    echo ' -- the directory to write the output to'
    exit 65
fi

#@TODO: Createoutput directory if it does not (yet) exist

#@TODO: Make these into parameters
SUBJECT_FOLDER="$1"
TARGET_FOLDER="$2"
IGNORE_LIST="system/plugins/"

pdepend \
    --jdepend-chart="${TARGET_FOLDER}/pdepend/jdepend.svg" \
    --jdepend-xml="${TARGET_FOLDER}/pdepend/jdepend.xml" \
    --overview-pyramid="${TARGET_FOLDER}/pdepend/pyramid.svg" \
    --summary-xml="${TARGET_FOLDER}/pdepend/summary.xml" \
    --ignore="${IGNORE_LIST}" \
    --without-annotations \
    --debug \
    "$SUBJECT_FOLDER"


#EOF
