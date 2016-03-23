# ==============================================================================
#           Interfaces to the most commonly used Database Servers
# ------------------------------------------------------------------------------
# This file contains various functions that interface with commonly used
# databases. For cases where the database adds sufficiently feature complete
# utilities an `alias` is used. For other cases a function is declared so no
# alias is needed.
#
# Support for sqlite3 is omitted as usage is too simple.
#
# @TODO: Add support for MongoDB?
# ------------------------------------------------------------------------------
source "${HOME}/.common.sh"
sourceFunction isInstalled printWarning
# ==============================================================================


# ==============================================================================
# Aliases for MySQL and MariaDB Database Servers
# ------------------------------------------------------------------------------
if isInstalled 'mysql.server';then
    alias server.mysql='mysql.server'
    # Add auto-completion for basic commands
    complete -W 'start stop restart reload force-reload status' server.mysql
else
    #printWarning 'The correction script "$" is not installed'
    printWarning "@FIXME: Add an alias to (re)start and stop MySQL"
fi
# ==============================================================================


# ==============================================================================
# Aliases for PostGreSQL Database Server
# ------------------------------------------------------------------------------
if isInstalled 'pg_ctl';then
    # pg_ctl is a utility to initialize, start, stop, or control a PostgreSQL server.
    function server.postgresql() {
        case "$1" in
            'stop')
                pg_ctl -D '/usr/local/var/postgres' stop -s -m fast
                ;;
            *)
                pg_ctl $@ -D '/usr/local/var/postgres' -l '/usr/local/var/postgres/server.log'
                ;;
        esac
    }

    # Add auto-completion for basic commands
    complete -W 'init start stop restart reload status promote kill' server.postgresql
else
    printWarning 'PostgreSQL is not installed. Not aliasing start/stop commands'
fi
# ==============================================================================


# ==============================================================================
# Aliases for PostGreSQL Database Server
# ------------------------------------------------------------------------------
if isInstalled 'redis-server';then

    function server.redis() {
        case "$1" in
            'version')
                redis-server --version
                ;;
            'help')
                echo "Usage: server.redis { start | stop | status | help | version | logs }"
                ;;
            'start')
                # By default redis logs to STDOUT. As not to force the user to edit the
                # config file we simply redirect all output to a log file
                redis-server '/usr/local/etc/redis.conf' > /var/log/redis.stdout 2> /var/log/redis.stderr &
                ;;
            'status')
                redis-cli INFO | grep -E 'uptime|process_id'
                ;;
            'stop')
                redis-cli shutdown
                ;;
            'logs')
                tail -f /var/log/redis.std* -n100
                ;;
            *)
                echo "Unknown command '$1'" >&2
                echo "Usage: server.redis { start | stop | status | help | version | logs }"
                return 1
                ;;
        esac
    }

    complete -W 'start stop status help version logs' server.redis
else
    #printWarning 'The correction script "$" is not installed'
    printWarning "Redis is not installed. Not aliasing start/stop commands"
fi
# ==============================================================================


# ==============================================================================
# Aliases for CouchDB Database Server
# ------------------------------------------------------------------------------
if isInstalled 'couchdb';then
    # pg_ctl is a utility to initialize, start, stop, or control a PostgreSQL server.
    function server.couchdb() {
        declare -a aOptions

        aOptions+='-o /var/log/couchdb.stdout '
        aOptions+='-e /var/log/couchdb.stderr '

        case "$1" in
            'kill')
                aOptions+='-k '
                ;;
            'version')
                aOptions+='-v '
                ;;
            'help')
                aOptions+='-h '
                ;;
            'status')
                aOptions+='-s '
                ;;
            'start')
                aOptions+='-b '
                ;;
            'stop')
                aOptions+='-d '
                ;;
            'logs')
                 tail -f '/var/log/couchdb.std*' -n100
                 return 0
                ;;
            *)
                echo "Unknown command '$1'" >&2
                couchdb -h
                return 1
                ;;
        esac

        couchdb ${aOptions}[@]
    }

    # Add auto-completion for basic commands
    complete -W 'start stop status help version kill logs' server.couchdb
else
    printWarning 'CouchDB is not installed. Not aliasing start/stop commands'
fi
# ==============================================================================

#EOF
