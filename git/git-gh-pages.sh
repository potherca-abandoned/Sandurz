#!/usr/bin/env bash

git symbolic-ref HEAD refs/heads/gh-pages
rm .git/index && git clean -fdx
touch 'index.html'
git add index.html 
git commit -a -m "Initial commit. Adds Empty index page"
git push origin gh-pages
