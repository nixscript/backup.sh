# backup.sh
Shell for backup some files/dirs to remote computer

[![Build Status](https://travis-ci.org/nixscript/backup.sh.svg?branch=master)](https://travis-ci.org/nixscript/backup.sh)
[![GitHub License](https://img.shields.io/github/license/nixscript/backup.sh.svg)](https://github.com/nixscript/backup.sh/blob/master/LICENSE.md)
[![GitHub Release](https://img.shields.io/github/release/nixscript/backup.sh.svg)](https://github.com/nixscript/backup.sh/releases)

## setup on target computer
Download scripts archive, extract, enter to extracted directory and run `sudo make install`.

Answer correct on the questions. You must set exist paths of remote computer! It's important!

After that you can see task string for the remote computer, or you can copy script ./clearbckp.sh to remote computer and add a task for cron.

## on remote computer
* Add task
* Restart cron: `systemctl restart cron`

# backup.sh
Скрипт для бекапа файлов/директорий на удалённый комп.

## установка на компе, с которого сохраняем
Скачайте и распакуйте архив, перейдите в распакованную папку и выполните команду `sudo make install`.

Правильно ответьте на вопросы скрипта. Укажите существующие пути на удалённой машине! Это очень важно!

После этого вы увидите строку для включения в cron на удалённом компе, или можете скопировать ./clearbckp.sh на удалённый комп и добавить задачу с ним.

## на удалённом компе
* Добавьте задачу в cron
* Перезапустите cron: `systemctl restart cron`
