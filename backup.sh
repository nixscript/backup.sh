#!/bin/bash
# https://github.com/nixscript/backup.sh

# shellcheck source=/dev/null
source <(grep "=" /usr/local/etc/backup.sh/backup.cfg)

if [[ $1 == "-c" || $1 == "--config" ]]; then
	if [[ $LANG == "ru_RU.UTF-8" ]]; then
		echo "Укажите логин удалённой машины:"
	else
		echo "Type login for the remote computer:"
	fi
	read -r REMOTEUSER
	if [[ -z "$REMOTEUSER" ]]; then
	        echo -e "\\e[33;1mWRONG! Run script again and type login correct!\\[0m"
	        exit
	fi
	if [[ $LANG == "ru_RU.UTF-8" ]]; then
		echo "Укажите имя удалённой машины или IP-адрес:"
	else
		echo "Type remote host name or IP for the remote computer:"
	fi
	read -r REMOTEHOST
	if [[ -z "$REMOTEHOST" ]]; then
	        echo -e "\\e[33;1mWRONG! Run script again and type remote host correct!\\[0m"
	        exit
	fi
	if [[ $LANG == "ru_RU.UTF-8" ]]; then
		echo "Укажите путь для бекапов на удалённой машине [/home/$REMOTEUSER/backups/]:"
	else
		echo "Type remote path for backups on the remote computer [/home/$REMOTEUSER/backups/]:"
	fi
	read -r REMOTEPATH
	if [[ -z "$REMOTEPATH" ]]; then
	        REMOTEPATH="/home/$REMOTEUSER/backups/"
	fi
	if [[ $LANG == "ru_RU.UTF-8" ]]; then
		echo "Укажите абсолютные пути к файлам и директориям, которые нужно бекапить, через пробел [Пример: /var/www/ /etc/apache2/sites-avialable]:"
	else
		echo "Type absolute paths files/dirs to backaup over space [example: /var/www /etc/apache2/sites-avialable]:"
	fi
	read -r TARGETS
	if [[ -z "$TARGETS" ]]; then
	        echo -e "\\e[33;1mWRONG! You must type some paths for backup! Run again.\\e[0m"
	        exit
	fi
	if [[ $LANG == "ru_RU.UTF-8" ]]; then
		echo "Как вы хотите создавать бекапы?
		1. Полный архив
		2. Только изменения за последние сутки
Введите порядковый номер [default: 1]:"
	else
		echo "Choice method for creating backup
		1. Full archive
		2. Only updates
