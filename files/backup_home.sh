#!/bin/bash

# Директории
SRC="/home/danko2/"
DEST="/tmp/backup/"

# Лог для записи результата
LOG="/var/log/backup_home.log"

# Выполнение rsync с исключением скрытых директорий и использованием хэшей
rsync -a --delete --exclude='.*' --checksum "$SRC" "$DEST"
STATUS=$?

if [ $STATUS -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Резервное копирование выполнено успешно" >> "$LOG"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Ошибка при выполнении резервного копирования, код возврата: $STATUS" >> "$LOG"
fi