source "${HOME}/.common.sh"

sourceFunction sourceFolder

# ==============================================================================
# To keep this file simple and clean, we put more complex scripts in `.bashrc.d`
# and include all the files from that directory from here
# ------------------------------------------------------------------------------
sDirectory="${HOME}"
sourceFolder "$sDirectory/.bashrc.d/"
# ==============================================================================

#EOF

