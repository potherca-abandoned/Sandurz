# ==============================================================================
# To keep this file simple and clean, we put more complex scripts in .bashrc.d 
# and include all the files from that directory from here
# ------------------------------------------------------------------------------

aVendorScript[0]='symfony2-autocomplete/symfony2-autocomplete.bash'
aVendorScript[1]='git-flow-completion/git-flow-completion.bash'
aVendorScript[2]='heroku_bash_completion/heroku_bash_completion.sh'
aVendorScript[3]='composer-bash-completion/composer'

# ------------------------------------------------------------------------------
# find out where we are located, following symlinks as the install script symlinks the `.bashrc.d` directory to `~/`
if [ -n "${BASH_SOURCE}" ]; then
    sScriptPath="${BASH_SOURCE}"
elif [ -n "$ZSH_VERSION" ]; then
    setopt function_argzero
    sScriptPath="${0}"
elif eval '[[ -n ${.sh.file} ]]' 2>/dev/null; then
    eval 'sScriptPath=${.sh.file}'
else
    sOpenFile="$(lsof -F n -p $$ | sed -n '$s/^n//p')"
    if [ -n "$sOpenFile" ]; then
        sScriptPath="${sOpenFile}"
    else
        echo 1>&2 "Could not reliably determine script location. Aborting"
        exit 64
    fi
fi

sVendorDir="$(dirname ${sScriptPath})/../vendor"

for sFile in "${aVendorScript[@]}" 
do
	source "${sVendorDir}/${sFile}"
done
# ==============================================================================

#EOF
