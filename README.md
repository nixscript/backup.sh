# backup.sh
Shell for backup some files/dirs to remote computer

Generate ssh-key for connect to remote computer

`ssh-keygen -t rsa`

Copy public ssh-key to remote computer (need remote password)

`scp "$HOME/.ssh/id_rsa.pub" $REMOTEUSER@$REMOTEHOST:/home/$REMOTEUSER/.ssh/authorized_keys`

Copy shell script in to home-directory

`cp ./backup.sh /$HOME/bin/backup.sh`

Change rights to execute

`chmod +x $HOME/bin/backup`

Add target for cron by nano editor. You can choice vi, mcedit, emacs. Just correct parameter for `export`

`export EDITOR=nano`
`crontab -e`

Example target for cron. At 01:00 AM every night.

`0 1 * * * $HOME/bin/backup`
