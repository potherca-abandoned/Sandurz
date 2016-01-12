
# ==============================================================================
# Lets make ls respond in a way more to my liking.
# ------------------------------------------------------------------------------

case "$(uname -s)" in

    Darwin)
        # Darwin does not support --group-directories-first so some hackery is required
        # Sorting by extension reuires even more work. Maybe later?
        # alias ls="script -q /dev/null ls -lAGhp | sort -f -d -k 1.1,1.1r -k 9 | tr -d '\r' | cat"
        alias ls='ls -lAGhp'
    ;;

    #Linux)
    #;;
    #CYGWIN*|MINGW32*|MSYS*)
    #;;

    *)
        # -l = use a long listing format
        # -X = sort alphabetically by entry extension
        alias ls='ls -lX --color=auto --group-directories-first --human-readable --indicator-style=slash'
    ;;
esac
# ==============================================================================
