#!/bin/bash
set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

repoRootPath='/home/ben/Desktop/dev/DCPF/mirror'
destinationRepoName='MyRepo'
destinationRepoPath="$repoRootPath/$destinationRepoName"
sourceRepository='https://example.com/path/to/svn/'

#@TODO: instead of hardcoding the svn user we should implement svnUser='MySvnUser'

hookPath="$destinationRepoPath/hooks/pre-revprop-change"

# Create an empty repository locally
svnadmin create $destinationRepoPath

# Set up a  pre-revprop-change hook
cat <<'EOF' > $hookPath
#!/bin/sh
USER="$3"

if [ "$USER" = "MySvnUser" ]; then exit 0; fi

echo "Only MySvnUser can change revprops" >&2
exit 1
EOF

# Make the hook executionable
chmod +x "$destinationRepoPath/hooks/pre-revprop-change"

# Initialize the repo
svnsync init --username $svnUser "file://$destinationRepoPath" "$sourceRepository"

# Get all the revisions
svnsync "file://$destinationRepoPath"

exit

#EOF
