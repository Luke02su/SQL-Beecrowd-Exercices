CREATE DATABASE beecrowd2740;
USE beecrowd2740;

CREATE TABLE league (
	position INT AUTO_INCREMENT PRIMARY KEY,
    team VARCHAR(45),
    
    INDEX position_idx (position)
);

INSERT INTO league (team) VALUES ('The Quack Bats');
INSERT INTO league (team) VALUES ('The Responsible Hornets');
INSERT INTO league (team) VALUES ('The Bawdy Dolphins');
INSERT INTO league (team) VALUES ('The Abstracted Sharks');
INSERT INTO league (team) VALUES ('The Nervous Zebras');
INSERT INTO league (team) VALUES ('The Oafish Owls');
INSERT INTO league (team) VALUES ('The Unequaled Bison');
INSERT INTO league (team) VALUES ('The Keen Kangaroos');
INSERT INTO league (team) VALUES ('The Left Nightingales');
INSERT INTO league (team) VALUES ('The Terrific Elks');
INSERT INTO league (team) VALUES ('The Lumpy Frogs');
INSERT INTO league (team) VALUES ('The Swift Buffalo');
INSERT INTO league (team) VALUES ('The Big Chargers');
INSERT INTO league (team) VALUES ('The Rough Robins');
INSERT INTO league (team) VALUES ('The Silver Crocs');

SELECT * FROM league;

-- Exemplo 1 (ideal - 3s)
SELECT CONCAT('Podium: ', l.team) AS name -- concatena 'Podium: ' + coluna team (usar aspas simples sempre em strings, aspas duplas apenas em colunas -- USEI ASPAS DUPLAS E DEU RUNTIME ERROR NO BEECROWD< VREIO QUE NO POSTGRESQL NÂO SEJA PERMITIDO COMO È NO MYSQL)
FROM league AS l
WHERE l.position <= 3
UNION ALL -- une ambas consultas sem tirar valores duplicados
SELECT CONCAT('Demoted: ', l.team) AS name -- (embora seja redundante AS name, no Beecrowd aumentou 1s sem ele) -- concatena 'Demoted: ' + coluna team
FROM league AS l
WHERE l.position >= 14;

-- Exemplo 2 (subconsulta, é desnecessária, menos clara, redundante -- 3s, mas deu 7s usando nas subconsulta AS ll)
SELECT CONCAT('Podium: ', l.team) AS name
FROM league AS l
WHERE l.position IN (
	SELECT l.position
    FROM league AS l
    WHERE l.position <= 3
)
UNION ALL 
SELECT CONCAT('Demoted: ', l.team) AS name
FROM league AS l
WHERE l.position IN (
	SELECT l.position
    FROM league AS l
    WHERE l.position >= 14
);

-- Exemplo 3 (JOIN -- apenas para teste, desnecessário e completamente redundante -- 4s)
SELECT CONCAT('Podium: ', l.team) AS name
FROM league AS l
LEFT JOIN league AS ll ON l.position = ll.position
WHERE l.position <= 3
UNION ALL
SELECT CONCAT('Demoted: ', l.team) AS name
FROM league AS l
LEFT JOIN league AS ll ON l.position = ll.position
WHERE l.position >= 14;

-- Exemplo 4 (JOIN + subconsulta -- apenas para teste, desnecessário e completamente redundante -- 3s)
SELECT CONCAT('Podium: ', l.team) AS name
FROM league AS l
INNER JOIN (
	SELECT l.position
	FROM league AS l
    WHERE l.position <= 3
) AS ll ON l.position = ll.position
UNION ALL
SELECT CONCAT('Demoted: ', l.team) AS name
FROM league AS l
INNER JOIN (
	SELECT l.position
    FROM league AS l
    WHERE l.position >= 14
) AS ll ON l.position = ll.position;