all:
		@ echo "Nothing to compile. Use: sudo make install, sudo make uninstall"

install:
		echo "Test"
		install -m0755 ./backup.sh /usr/local/bin/backup.sh
		install -d /usr/local/etc/backup.sh
		install -m0644 ./backup.cfg /usr/local/etc/backup.sh/backup.cfg
		@ /usr/local/bin/backup.sh -c

uninstall:
		rm -fv /usr/local/bin/backup.sh
		rm -rfv /usr/local/etc/backup.sh/
		rm -fv /etc/cron.daily/backup_sh
