# backup.sh
Shell for backup some files/dirs to remote computer

## setup on target computer
Download scripts archive, extract, enter to extracted directory and run `sudo bash ./setup.sh`.

Answer correct on the questions. You must set exist paths of remote computer! It's important!

## on remote computer
Run `crontab -e` and add next string:

`0 1 * * * $RPATH/clearbckp.sh`

Where $RPATH is absolute path to script clearbckp.sh

# backup.sh
Скрипт для бекапа файлов/директорий на удалённый комп.

## установка на компе, с которого сохраняем
Скачайте и распакуйте архив, перейдите в распакованную папку и выполните команду `sudo bash ./setup.sh`.

Правильно ответьте на вопросы скрипта. Укажите существующие пути на удалённой машине! Это очень важно!

## на удалённом компе
Выполните `crontab -e` и добавьте следующую строку:

`0 1 * * * $RPATH/clearbckp.sh`

Где $RPATH - абсолютный путь к скрипту clearbckp.sh
