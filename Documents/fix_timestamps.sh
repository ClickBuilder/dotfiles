#!/bin/bash

TARGET_DIR="${1:-.}"

count=0
errors=0

for filepath in "$TARGET_DIR"/*.jpg "$TARGET_DIR"/*.jpeg "$TARGET_DIR"/*.png; do
    [ -f "$filepath" ] || continue

    filename=$(basename "$filepath")
    dir=$(dirname "$filepath")

    # Извлекаем дату и время из имени файла
    if [[ "$filename" =~ @([0-9]{2})-([0-9]{2})-([0-9]{4})_([0-9]{2})-([0-9]{2})-([0-9]{2}) ]]; then
        day="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        year="${BASH_REMATCH[3]}"
        hour="${BASH_REMATCH[4]}"
        min="${BASH_REMATCH[5]}"
        sec="${BASH_REMATCH[6]}"

        touch_date="${year}-${month}-${day} ${hour}:${min}:${sec}"

        # Переименовываем: заменяем @ на _
        new_filename="${filename/@/_}"
        new_filepath="$dir/$new_filename"

        # Переименовываем файл
        if mv "$filepath" "$new_filepath"; then
            # Меняем дату
            if touch -d "$touch_date" "$new_filepath"; then
                ((count++))
            else
                echo "ОШИБКА (дата): $new_filename"
                ((errors++))
            fi
        else
            echo "ОШИБКА (переименование): $filename"
            ((errors++))
        fi
    fi
done

echo ""
echo "✅ Обработано: $count файлов"
echo "❌ Ошибок: $errors"
