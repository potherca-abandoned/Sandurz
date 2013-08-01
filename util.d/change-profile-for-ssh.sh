#!/usr/bin/env bash

set -e
set -x

#~/.bashrc
#    alias ssh='change-profile-for-ssh.sh'


# Get all profiles
PROFILES=`gconftool --all-dirs /apps/gnome-terminal/profiles`

# Get the name for each profile  
for PROFILE in $PROFILES
do
    NAME=`gconftool --get "$PROFILE/visible_name"`
done



# get the HOSTNAME
# see if a profile is configured for that HOSTNAME
# else just use the default (or configure a fallback)
#run the following command
#gnome-terminal --window-with-profile=$PROFILE -x bash -c "ssh $@"
#
# OR
#
# get the HOSTNAME
# Find the color in "a list"
# backup the current color
# Set the background color
# reload "something"?
# ssh
# restore color

exit
    
 ssh [-1246AaCfgKkMNnqsTtVvXxYy] [-b bind_address] [-c cipher_spec]
           [-D [bind_address:]port] [-e escape_char] [-F configfile]
           [-I pkcs11] [-i identity_file]
           [-L [bind_address:]port:host:hostport]
           [-l login_name] [-m mac_spec] [-O ctl_cmd] [-o option] [-p port]
           [-R [bind_address:]port:host:hostport] [-S ctl_path]
           [-W host:port] [-w local_tun[:remote_tun]]
           [user@]hostname [command]

# http://superuser.com/questions/41826/how-can-i-change-the-colors-of-gnome-terminal-each-time-it-starts/    
# gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "#E376DDDDFFFF"
#!/bin/bash 

PROFILE_NAME="Profile_$HOSTNAME"
TMP_DIR='/tmp'
DEFAULT_PROFILE='Default'
PROFILE_EXPORT_FILE="$TMP_DIR/$PROFILE_NAME.xml"

#replace with program to generate a random background color
BACKGROUND_COLOR="#0000AA000"

# dump the "Default" profile, replace with new random profile name
gconftool-2 --dump /apps/gnome-terminal/profiles/${DEFAULT_PROFILE} > ${PROFILE_EXPORT_FILE}
sed -i "s/${DEFAULT_PROFILE}/${PROFILE_NAME}/g" ${PROFILE_EXPORT_FILE}

# load the new random profile, change the background color
gconftool-2 --load ${PROFILE_EXPORT_FILE}
gconftool-2 --set "/apps/gnome-terminal/profiles/${PROFILE_NAME}/background_color" --type string "${BACKGROUND_COLOR}"

# add the new random profile to list of profiles
PROFILE_LIST=`gconftool-2 --get /apps/gnome-terminal/global/profile_list`
NEW_PROFILE_LIST=`echo $PROFILE_LIST | sed "s/]/,${PROFILE_NAME}]/g"`
gconftool-2 --set  /apps/gnome-terminal/global/profile_list --type list --list-type string "$NEW_PROFILE_LIST"
# start gnome-terminal with new random profile, such that the script blocks till terminal is closed.
gnome-terminal --window-with-profile=${PROFILE_NAME} --disable-factory

# cleanup: remove the new random profile, and remove it from list of profiles
gconftool-2 --recursive-unset /apps/gnome-terminal/profiles/${PROFILE_NAME}
gconftool-2 --set  /apps/gnome-terminal/global/profile_list --type list --list-type string "${PROFILE_LIST}"   

#EOF 
