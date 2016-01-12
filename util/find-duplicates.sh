#!/usr/bin/env bash

# author : José Fonseca
# url    : https://code.google.com/p/jrfonseca/

# find-duplicates.sh - prints the names of duplicate files

# NOTE: this script operates in two steps:
# 1. find files with the same length
# 2. find files with the same MD5 hash

# XXX: it is possible to give erroneous result if two files have the same MD5
# hash value

find "$@" -type f -printf '%032s  %p\n' | \
	sort -b -n -k1,1 | \
	uniq -D -w32 | \
	cut -c35- | \
xargs -d '\n' md5sum | \
	sort -k1,1 | \
	uniq --all-repeated=separate -w32 | \
	cut -c35-

