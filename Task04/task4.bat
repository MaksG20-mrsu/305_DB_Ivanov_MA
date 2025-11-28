@echo off
chcp 65001 >nul

echo "Создание базы данных movies_rating.db..."

sqlite3 movies_rating.db < db_init.sql

echo "База данных создана успешно!"
echo.
echo "Выполнение SQL-запросов..."
echo.

echo "1. Пары пользователей, оценивших один и тот же фильм:"
sqlite3 -header -column movies_rating.db "SELECT DISTINCT u1.name as user1_name, u2.name as user2_name, m.title as movie_title FROM ratings r1 JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id JOIN users u1 ON r1.user_id = u1.id JOIN users u2 ON r2.user_id = u2.id JOIN movies m ON r1.movie_id = m.id ORDER BY u1.name, u2.name, m.title LIMIT 10;"

echo.
echo "2. 10 самых старых оценок:"
sqlite3 -header -column movies_rating.db "SELECT m.title, u.name as user_name, r.rating, date(datetime(r.timestamp, 'unixepoch')) as review_date FROM ratings r JOIN movies m ON r.movie_id = m.id JOIN users u ON r.user_id = u.id ORDER BY r.timestamp ASC LIMIT 10;"

echo.
echo "3. Фильмы с максимальным и минимальным средним рейтингом:"
sqlite3 -header -column movies_rating.db "WITH avg_ratings AS ( SELECT m.id, m.title, m.year, AVG(r.rating) as avg_rating FROM movies m JOIN ratings r ON m.id = r.movie_id GROUP BY m.id, m.title, m.year HAVING COUNT(r.rating) >= 3 ), min_max_avg AS ( SELECT MIN(avg_rating) as min_rating, MAX(avg_rating) as max_rating FROM avg_ratings ) SELECT ar.title, ar.year, ar.avg_rating, CASE WHEN ar.avg_rating = (SELECT max_rating FROM min_max_avg) THEN 'Да' ELSE 'Нет' END as Рекомендуем FROM avg_ratings ar WHERE ar.avg_rating = (SELECT min_rating FROM min_max_avg) OR ar.avg_rating = (SELECT max_rating FROM min_max_avg) ORDER BY ar.year, ar.title;"

echo.
echo "4. Оценки от пользователей-мужчин (2011-2014):"
sqlite3 -header -column movies_rating.db "SELECT COUNT(*) as rating_count, ROUND(AVG(r.rating), 2) as avg_rating FROM ratings r JOIN users u ON r.user_id = u.id WHERE u.gender = 'male' AND strftime('%%Y', datetime(r.timestamp, 'unixepoch')) BETWEEN '2011' AND '2014';"

echo.
echo "5. Фильмы с средней оценкой и количеством пользователей:"
sqlite3 -header -column movies_rating.db "SELECT m.title, m.year, ROUND(AVG(r.rating), 2) as avg_rating, COUNT(DISTINCT r.user_id) as user_count FROM movies m JOIN ratings r ON m.id = r.movie_id GROUP BY m.id, m.title, m.year ORDER BY m.year, m.title LIMIT 20;"

echo.
echo "6. Самый распространенный жанр:"
sqlite3 -header -column movies_rating.db "WITH split_genres AS ( SELECT CASE WHEN genres LIKE '%%|%%' THEN substr(genres, 1, instr(genres, '|') - 1) ELSE genres END as genre FROM movies WHERE genres != '(no genres listed)' ), genre_counts AS ( SELECT genre, COUNT(*) as movie_count FROM split_genres GROUP BY genre ) SELECT genre, movie_count FROM genre_counts ORDER BY movie_count DESC LIMIT 1;"

echo.
echo "7. 10 последних зарегистрированных пользователей:"
sqlite3 -header -column movies_rating.db "SELECT name as full_name, register_date FROM users ORDER BY register_date DESC LIMIT 10;"

echo.
echo "8. Дни недели дней рождения (15 мая):"
sqlite3 -header -column movies_rating.db "WITH RECURSIVE birthday_days(year, birthday_date) AS ( SELECT 1990, date('1990-05-15') UNION ALL SELECT year + 1, date((year + 1) || '-05-15') FROM birthday_days WHERE year < 2024 ) SELECT year, birthday_date, CASE strftime('%%w', birthday_date) WHEN '0' THEN 'Воскресенье' WHEN '1' THEN 'Понедельник' WHEN '2' THEN 'Вторник' WHEN '3' THEN 'Среда' WHEN '4' THEN 'Четверг' WHEN '5' THEN 'Пятница' WHEN '6' THEN 'Суббота' END as day_of_week FROM birthday_days;"

echo.
echo "Все запросы выполнены успешно!"
pause