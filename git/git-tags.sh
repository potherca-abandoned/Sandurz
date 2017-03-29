#!/usr/bin/env bash

decorateTags () {
    local awkPattern end format output sedPattern start symbol

    symbol='🔒'

    start='/-----BEGIN PGP SIGNATURE-----/'
    end='/-----END PGP SIGNATURE-----/'

    sedPattern=':a;N;$!ba;s/'"${symbol}"'\n/'"${symbol}"'/g'
    awkPattern="${start}"','"${end}"' { if ( $0 ~ '"${end}"' ) print substitute; next } 1'

    format=' %(contents:signature) %(color:green bold)%(align:right,16)%(tag)%(end)%(color:reset) %(color:yellow dim)%(taggerdate:short)%(color:reset) %(color:yellow)%(align:left,30)%(taggername)%(end)%(color:reset) %(subject)'

    output=$(\
        git for-each-ref --format "${format}" --sort=taggerdate refs/tags \
        | awk -v substitute="${symbol}" "${awkPattern}" \
        | sed "${sedPattern}" \
    )

    if [[ -z "${output}" ]];then
        output='No tags'
    fi

    echo "${output}"
}

decorateTags
