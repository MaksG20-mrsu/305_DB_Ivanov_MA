#!/bin/bash

# Скрипт инициализации базы данных movies_rating.db
# Автоматически создает таблицы и заполняет их данными

echo "Starting database initialization..."
echo "Current directory: $(pwd)"

# Проверка наличия каталога dataset
if [ ! -d "dataset" ]; then
    echo "Error: 'dataset' directory not found!"
    echo "Please create 'dataset' directory and place data files there:"
    echo "  - movies.txt"
    echo "  - ratings.txt" 
    echo "  - tags.txt"
    echo "  - users.txt"
    exit 1
fi

# Проверка наличия файлов данных
missing_files=0
for file in movies.txt ratings.txt tags.txt users.txt; do
    if [ ! -f "dataset/$file" ]; then
        echo "Error: Missing data file: dataset/$file"
        missing_files=1
    fi
done

if [ $missing_files -ne 0 ]; then
    echo "Please make sure all data files are present in the dataset directory"
    exit 1
fi

# Генерация SQL скрипта
echo "Generating SQL script..."
python3 make_db_init.py

# Проверка успешности генерации SQL скрипта
if [ $? -eq 0 ]; then
    echo "SQL script generated successfully"
else
    echo "Error: Failed to generate SQL script"
    exit 1
fi

# Проверка существования сгенерированного SQL файла
if [ ! -f "db_init.sql" ]; then
    echo "Error: SQL script 'db_init.sql' was not created"
    exit 1
fi

# Загрузка SQL скрипта в базу данных
echo "Loading SQL script into database..."
sqlite3 movies_rating.db < db_init.sql

# Проверка успешности выполнения SQL скрипта
if [ $? -eq 0 ]; then
    echo "Database 'movies_rating.db' has been created and populated successfully!"
    
    # Дополнительная проверка - вывод информации о созданных таблицах
    echo ""
    echo "Verifying database structure..."
    echo "Tables in database:"
    sqlite3 movies_rating.db ".tables"
    
    echo ""
    echo "Table row counts:"
    sqlite3 movies_rating.db "SELECT 'movies: ' || COUNT(*) FROM movies;"
    sqlite3 movies_rating.db "SELECT 'users: ' || COUNT(*) FROM users;"
    sqlite3 movies_rating.db "SELECT 'ratings: ' || COUNT(*) FROM ratings;"
    sqlite3 movies_rating.db "SELECT 'tags: ' || COUNT(*) FROM tags;"
    
else
    echo "Error: Failed to execute SQL script"
    exit 1
fi

echo ""
echo "Database initialization completed!"