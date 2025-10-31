@echo off
chcp 65001 > nul

echo Creating database and tables...
sqlite3 movies_rating.db < db_init.sql

echo.
echo 1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT DISTINCT m.id, m.title, m.year FROM movies m JOIN ratings r ON m.id = r.movie_id ORDER BY m.year, m.title LIMIT 10;"

echo.
echo 2. Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT id, name, email, gender, register_date, occupation FROM users WHERE name LIKE '% A%' OR name LIKE 'A%' ORDER BY register_date LIMIT 5;"

echo.
echo 3. Написать запрос, возвращающий информацию о рейтингах в более читаемом формате: имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. Отсортировать данные по имени эксперта, затем названию фильма и оценке. В списке оставить первые 50 записей.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT u.name AS expert_name, m.title AS movie_title, m.year AS release_year, r.rating, datetime(r.timestamp, 'unixepoch') AS rating_date FROM ratings r JOIN users u ON r.user_id = u.id JOIN movies m ON r.movie_id = m.id ORDER BY u.name, m.title, r.rating LIMIT 50;"

echo.
echo 4. Вывести список фильмов с указанием тегов, которые были им присвоены пользователями. Сортировать по году выпуска, затем по названию фильма, затем по тегу. В списке оставить первые 40 записей.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT m.title, m.year, t.tag, u.name AS user_name FROM movies m JOIN tags t ON m.id = t.movie_id JOIN users u ON t.user_id = u.id ORDER BY m.year, m.title, t.tag LIMIT 40;"

echo.
echo 5. Вывести список самых свежих фильмов. В список должны войти все фильмы последнего года выпуска, имеющиеся в базе данных. Запрос должен быть универсальным, не зависящим от исходных данных.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT id, title, year, genres FROM movies WHERE year = (SELECT MAX(year) FROM movies) ORDER BY title;"

echo.
echo 6. Найти все драмы, выпущенные после 2005 года, которые понравились женщинам (оценка не ниже 4.5). Для каждого фильма в этом списке вывести название, год выпуска и количество таких оценок.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT m.title, m.year, COUNT(r.rating) AS high_ratings_count FROM movies m JOIN ratings r ON m.id = r.movie_id JOIN users u ON r.user_id = u.id WHERE m.genres LIKE '%Drama%' AND m.year > 2005 AND r.rating >= 4.5 AND u.gender = 'F' GROUP BY m.id, m.title, m.year ORDER BY m.year, m.title;"

echo.
echo 7. Провести анализ востребованности ресурса - вывести количество пользователей, регистрировавшихся на сайте в каждом году.
echo --------------------------------------------------
sqlite3 movies_rating.db "SELECT SUBSTR(register_date, 1, 4) AS registration_year, COUNT(*) AS user_count FROM users WHERE register_date IS NOT NULL AND register_date != '' GROUP BY registration_year ORDER BY user_count DESC;"

echo.
echo Годы с наибольшим и наименьшим количеством регистраций:
echo --------------------------------------------------
sqlite3 movies_rating.db "WITH YearlyCounts AS ( SELECT SUBSTR(register_date, 1, 4) AS registration_year, COUNT(*) AS user_count FROM users WHERE register_date IS NOT NULL AND register_date != '' GROUP BY registration_year ) SELECT registration_year, user_count, 'MAX' AS type FROM YearlyCounts WHERE user_count = (SELECT MAX(user_count) FROM YearlyCounts) UNION ALL SELECT registration_year, user_count, 'MIN' AS type FROM YearlyCounts WHERE user_count = (SELECT MIN(user_count) FROM YearlyCounts) ORDER BY type DESC, registration_year;"

pause