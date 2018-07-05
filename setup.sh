#!/bin/bash

echo "Type login for the remote computer:"
read -r REMOTEUSER
if [[ -z "$REMOTEUSER" ]]; then
        echo -e "\\e[33;1mWRONG! Run script again and type login correct!\\[0m"
fi
echo "Type remote host name or IP for the remote computer:"
read -r REMOTEHOST
if [[ -z "$REMOTEHOST" ]]; then
        echo -e "\\e[33;1mWRONG! Run script again and type remote host correct!\\[0m"
fi
echo "Type remote path for backups on the remote computer [/home/$REMOTEUSER/backups/]:"
read -r REMOTEPATH
if [[ -z "$REMOTEPATH" ]]; then
        REMOTEPATH="/home/$REMOTEUSER/backups/"
fi
echo "Type exists path for clearbckp.sh on the remote computer [/home/$REMOTEUSER/bin/]:"
read -r RPATH
if [[ -z "$RPATH" ]]; then
        RPATH="/home/$REMOTEUSER/bin"
fi
if [[ ! -f "$HOME/.ssh/id_rsa.pub" ]]; then
# Generate ssh-key for connect to remote computer
        ssh-keygen -t rsa
fi

# Copy public ssh-key to remote computer (need remote password)
scp "$HOME/.ssh/id_rsa.pub" "$REMOTEUSER@$REMOTEHOST:/home/$REMOTEUSER/.ssh/authorized_keys"

sed "
s/REMOTEUSER=\"user\"/REMOTEUSER=\"$REMOTEUSER\"/
s/REMOTEHOST=\"example.com\"/REMOTEHOST=\"$REMOTEHOST\"/
s/REMOTEPATH=\"/home/backupsdir/\"/REMOTEPATH=\"$REMOTEUSER\"/
" ./backup.sh > ./tmp
mv ./tmp ./backup.sh
sed "s/BDIR=\"/home/\$USER/backups\"/BDIR=\"$REMOTEPATH\"/" ./clearbckp.sh > ./tmp
mv ./tmp ./clearbckp.sh

if [[ ! -d "$HOME/bin" ]]; then
        mkdir -p "$HOME/bin"
fi

# Copy shell script in to home-directory
cp ./backup.sh "$HOME/bin/backup.sh"

# Change rights to execute
chmod +x "$HOME/bin/backup.sh"
chmod +x ./clearbckp.sh

# Example target for cron. At 01:00 AM every night.
echo "0 1 * * * $HOME/bin/backup.sh" >> /var/spool/cron/root

scp -B ./clearbckp.sh "$REMOTEUSER@$REMOTEHOST:$RPATH"

echo "On the remote computer run:
        export EDITOR=nano | crontab -e
add type next string
        0 1 * * * $RPATH/clearbckp.sh
save and exit."
