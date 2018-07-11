# backup.sh
Shell for backup some files/dirs to remote computer

[![Build Status](https://travis-ci.org/nixscript/backup.sh.svg?branch=master)](https://travis-ci.org/nixscript/backup.sh)
[![GitHub License](https://img.shields.io/github/license/nixscript/backup.sh.svg)](https://github.com/nixscript/backup.sh/blob/master/LICENSE.md)
[![GitHub Release](https://img.shields.io/github/release/nixscript/backup.sh.svg)](https://github.com/nixscript/backup.sh/releases)

## setup on target computer
Download scripts archive, extract, enter to extracted directory and run `sudo make install`.

Answer correct on the questions. You must set exist paths of remote computer! It's important!

If You choice only updates, You should not adding task for cron on the remote computer.

Else, You can see task string for the remote computer, or you can copy script ./clearbckp.sh to remote computer and add a task for cron.

## on remote computer
If You choice full archive:

* Add task
* Restart cron: `systemctl restart cron`

## Uninstall
Run `sudo make uninstall` in source directory.

# backup.sh
Скрипт для бекапа файлов/директорий на удалённый комп.

## установка на компе, с которого сохраняем
Скачайте и распакуйте архив, перейдите в распакованную папку и выполните команду `sudo make install`.

Правильно ответьте на вопросы скрипта. Укажите существующие пути на удалённой машине! Это очень важно!

Если вы выбрали только изменения, не следует добавлять задачу в cron на удалённом компе.

Иначе вы увидите строку для включения в cron на удалённом компе, или можете скопировать ./clearbckp.sh на удалённый комп и добавить задачу с ним.

## на удалённом компе
Если выбрали полный архив:

* Добавьте задачу в cron
* Перезапустите cron: `systemctl restart cron`

## Удаление
Выполните `sudo make uninstall` в директории с исходниками.
