CREATE DATABASE beecrowd2738;
USE beecrowd2738;

CREATE TABLE candidate (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(45) NOT NULL
);

CREATE TABLE score (
	candidate_id INT NOT NULL AUTO_INCREMENT,
	math NUMERIC(2, 0),
    `specific` NUMERIC(2, 0), -- usar acento para usar a palavra reservada do MySQL (specific) como atributo
    project_plan NUMERIC(2, 0),
    
    CONSTRAINT pk_candidate_id FOREIGN KEY (candidate_id)
		REFERENCES candidate(id)
);

INSERT INTO candidate (name) VALUES ('Michael P Cannon');
INSERT INTO candidate (name) VALUES ('Barbra J Cable');
INSERT INTO candidate (name) VALUES ('Ronald D Jones');
INSERT INTO candidate (name) VALUES ('Timothy K Fitzsimmons');
INSERT INTO candidate (name) VALUES ('Ivory B Morrison');
INSERT INTO candidate (name) VALUES ('Sheila R Denis');
INSERT INTO candidate (name) VALUES ('Edward C Durgan');
INSERT INTO candidate (name) VALUES ('William K Spencer');
INSERT INTO candidate (name) VALUES ('Donna D Pursley');
INSERT INTO candidate (name) VALUES ('Ann C Davis');

SELECT * FROM candidate;

INSERT INTO score (math, `specific`, project_plan) VALUES (76, 58, 21);
INSERT INTO score (math, `specific`, project_plan) VALUES (4, 5, 22);
INSERT INTO score (math, `specific`, project_plan) VALUES (15, 59, 12);
INSERT INTO score (math, `specific`, project_plan) VALUES (41, 42, 99);
INSERT INTO score (math, `specific`, project_plan) VALUES (22, 90, 9);
INSERT INTO score (math, `specific`, project_plan) VALUES (82, 77, 15);
INSERT INTO score (math, `specific`, project_plan) VALUES (82, 99, 56);
INSERT INTO score (math, `specific`, project_plan) VALUES (11, 4, 22);
INSERT INTO score (math, `specific`, project_plan) VALUES (16, 29, 94);
INSERT INTO score (math, `specific`, project_plan) VALUES (1, 7, 59);

SELECT * FROM score;

-- Exemplo 1 (junção implícita - 3s)
SELECT c.name, ROUND(((s.math*2)+(s.specific*3)+(s.project_plan*5))/10, 2) AS "avg"
FROM candidate AS c, score As s
WHERE c.id = s.candidate_id
ORDER BY "avg" DESC;

-- Exemplo 2 (subconsulta -- 0.449s)
SELECT c.name, ROUND(((s.math*2)+(s.specific*3)+(s.project_plan*5))/10, 2) AS avg
FROM candidate AS c, score As s
WHERE s.candidate_id IN (
	SELECT c.id
    FROM candidate
)
ORDER BY avg DESC;

-- Exemplo 3 (junção explícita -- ideal -- 3s)
SELECT c.name, ROUND(((s.math*2)+(s.specific*3)+(s.project_plan*5))/10, 2) AS avg -- média ponderada
FROM candidate AS c
INNER JOIN score AS s ON c.id = s.candidate_id
-- GROUP BY c.name -- ocasionou erro no beecrowd (GROUP BY é de suma importância neste caso (cada avg para cada pessoa) -- agrupa a linhas de name)
ORDER BY avg DESC; -- ORDER BY `avg` DESC define que será descrescente

-- Exemplo 4 (junção explícita com subconsulta -- descenessário -- redundante -- ocasiona ambiguidade -- 3s)
SELECT c.name, ROUND(((s.math*2)+(s.specific*3)+(s.project_plan*5))/10, 2) AS avg
FROM candidate AS c
INNER JOIN (
	SELECT s.candidate_id, math, s.specific, s.project_plan
    FROM score AS s
) AS s ON c.id = s.candidate_id
ORDER BY avg DESC;

-- Por falta de atenção coloquei o AVG na média pondera e não percebi que estava ocasionando erro! Submeti várias vezes achando que fosse questão de aspas.