Type the number [default: 1]:"
	fi
	read -rn 1 TARCHS
	if [[ -z $TARCHS ]]; then
		TARCHS=1
	elif [[ $TARCHS != "1" && $TARCHS != "2" ]]; then
		echo -e "\\e[31;1mWRONG! You must specify the number 1 or 2! Run again.\\e[0m"
		exit
	fi
	if [[ $TARCHS == "1" ]]; then
		if [[ $LANG == "ru_RU.UTF-8" ]]; then
			echo "Укажите существующий путь для скрипта clearbckp.sh на удалённой машине [/home/$REMOTEUSER/bin/]:"
		else
			echo "Type exists path for clearbckp.sh on the remote computer [/home/$REMOTEUSER/bin/]:"
		fi
		read -r RPATH
		if [[ -z "$RPATH" ]]; then
			RPATH="/home/$REMOTEUSER/bin"
		fi
	fi

	if [[ ! -f "$HOME/.ssh/id_rsa.pub" ]]; then
	# Generate ssh-key for connect to remote computer
	        ssh-keygen -t rsa
	fi
	
	# Copy public ssh-key to remote computer (need remote password)
	scp "$HOME/.ssh/id_rsa.pub" "$REMOTEUSER@$REMOTEHOST:/home/$REMOTEUSER/.ssh/authorized_keys"
	
	# Change params into scripts
	sed -i "s%REMOTEUSER=\"user\"%REMOTEUSER=\"$REMOTEUSER\"%; s%REMOTEHOST=\"example.com\"%REMOTEHOST=\"$REMOTEHOST\"%; s%REMOTEPATH=\"/home/backupsdir/\"%REMOTEPATH=\"$REMOTEPATH\"%; s%TARGETS=\"/var/www\"%TARGETS=\"$TARGETS\"%; s%TARCHS=\"1\"%TARCHS=\"$TARCHS\"%" /usr/local/etc/backup.sh/backup.cfg
	if [[ $TARCHS == "1" ]]; then
		{
			echo '#!/bin/bash'
			echo "find ${REMOTEPATH}* -mtime +7 -exec rm {} \\;"
		} >> clearbckp.sh
		chmod +x clearbckp.sh
		scp -B clearbckp.sh "$REMOTEUSER@$REMOTEHOST:$RPATH"
		rm -f clearbckp.sh
		echo -e "\\e[32;1mScript clearbckp.sh copyed on the remote computer to $RPATH\\e[0m"
	fi
	echo '#!/bin/bash' > /etc/cron.daily/backup_sh
	{
		echo "# shellcheck source=/dev/null"
		echo "source <(grep \"=\" /usr/local/etc/backup.sh/backup.cfg)"
		echo "d=\$(date +%F)"
		echo "if [[ \$TARCHS == \"1\" ]]; then"
		echo "	CMD=\"tar -cvf - \$TARGETS\""
		echo "	\$CMD | xz -9 --threads=0 - > \"\$TMPDIR/\${d}backup.tar.xz\""
		echo "else"
		echo "	LIST=\"\""
		echo "	for i in \$TARGETS"
		echo "	do"
		echo "		L=\$(find \"\$i\" -type f -mtime -1)"
		echo "		LIST=\"\$LIST"
		echo "\$L\""
		echo "	done"
		printf "	LIST=\$(echo \"\$LIST\" | tr \"\\\n\" \" \")\n"
		echo "	CMD=\"tar -cvf - \${LIST:1:-1}\""
		echo "	\$CMD | xz -9 --threads=0 - > \"\$TMPDIR/\${d}backup.tar.xz\""
		echo "fi"
		echo "scp -B \"\$TMPDIR/\${d}backup.tar.xz\" \"$REMOTEUSER@$REMOTEHOST:$REMOTEPATH\""
		echo "rm -f \"\$TMPDIR/\${d}backup.tar.xz\""
	} >> /etc/cron.daily/backup_sh
	chmod +x /etc/cron.daily/backup_sh

	if [[ -f /lib/systemd/system/cron.service ]]; then
		systemctl restart cron
	elif [[ -f /lib/systemd/system/crond.service ]]; then
		systemctl restart crond
	else
		echo -e "\\e[31;1mWarning! You must restart cron!\n\\e[0m"
	fi
	if [[ $TARCHS == "1" ]]; then
		echo -e "\\e[32;1mAdd crontab task on the remote computer like that:\n\\e[31;1m	0 1 * * * find $REMOTEPATH -mtime +7 -exec rm {} \\;\n\\e[32;1mOr copy file ./clearbckp.sh on the remote computer and add to crontab tasks.\\e[0m\n\n"
	else
		echo "On the remote computer you not need delete any archives. You should not adding task for cron."
	fi
	exit
elif [[ $1 == "-f" || $1 == "--first" ]]; then
	tar -cvf - "$TARGETS" | xz -9 --threads=0 - > "first-backup.tar.xz"
elif [[ ! -z $1 ]]; then
	echo "Usage: backup.sh -c
	backup.sh --config

	"
	exit
else
# Загоняем текущую дату в переменную
	d=$(date +%F)
	if [[ $TARCHS == "1" ]]; then
# Упаковываем файлы и прочее в TAR и XZ с максимальным сжатием
		tar -cvf - "$TARGETS" | xz -9 --threads=0 - > "$TMPDIR/${d}backup.tar.xz"
# Отправляем на удалённую машину
	elif [[ $TARCHS == "2" ]];then
		LIST=""
		for i in $TARGETS
		do
			L=$(find "$i" -type f -mtime -1)
			LIST="$LIST
$L"
		done
		LIST=$(echo "$LIST" | tr "\n" " ")
		CMD="tar -cvf - ${LIST:1:-1}"
		$CMD | xz -9 --threads=0 - > "$TMPDIR/${d}backup.tar.xz"
	else
		exit
	fi
# Отправляем на удалённую машину
	scp -B "$TMPDIR/${d}backup.tar.xz" "$REMOTEUSER@$REMOTEHOST:$REMOTEPATH"
		
# Удаляем архив, чтобы не занимать пространство на диске без пользы
	rm -f "$TMPDIR/${d}backup.tar.xz"
fi
