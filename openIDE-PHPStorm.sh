#! /bin/sh
line=${1#*\?}

f=${line%:*}
l=${line#*:}

phpstorm="/home/ben/Desktop/PhpStorm-111.19/bin/phpstorm.sh"

#echo "Opening $f line $l with $phpstorm"

$phpstorm --line $l "$f"
