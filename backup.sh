#!/bin/bash
# https://github.com/nixscript/backup.sh
REMOTEUSER="user" # login пользователя на удалённой машине
REMOTEHOST="example.com" # Можно указать IP
REMOTEPATH="/home/backupsdir/" # Либо создайте эту директорию на удалённой машине, либо укажите здесь другую.
TMPDIR="/tmp" # Если в корне мало места, лучше заменить на /home/$USER
# Загоняем текущую дату в переменную
d=$(date +%F)
# Упаковываем файлы и прочее в TAR
# Не забудьте заменить на свои файлы и директории!
tar -cf "$TMPDIR/${d}backup.tar" "/var/www" "/etc/apache2/sites-avialable"
# Сжимаем максимально
gzip -9 "$TMPDIR/${d}backup.tar"
# Отправляем на удалённую машину
scp -B "$TMPDIR/${d}backup.tar.gz" "$REMOTEUSER@$REMOTEHOST:$REMOTEPATH"
# Удаляем архив, чтобы не занимать пространство на диске без пользы
rm -f "$TMPDIR/${d}backup.tar.gz"
