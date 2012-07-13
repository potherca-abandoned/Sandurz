#! /bin/sh
line=${1#*\?}

f=${line%:*}
l=${line#*:}

phpstorm="~/Desktop/PhpStorm-Stable/bin/phpstorm.sh"

#echo "Opening $f line $l with $phpstorm"

$phpstorm --line $l "$f"
