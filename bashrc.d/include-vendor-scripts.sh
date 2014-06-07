# ==============================================================================
# To keep this file simple and clean, we put more complex scripts in .bashrc.d 
# and include all the files from that directory from here
# ------------------------------------------------------------------------------

# find out where we are located, following symlinks as the install script symlinks the `.bashrc.d` directory to `~/`
sVendorDir="$(dirname "$(readlink -f "$0")")/../vendor"

aVendorScript[0]='symfony2-autocomplete/symfony2-autocomplete.bash'
aVendorScript[0]='git-flow-completion/git-flow-completion.bash'

for sFile in "${aVendorScript[@]}" 
do
	source "${sVendorDir}/${sFile}"
done
# ==============================================================================

#EOF
