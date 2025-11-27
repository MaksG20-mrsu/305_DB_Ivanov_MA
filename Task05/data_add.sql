-- Добавление пяти новых пользователей (себя и четырех соседей по группе)
INSERT OR IGNORE INTO users (name, email, gender, register_date, occupation_id) 
VALUES 
('Ivanov Maxim', 'ivanov.maxim@gmail.com', 'male', datetime('now'), 
 (SELECT id FROM occupations WHERE name = 'student')),
('Zubkov Roman', 'zubkov.roman@gmail.com', 'male', datetime('now'), 
 (SELECT id FROM occupations WHERE name = 'student')),
('Ivenin Artem', 'ivenin.artem@gmail.com', 'male', datetime('now'), 
 (SELECT id FROM occupations WHERE name = 'student')),
('Kochnev Artem', 'kochnev.artem@gmail.com', 'male', datetime('now'), 
 (SELECT id FROM occupations WHERE name = 'student')),
('Logunov Ilya', 'logunov.ilya@gmail.com', 'male', datetime('now'), 
 (SELECT id FROM occupations WHERE name = 'student'));

-- Добавление трех новых фильмов разных жанров
INSERT OR IGNORE INTO movies (title, year) 
VALUES 
('Interstellar', 2014),
('Beginning', 2010),
('Escape from Shawshank', 1994);

-- Связывание фильмов с жанрами (ИСПРАВЛЕНО: используем INSERT OR IGNORE)
INSERT OR IGNORE INTO movie_genres (movie_id, genre_id)
SELECT 
    m.id, 
    g.id
FROM movies m
CROSS JOIN genres g
WHERE (m.title = 'Interstellar' AND g.name IN ('Sci-Fi', 'Adventure', 'Drama'))
   OR (m.title = 'Beginning' AND g.name IN ('Action', 'Sci-Fi', 'Thriller'))
   OR (m.title = 'Escape from Shawshank' AND g.name = 'Drama');

-- Добавление отзывов от себя (ИСПРАВЛЕНО: используем INSERT OR IGNORE)
INSERT OR IGNORE INTO ratings (user_id, movie_id, rating, timestamp) 
SELECT 
    (SELECT id FROM users WHERE name = 'Ivanov Maxim'),
    m.id,
    CASE 
        WHEN m.title = 'Interstellar' THEN 5.0
        WHEN m.title = 'Beginning' THEN 4.5
        WHEN m.title = 'Escape from Shawshank' THEN 5.0
    END,
    strftime('%s', 'now')
FROM movies m
WHERE m.title IN ('Interstellar', 'Beginning', 'Escape from Shawshank');

-- Добавление тегов от себя (ИСПРАВЛЕНО: используем INSERT OR IGNORE)
INSERT OR IGNORE INTO tags (user_id, movie_id, tag, timestamp) 
SELECT 
    (SELECT id FROM users WHERE name = 'Ivanov Maxim'),
    m.id,
    CASE 
        WHEN m.title = 'Interstellar' THEN 'epic'
        WHEN m.title = 'Beginning' THEN 'complicated plot'
        WHEN m.title = 'Escape from Shawshank' THEN 'masterpiece'
    END,
    strftime('%s', 'now')
FROM movies m
WHERE m.title IN ('Interstellar', 'Beginning', 'Escape from Shawshank');