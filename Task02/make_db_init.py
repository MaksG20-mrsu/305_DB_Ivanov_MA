#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import csv
import sqlite3
from datetime import datetime


def ensure_dataset_directory():
    """Проверяет существование каталога dataset и создает его если нужно"""
    if not os.path.exists('dataset'):
        print("Warning: 'dataset' directory not found. Creating it...")
        os.makedirs('dataset')
        print("Please place your data files (movies.txt, ratings.txt, tags.txt, users.txt) in the 'dataset' directory")
        return False
    return True


def check_data_files():
    """Проверяет наличие всех необходимых файлов данных"""
    required_files = ['movies.txt', 'ratings.txt', 'tags.txt', 'users.txt']
    missing_files = []

    for filename in required_files:
        filepath = os.path.join('dataset', filename)
        if not os.path.exists(filepath):
            missing_files.append(filename)

    if missing_files:
        print("Error: Missing data files:")
        for filename in missing_files:
            print(f"  - {filename}")
        print("\nPlease make sure all data files are in the 'dataset' directory")
        return False

    return True


def read_dataset_file(filename):
    """Чтение файла dataset и возвращение данных"""
    filepath = os.path.join('dataset', filename)

    # Проверка существования файла
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"Data file not found: {filepath}")

    data = []
    try:
        with open(filepath, 'r', encoding='utf-8') as file:
            reader = csv.reader(file, delimiter='|')
            for row in reader:
                # Пропускаем пустые строки
                if row and any(field.strip() for field in row):
                    data.append(row)
        print(f"  Read {len(data)} rows from {filename}")
    except Exception as e:
        print(f"Error reading {filename}: {e}")
        raise

    return data


def escape_sql_value(value):
    """Экранирование значений для SQL"""
    if value is None:
        return 'NULL'

    value_str = str(value).replace("'", "''")
    return f"'{value_str}'"


def generate_sql_script():
    """Генерация SQL скрипта для создания и заполнения БД"""

    print("Reading data files...")

    # Чтение данных из файлов
    movies_data = read_dataset_file('movies.txt')
    ratings_data = read_dataset_file('ratings.txt')
    tags_data = read_dataset_file('tags.txt')
    users_data = read_dataset_file('users.txt')

    sql_script = []

    # Добавляем заголовок с комментарием
    sql_script.append("-- SQL script generated automatically")
    sql_script.append(f"-- Generated at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    sql_script.append("")

    # Удаление существующих таблиц
    sql_script.append("-- Drop existing tables if they exist")
    sql_script.append("DROP TABLE IF EXISTS movies;")
    sql_script.append("DROP TABLE IF EXISTS ratings;")
    sql_script.append("DROP TABLE IF EXISTS tags;")
    sql_script.append("DROP TABLE IF EXISTS users;")
    sql_script.append("")

    # Создание таблиц
    sql_script.append("-- Create tables")

    # Таблица movies
    sql_script.append("""
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genres TEXT
);
""")

    # Таблица ratings
    sql_script.append("""
CREATE TABLE ratings (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating REAL NOT NULL,
    timestamp INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);
""")

    # Таблица tags
    sql_script.append("""
CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    tag TEXT NOT NULL,
    timestamp INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);
""")

    # Таблица users
    sql_script.append("""
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);
""")

    sql_script.append("")

    # Вставка данных в таблицу movies
    print("Generating INSERT statements for movies...")
    sql_script.append("-- Insert data into movies table")
    for i, row in enumerate(movies_data):
        if len(row) >= 4:
            try:
                movie_id = int(row[0])
                title = escape_sql_value(row[1])
                year = int(row[2]) if row[2].strip() and row[2].strip().isdigit() else 'NULL'
                genres = escape_sql_value(row[3]) if row[3].strip() else 'NULL'

                sql_script.append(
                    f"INSERT INTO movies (id, title, year, genres) VALUES ({movie_id}, {title}, {year}, {genres});")
            except (ValueError, IndexError) as e:
                print(f"Warning: Skipping invalid movie data at row {i}: {row} - Error: {e}")

    sql_script.append("")

    # Вставка данных в таблицу users
    print("Generating INSERT statements for users...")
    sql_script.append("-- Insert data into users table")
    for i, row in enumerate(users_data):
        if len(row) >= 6:
            try:
                user_id = int(row[0])
                name = escape_sql_value(row[1])
                email = escape_sql_value(row[2]) if row[2].strip() else 'NULL'
                gender = escape_sql_value(row[3]) if row[3].strip() else 'NULL'
                register_date = escape_sql_value(row[4]) if row[4].strip() else 'NULL'
                occupation = escape_sql_value(row[5]) if row[5].strip() else 'NULL'

                sql_script.append(
                    f"INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES ({user_id}, {name}, {email}, {gender}, {register_date}, {occupation});")
            except (ValueError, IndexError) as e:
                print(f"Warning: Skipping invalid user data at row {i}: {row} - Error: {e}")

    sql_script.append("")

    # Вставка данных в таблицу ratings
    print("Generating INSERT statements for ratings...")
    sql_script.append("-- Insert data into ratings table")
    for i, row in enumerate(ratings_data):
        if len(row) >= 5:
            try:
                rating_id = int(row[0])
                user_id = int(row[1])
                movie_id = int(row[2])
                rating = float(row[3])
                timestamp = int(row[4])

                sql_script.append(
                    f"INSERT INTO ratings (id, user_id, movie_id, rating, timestamp) VALUES ({rating_id}, {user_id}, {movie_id}, {rating}, {timestamp});")
            except (ValueError, IndexError) as e:
                print(f"Warning: Skipping invalid rating data at row {i}: {row} - Error: {e}")

    sql_script.append("")

    # Вставка данных в таблицу tags
    print("Generating INSERT statements for tags...")
    sql_script.append("-- Insert data into tags table")
    for i, row in enumerate(tags_data):
        if len(row) >= 5:
            try:
                tag_id = int(row[0])
                user_id = int(row[1])
                movie_id = int(row[2])
                tag = escape_sql_value(row[3])
                timestamp = int(row[4])

                sql_script.append(
                    f"INSERT INTO tags (id, user_id, movie_id, tag, timestamp) VALUES ({tag_id}, {user_id}, {movie_id}, {tag}, {timestamp});")
            except (ValueError, IndexError) as e:
                print(f"Warning: Skipping invalid tag data at row {i}: {row} - Error: {e}")

    sql_script.append("")
    sql_script.append("-- End of SQL script")

    return '\n'.join(sql_script)


def main():
    """Основная функция"""
    print("Starting SQL script generation...")

    # Проверка каталога dataset
    if not ensure_dataset_directory():
        print("Please create the 'dataset' directory and place your data files there.")
        return

    # Проверка наличия файлов данных
    if not check_data_files():
        return

    try:
        # Генерация SQL скрипта
        sql_content = generate_sql_script()

        # Запись SQL скрипта в файл
        with open('db_init.sql', 'w', encoding='utf-8') as sql_file:
            sql_file.write(sql_content)

        print("\nSQL script 'db_init.sql' has been generated successfully!")
        print(f"Script contains {len(sql_content.splitlines())} lines")

    except Exception as e:
        print(f"Error during SQL script generation: {e}")
        return


if __name__ == "__main__":
    main()