# backup.sh
Shell for backup some files/dirs to remote computer

```ssh-keygen -t rsa

```scp "$HOME/.ssh/id_rsa.pub" $REMOTEUSER@$REMOTEHOST:/home/$REMOTEUSER/.ssh/authorized_keys

```cp ./backup.sh /$HOME/bin/backup.sh

```chmod +x $HOME/bin/backup

```export EDITOR=nano
```crontab -e

```0 1 * * * $HOME/bin/backup
