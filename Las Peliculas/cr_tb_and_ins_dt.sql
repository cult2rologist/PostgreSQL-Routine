-- Создание таблицы для фильмов
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    year INTEGER,
    genre VARCHAR(50),
    director VARCHAR(100),
    rating DECIMAL(3,1)
);

-- Вставка данных о фильмах
INSERT INTO movies (title, year, genre, director, rating)
VALUES
    ('The Shawshank Redemption', 1994, 'Drama', 'Frank Darabont', 9.3),
    ('The Godfather', 1972, 'Crime, Drama', 'Francis Ford Coppola', 9.2),
    ('The Dark Knight', 2008, 'Action, Crime, Drama', 'Christopher Nolan', 9.0),
    ('Pulp Fiction', 1994, 'Crime, Drama', 'Quentin Tarantino', 8.9),
    ('The Lord of the Rings: The Return of the King', 2003, 'Action, Adventure, Drama', 'Peter Jackson', 8.9),
    ('Forrest Gump', 1994, 'Drama, Romance', 'Robert Zemeckis', 8.8),
    ('Schindler''s List', 1993, 'Biography, Drama, History', 'Steven Spielberg', 8.9),
    ('Inception', 2010, 'Action, Adventure, Sci-Fi', 'Christopher Nolan', 8.8),
    ('The Matrix', 1999, 'Action, Sci-Fi', 'Lana Wachowski, Lilly Wachowski', 8.7),
    ('Fight Club', 1999, 'Drama', 'David Fincher', 8.8);
	
-- Создание таблицы для рейтингов фильмов
CREATE TABLE ratings (
    rating_id SERIAL PRIMARY KEY,
    movie_id INTEGER REFERENCES movies(movie_id),
    user_id INTEGER,
    user_rating INTEGER,
    CONSTRAINT fk_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);


-- Вставка данных о рейтингах
INSERT INTO ratings (movie_id, user_id, user_rating)
VALUES
    (1, 1, 5),
    (1, 2, 4),
    (3, 1, 5),
    (3, 3, 4),
    (4, 2, 5),
    (5, 3, 4),
    (6, 1, 5),
    (7, 2, 4),
    (8, 3, 5),
    (9, 1, 4),
    (10, 2, 5);

