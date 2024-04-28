CREATE DATABASE beecrowd2743;
USE beecrowd2743;

CREATE TABLE people (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL
    
    -- INDEX id_idx (id) -- algumas vezes criei manualmente o INDEX da PRIMARY KEY, mas percebi que o MySQL já faz isso, ou seja, duplica sem necessidade
);

INSERT INTO people (name) VALUES ('Karen');
INSERT INTO people (name) VALUES ('Manuel');
INSERT INTO people (name) VALUES ('Ygor');
INSERT INTO people (name) VALUES ('Valentine');
INSERT INTO people (name) VALUES ('Jo');

SELECT * FROM people;

-- Exemplo 1 (consulta ideal, simples --  2s com aspas e 4s sem aspas)
SELECT p.name, CHAR_LENGTH(p.name) AS "length"
FROM people AS p
ORDER BY length DESC;

-- Exemplo 2 (subconsulta -- totalmente desnecessário -- 2s)
SELECT subquery.name, CHAR_LENGTH(subquery.name) AS "length"
FROM (
	SELECT p.name
    FROM people AS p
) AS subquery
ORDER BY length DESC;

-- Exemplo 3 (junção explícita -- totalmente desnecessário -- 2s)
SELECT p.name, CHAR_LENGTH(p.name) AS "length"
FROM people AS p
LEFT JOIN people AS pp ON p.id = pp.id
ORDER BY length DESC;

-- Exemplo 4 (junção explícita com subconsulta -- totalmente desnecessário -- 4s)
SELECT p.name, CHAR_LENGTH(p.name) AS "length"
FROM people AS p
LEFT JOIN (
	SELECT p.id
    FROM people AS p
) people ON p.id = people.id
ORDER BY length DESC;

-- Todos os exemplos são para testes, é óbvio que o exemplo 1 é o ideal, não há dúvidas sobre isso.