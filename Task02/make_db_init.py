#!/usr/bin/env python3
import csv
import re
import os


def read_movies_data():
    """Чтение данных о фильмах из CSV файла"""
    movies_data = []
    with open('dataset/movies.csv', 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            # Извлекаем год из названия фильма
            title = row['title']
            year_match = re.search(r'\((\d{4})\)', title)
            year = year_match.group(1) if year_match else 'NULL'

            # Убираем год из названия
            clean_title = re.sub(r'\s*\(\d{4}\)', '', title)

            movies_data.append({
                'id': row['movieId'],
                'title': clean_title.replace("'", "''"),
                'year': year,
                'genres': row['genres'].replace("'", "''")
            })
    return movies_data


def read_ratings_data():
    """Чтение данных о рейтингах из CSV файла"""
    ratings_data = []
    with open('dataset/ratings.csv', 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            ratings_data.append({
                'user_id': row['userId'],
                'movie_id': row['movieId'],
                'rating': row['rating'],
                'timestamp': row['timestamp']
            })
    return ratings_data


def read_tags_data():
    """Чтение данных о тегах из CSV файла"""
    tags_data = []
    with open('dataset/tags.csv', 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            tags_data.append({
                'user_id': row['userId'],
                'movie_id': row['movieId'],
                'tag': row['tag'].replace("'", "''"),
                'timestamp': row['timestamp']
            })
    return tags_data


def read_users_data():
    """Чтение данных о пользователях из текстового файла"""
    users_data = []
    with open('dataset/users.txt', 'r', encoding='utf-8') as file:
        for line in file:
            parts = line.strip().split('|')
            if len(parts) >= 6:
                users_data.append({
                    'id': parts[0],
                    'name': parts[1].replace("'", "''"),
                    'email': parts[2].replace("'", "''"),
                    'gender': parts[3],
                    'register_date': parts[4],
                    'occupation': parts[5].replace("'", "''") if len(parts) > 5 else ''
                })
    return users_data


def generate_sql_script():
    """Генерация SQL скрипта для создания и заполнения базы данных"""

    # Чтение данных
    print("Чтение данных из файлов...")
    movies = read_movies_data()
    ratings = read_ratings_data()
    tags = read_tags_data()
    users = read_users_data()

    # Создание SQL скрипта
    sql_content = []

    # Удаление существующих таблиц
    sql_content.append("-- Удаление существующих таблиц")
    sql_content.append("DROP TABLE IF EXISTS movies;")
    sql_content.append("DROP TABLE IF EXISTS ratings;")
    sql_content.append("DROP TABLE IF EXISTS tags;")
    sql_content.append("DROP TABLE IF EXISTS users;")
    sql_content.append("")

    # Создание таблиц
    sql_content.append("-- Создание таблиц")
    sql_content.append("""
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genres TEXT
);
""")

    sql_content.append("""
CREATE TABLE ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating REAL NOT NULL,
    timestamp INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);
""")

    sql_content.append("""
CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    tag TEXT NOT NULL,
    timestamp INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);
""")

    sql_content.append("""
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);
""")
    sql_content.append("")

    # Вставка данных в таблицу movies
    sql_content.append("-- Вставка данных в таблицу movies")
    for movie in movies:
        sql = f"INSERT INTO movies (id, title, year, genres) VALUES ({movie['id']}, '{movie['title']}', {movie['year']}, '{movie['genres']}');"
        sql_content.append(sql)
    sql_content.append("")

    # Вставка данных в таблицу users
    sql_content.append("-- Вставка данных в таблицу users")
    for user in users:
        sql = f"INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES ({user['id']}, '{user['name']}', '{user['email']}', '{user['gender']}', '{user['register_date']}', '{user['occupation']}');"
        sql_content.append(sql)
    sql_content.append("")

    # Вставка данных в таблицу ratings
    sql_content.append("-- Вставка данных в таблицу ratings")
    for rating in ratings:
        sql = f"INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES ({rating['user_id']}, {rating['movie_id']}, {rating['rating']}, {rating['timestamp']});"
        sql_content.append(sql)
    sql_content.append("")

    # Вставка данных в таблицу tags
    sql_content.append("-- Вставка данных в таблицу tags")
    for tag in tags:
        sql = f"INSERT INTO tags (user_id, movie_id, tag, timestamp) VALUES ({tag['user_id']}, {tag['movie_id']}, '{tag['tag']}', {tag['timestamp']});"
        sql_content.append(sql)

    # Запись SQL скрипта в файл
    with open('db_init.sql', 'w', encoding='utf-8') as file:
        file.write('\n'.join(sql_content))

    print(f"SQL скрипт создан успешно!")
    print(f"Обработано:")
    print(f"  - Фильмы: {len(movies)} записей")
    print(f"  - Пользователи: {len(users)} записей")
    print(f"  - Рейтинги: {len(ratings)} записей")
    print(f"  - Теги: {len(tags)} записей")


if __name__ == "__main__":
    # Проверка существования файлов данных
    required_files = [
        'dataset/movies.csv',
        'dataset/ratings.csv',
        'dataset/tags.csv',
        'dataset/users.txt'
    ]

    for file_path in required_files:
        if not os.path.exists(file_path):
            print(f"Ошибка: Файл {file_path} не найден!")
            exit(1)

    generate_sql_script()