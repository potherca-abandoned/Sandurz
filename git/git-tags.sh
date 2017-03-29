#!/usr/bin/env bash

decorateTags () {
    local output
    output=$(git for-each-ref --format ' %(contents:signature) %(color:green bold)%(align:right,15)%(tag)%(end)%(color:reset) %(color:yellow dim)%(taggerdate:short)%(color:reset) %(color:yellow)%(align:left,30)%(taggername)%(end)%(color:reset) %(subject)' --sort=taggerdate refs/tags \
        | awk -v substitute='🔒' '/-----BEGIN PGP SIGNATURE-----/,/-----END PGP SIGNATURE-----/ { if ( $0 ~ /-----END PGP SIGNATURE-----/ ) print substitute; next } 1' \
        | sed ':a;N;$!ba;s/🔒\n/🔒/g' \
    )

    if [[ -z "${output}" ]];then
        output='No tags'
    fi

    echo "${output}"
}

decorateTags
