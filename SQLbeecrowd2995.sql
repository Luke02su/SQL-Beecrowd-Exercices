CREATE DATABASE beecrowd2995;
USE beecrowd2995;

CREATE TABLE records (
	id SMALLINT,
    temperature SMALLINT,
    mark SMALLINT
);

INSERT INTO records VALUES (1, 30, 1);
INSERT INTO records VALUES (2, 30, 1);
INSERT INTO records VALUES (3, 30, 1);
INSERT INTO records VALUES (4, 32,2);
INSERT INTO records VALUES (5, 32, 2);
INSERT INTO records VALUES (6, 32, 2);
INSERT INTO records VALUES (7, 32, 2);
INSERT INTO records VALUES (8, 30, 3);
INSERT INTO records VALUES (9, 30, 3);
INSERT INTO records VALUES (10, 30, 3);
INSERT INTO records VALUES (11, 31, 4);
INSERT INTO records VALUES (12, 31, 4);
INSERT INTO records VALUES (13, 33, 5);
INSERT INTO records VALUES (14, 33, 5);
INSERT INTO records VALUES (15, 33, 5);

SELECT * FROM records;

-- Exemplo 1 -- consulta -- ideal -- 0.003s
SELECT temperature, COUNT(mark) AS number_of_records
FROM records
GROUP BY mark, temperature -- tive de adicionar temperature no group by
ORDER BY mark; -- e ordenar por mark par adra aceppted (sem isso ocorria runtime error)

-- Exemplo 2 -- consulta c/ junção implícita -- desnecessário -- 0.003s
SELECT r1.temperature, COUNT(r1.mark) AS number_of_records
FROM records r1, records r2 -- duplicando table
WHERE r1.id = r2.id
GROUP BY r1.temperature, r1.mark
ORDER BY r1.mark;

-- Exemplo 3 0.003s
SELECT temperature, COUNT(mark) AS number_of_records
FROM (SELECT temperature, mark
	FROM records) AS subquery
GROUP BY temperature, mark
ORDER BY mark;

-- EXemplo 3.1
SELECT temperature, COUNT(*) AS number_of_records
FROM (
    SELECT temperature, mark
    FROM records
    WHERE mark IN (SELECT DISTINCT mark FROM records)
) AS subquery
GROUP BY temperature, mark
ORDER BY mark;

-- Exemplo 4 0.005s
SELECT r1.temperature, COUNT(r1.mark) AS number_of_records
FROM records r1
INNER JOIN records r2 ON r1.id = r2.id
GROUP BY r1.temperature, r1.mark
ORDER BY r1.mark;