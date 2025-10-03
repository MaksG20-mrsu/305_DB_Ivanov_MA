-- SQL script generated automatically
-- Generated at: 2025-10-03 18:15:00

-- Drop existing tables if they exist
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS users;

-- Create tables

CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genres TEXT
);


CREATE TABLE ratings (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating REAL NOT NULL,
    timestamp INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);


CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    tag TEXT NOT NULL,
    timestamp INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);


CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);


-- Insert data into movies table

-- Insert data into users table

-- Insert data into ratings table

-- Insert data into tags table

-- End of SQL script