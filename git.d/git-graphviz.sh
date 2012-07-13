#!/bin/bash

function graphvizFromGit () {
    DOT=`echo -e "digraph git { \n"`
    DOT="$DOT"`git log --pretty='format:  "%h" [label="%h\\\\n%an"]\n' "$@"`
    DOT="$DOT"`git log --pretty='format:  %h -> { %p }  [label="%s"]\n' "$@" | sed 's/[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]/\"&\"/g'`
    DOT="$DOT"`echo -e "\n}"`;
        
    echo -e "$DOT"
}

graphvizFromGit
