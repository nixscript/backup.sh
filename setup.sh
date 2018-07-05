#!/bin/bash

REMOTEUSER="user"
REMOTEHOST="example.com" # You can set IP

if [[ ! -f "$HOME/.ssh/id_rsa.pub" ]]; then
# Generate ssh-key for connect to remote computer
        ssh-keygen -t rsa
fi

# Copy public ssh-key to remote computer (need remote password)
scp "$HOME/.ssh/id_rsa.pub" $REMOTEUSER@$REMOTEHOST:/home/$REMOTEUSER/.ssh/authorized_keys

if [[ ! -d "$HOME/bin" ]]; then
        mkdir "$HOME/bin"
fi

# Copy shell script in to home-directory
cp ./backup.sh "$HOME/bin/backup.sh"

# Change rights to execute
chmod +x "$HOME/bin/backup.sh"

# Example target for cron. At 01:00 AM every night.
echo "0 1 * * * $HOME/bin/backup.sh">>/var/spool/cron/root
