CREATE database beecrowd2611;
USE beecrowd2611;

CREATE TABLE genres (
	id int AUTO_INCREMENT PRIMARY KEY,
    description varchar(20) not null
);

CREATE TABLE movies (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) not null,
    id_genres INT NOT NULL,
    
    FOREIGN KEY fk_id_genres(id_genres) REFERENCES genres(id)
);

INSERT INTO genres (description) VALUES ('Animation');
INSERT INTO genres (description) VALUES ('Horror');
INSERT INTO genres (description) VALUES ('Action');
INSERT INTO genres (description) VALUES ('Drama');
INSERT INTO genres (description) VALUES ('Comedy');

SELECT * FROM genres;

INSERT INTO movies (name, id_genres) VALUES ('Batman', 3);
INSERT INTO movies (name, id_genres) VALUES ('The Battle of the Dark River', 3);
INSERT INTO movies (name, id_genres) VALUES ('White Duck', 1);
INSERT INTO movies (name, id_genres) VALUES ('Breaking Barriers', 4);
INSERT INTO movies (name, id_genres) VALUES ('The Two Hours', 2);

SELECT * FROM movies;

-- Exemplo 1 (junção implícita [menos ideal])
SELECT movies.id, name
FROM movies, genres
WHERE id_genres = genres.id
AND description LIKE 'Action'; -- (poderia ter sido o sinal de = no lugar de LIKE)

-- Exemplo 2 (subconsulta [mais ou menos ideal])
SELECT id, name
FROM movies
WHERE id_genres IN (
	SELECT id
    FROM genres
    WHERE description LIKE 'Action'
);

-- Exemplo 3 (junção explícita [mais ideal])
SELECT movies.id, name
FROM movies
INNER JOIN genres
ON id_genres = genres.id
WHERE description LIKE 'Action';