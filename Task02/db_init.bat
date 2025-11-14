#!/bin/bash

echo "=== Запуск процесса ETL ==="
echo "Генерация SQL скрипта..."

# Запуск Python скрипта для генерации SQL
python3 make_db_init.py

if [ $? -ne 0 ]; then
    echo "Ошибка при генерации SQL скрипта!"
    exit 1
fi

echo "Создание базы данных..."

# Удаление существующей базы данных (если есть)
if [ -f "movies_rating.db" ]; then
    rm movies_rating.db
    echo "Старая база данных удалена."
fi

# Загрузка SQL скрипта в базу данных
sqlite3 movies_rating.db < db_init.sql

if [ $? -eq 0 ]; then
    echo "База данных успешно создана и заполнена!"
    echo "Файл: movies_rating.db"
    
    # Проверка содержимого базы данных
    echo ""
    echo "Проверка созданных таблиц:"
    sqlite3 movies_rating.db ".tables"
    
    echo ""
    echo "Количество записей в таблицах:"
    sqlite3 movies_rating.db "SELECT 'movies: ' || COUNT(*) FROM movies;"
    sqlite3 movies_rating.db "SELECT 'users: ' || COUNT(*) FROM users;"
    sqlite3 movies_rating.db "SELECT 'ratings: ' || COUNT(*) FROM ratings;"
    sqlite3 movies_rating.db "SELECT 'tags: ' || COUNT(*) FROM tags;"
else
    echo "Ошибка при создании базы данных!"
    exit 1
fi