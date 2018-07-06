#!/bin/bash
# https://github.com/nixscript/backup.sh
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
echo "Type absolute paths files/dirs to backaup over space [example: /var/www /etc/apache2/sites-avialable]:"
read -r TARGETS
if [[ -z "$TARGETS" ]]; then
        echo -e "\\e[33;1mWRONG! You must type some paths for backup! Run again.\\e[0m"
fi
if [[ ! -f "$HOME/.ssh/id_rsa.pub" ]]; then
# Generate ssh-key for connect to remote computer
        ssh-keygen -t rsa
fi

# Copy public ssh-key to remote computer (need remote password)
scp "$HOME/.ssh/id_rsa.pub" "$REMOTEUSER@$REMOTEHOST:/home/$REMOTEUSER/.ssh/authorized_keys"

# Change params into scripts
sed -i "s%REMOTEUSER=\"user\"%REMOTEUSER=\"$REMOTEUSER\"%; s%REMOTEHOST=\"example.com\"%REMOTEHOST=\"$REMOTEHOST\"%; s%REMOTEPATH=\"/home/backupsdir/\"%REMOTEPATH=\"$REMOTEPATH\"%; s%ARCHS=\"/var/www\"%ARCHS=\"$TARGETS\"%" ./backup.sh
sed -i "s%BDIR=\"/home/\$USER/backups\"%BDIR=\"$REMOTEPATH\"%" ./clearbckp.sh

if [[ ! -d "$HOME/bin" ]]; then
        mkdir -p "$HOME/bin"
fi

# Copy shell script in to home-directory
cp ./backup.sh "$HOME/bin/backup.sh"

# Change rights to execute
chmod +x "$HOME/bin/backup.sh"
chmod +x ./clearbckp.sh

DIST=$(uname -a | grep -i debian)
if [[ -z "$DIST" ]]; then
# Example target for cron. At 01:00 AM every night.
        SPOOL="/var/spool/cron/root"
else
        SPOOL="/var/spool/cron/crontabs/root"
fi
# Example target for cron. At 01:00 AM every night.
CHCK=$(grep -i "/bin/backup.sh" < "$SPOOL")
if [[ -z "$CHCK" ]]; then
        echo "0 1 * * * $HOME/bin/backup.sh" >> $SPOOL
else
        sed "s%$CHCK%0 1 * * * $HOME/bin/backup.sh%" "$SPOOL"
fi
systemctl restart cron
scp -B ./clearbckp.sh "$REMOTEUSER@$REMOTEHOST:$RPATH"

echo -e "\\e[32;1mOn the remote computer run:\\e[33;1m
        export EDITOR=nano | crontab -e\\e[32;1m
add type next string\\e[33;1m
        0 1 * * * $RPATH/clearbckp.sh\\e[32;1m
save and exit.\\e[0m\n"
