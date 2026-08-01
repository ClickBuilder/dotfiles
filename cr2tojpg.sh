#!/bin/bash

# Проверка аргумента
if [ -z "$1" ]; then
    echo "Использование: cr2tojpg 9823"
    exit 1
fi

NUM="$1"

INPUT="$HOME/Pictures/cr2/IMG_${NUM}.CR2"
OUTPUT="$HOME/Pictures/IMG_${NUM}_redacted.jpg"

# Проверка файла
if [ ! -f "$INPUT" ]; then
    echo "Файл не найден: $INPUT"
    exit 1
fi

echo "Конвертация..."
darktable-cli \
"$INPUT" \
"$OUTPUT" \
--hq true \
--core --disable-opencl

echo "Готово:"
echo "$OUTPUT"
