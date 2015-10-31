#!/usr/bin/env bash

source "${HOME}/.common.sh"
sourceFunction isMacOS

# ==============================================================================
# sed -l basically makes sed replace and buffer through stdin to stdout
# so you get updates while the command runs and dont wait for the end
# e.g. npm install | indent
# ------------------------------------------------------------------------------
function indent() {
  # if an arg is given it's a flag indicating we shouldn't indent the first line,
  # so use :+ to tell SED accordingly if that parameter is set, otherwise null
  # string for no range selector prefix (it selects from line 2 onwards and then
  # every 1st line, meaning all lines)

    # @CHECKME: Shouldn't the line below be used?
    # c="${1:+"2,999"} s/^/       /"
    c='s/^/       /'
    if [ isMacOS ];then
        # mac/bsd sed: -l buffers on line boundaries
        sed -l "$c"
    else
        # unix/gnu sed: -u unbuffered (arbitrary) chunks of data
        sed -u "$c"
    fi
}
# ==============================================================================


# ==============================================================================
if [ "${0}" = "${BASH_SOURCE}" ];then
    # direct call to file
    echo $@ | indent
fi # else file is included from another script
# ==============================================================================

#EOF
