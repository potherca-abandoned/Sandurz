#!/usr/bin/env bash
echo 'URL(s):' 
git remote -v 
echo ''
echo 'Branche(s):'
git branch -a
echo ''
git log --max-count=1 --pretty=format:'Last Changed Author: %an%nLast Channged Rev: %h%nLast Changed Date:  %aD '
echo "Commit Count: $(git shortlog | grep -E '^[ ]+\w+' | wc -l)"

