-- Creating Movies table
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    year INTEGER,
    genre VARCHAR(50),
    director VARCHAR(100),
    rating DECIMAL(3,1)
);

-- Import data into Movies
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
	
-- Creating Ratings table
CREATE TABLE ratings (
    rating_id SERIAL PRIMARY KEY,
    movie_id INTEGER REFERENCES movies(movie_id),
    user_id INTEGER,
    user_rating INTEGER,
    CONSTRAINT fk_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);


-- Import data into Ratings
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
    (10, 2, 5)
;

-- Find all movies that were rated by users (use INNER JOIN)
select *
from movies as m
inner join ratings as r
on m.movie_id = r.movie_id
where r.user_rating notnull
;

-- Output a list of directors who directed movies with a rating above 9.0
select m.director, m.title, m.rating
from movies as m
where m.rating >= 9.0
;

-- Get the average rating for each movie genre
select m.genre, round((avg(m.rating + 
                           r.user_rating)) / 2, 1) as avr_rating
from movies as m
inner join ratings as r
on m.movie_id = r.movie_id
group by m.genre
order by avr_rating desc
;

-- Output all movies that were not rated by users (use LEFT JOIN)
select m.title
from movies as m
left join ratings as r
on m.movie_id = r.movie_id
where r.user_rating isnull
;

-- Count the number of movies for each director
select director, count(title) as title_count
from movies
group by director
;

-- Find movies with the same genre and director
select m1.title, m1.director, m1.genre
from movies as m1
join movies as m2
on m1.genre = m2.genre
and m1.director = m2.director
where m1.movie_id <> m2.movie_id
;

-- Output a list of users who rated movies and the number of ratings they gave
select user_id, count(user_rating) as num_of_marks
from ratings
where user_rating notnull
group by user_id
order by user_id asc
;

-- Get a list of movies and the number of ratings they received (use RIGHT JOIN)
select m.title, count(r.user_rating) as num_of_marks
from movies as m
right join ratings as r
on m.movie_id = r.movie_id
group by m.title
;

-- Output the top 3 genres with the highest average rating
select m.genre, round(avg(m.rating) + 
                      avg(r.user_rating) / 2, 1) as max_avg_rating
from movies as m
join ratings as r
on m.movie_id = r.movie_id
group by m.genre
order by max_avg_rating desc
limit 3
;

-- Find movies that were rated by more than 2 users with a rating of at least 8.5
select m.title, count(r.user_rating) as user_count
from movies as m
join ratings as r
on m.movie_id = r.movie_id
where m.rating >= 8.5
group by m.title
having count(distinct r.user_id) > 2
;