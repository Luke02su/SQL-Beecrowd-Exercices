CREATE DATABASE beecrowd2746;
USE beecrowd2746;

CREATE TABLE virus (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(25)
);

INSERT INTO virus (name) VALUES ('H1RT');
INSERT INTO virus (name) VALUES ('H7H1');
INSERT INTO virus (name) VALUES ('HUN8');
INSERT INTO virus (name) VALUES ('XH1HX');
INSERT INTO virus (name) VALUES ('XXXX');

SELECT * FROM virus;

-- Exemplo 1 (consulta -- ideal -- 3s c/ AS, 2s s/ AS)
SELECT REPLACE(name, 'H1', 'X') AS name -- REPLACE substitui uma string por uma substring
FROM virus;

-- Exempo 2 (subconsulta - 3s -- teste, totalmente desnecessário e redundante -- 3s)
SELECT REPLACE(vv.name, 'H1', 'X') AS name
FROM (
	SELECT v.id, v.name
    FROM virus v
) AS vv;

-- Exemplo 2.1 (subconsulta -- teste, totalmente desnecessário e redundante -- 4s)
SELECT REPLACE(v.name, 'H1', 'X') AS name
FROM virus v
WHERE v.id IN (
	SELECT v.id
    FROM virus v
);

-- Exemplo 3 (junção imlícita -- teste, totalmente desnecessário e redundante -- 4s)
SELECT REPLACE(v.name, 'H1', 'X') AS name
FROM virus v, virus vv
WHERE v.id = vv.id;

-- Exemplo 3.1 (junção implícita c/ subconsulta -- teste, totalmente desnecessário e redundante -- 3s)
SELECT REPLACE(v.name, 'H1', 'X') AS name
FROM virus v
WHERE v.id IN (
	SELECT vv.id
    FROM virus vv
);

-- Exempo 4 (junção explícita -- teste, totalmente desnecessário e redundante -- 2s)
SELECT REPLACE(v.name, 'H1', 'X') AS name
FROM virus v
LEFT JOIN virus vv ON v.id = vv.id;

-- Exemplo 5 (junção explícita c/ subconsulta -- teste, totalmente desnecessário e redundante -- 5s)
SELECT REPlACE(v.name, 'H1', 'X') AS name
FROM virus v
LEFT JOIN (
	SELECT v.id
    FROM virus v
) vv ON v.id = vv.id

-- Testes, considerar apenas o exemplo 1 como ideal.