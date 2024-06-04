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

-- Exemplo 1 (consulta -- ideal -- 0.003s)
SELECT temperature, COUNT(mark) AS number_of_records
FROM records
GROUP BY mark, temperature -- tive de adicionar temperature no group by
ORDER BY mark; -- e ordenar por mark par adra aceppted (sem isso ocorria runtime error)

-- Exemplo 2 (consulta c/ junção implícita -- desnecessário -- 0.003s)
SELECT r1.temperature, COUNT(r1.mark) AS number_of_records
FROM records r1, records r2 -- duplicando table
WHERE r1.id = r2.id
GROUP BY r1.temperature, r1.mark
ORDER BY r1.mark;

-- Exemplo 3.1 (consulta c/ consulta -- desnecessário -- 0.003s)
SELECT temperature, COUNT(mark) AS number_of_records
FROM (SELECT temperature, mark -- ou *
	FROM records) AS subquery
GROUP BY temperature, mark
ORDER BY mark;

-- Exemplo 3.2 (consulta c/ consulta -- desnecessário -- 0.003s)
SELECT temperature, COUNT(*) AS number_of_records
FROM (SELECT temperature, mark -- ou *
	FROM records
    WHERE mark IN (SELECT DISTINCT mark FROM records)) AS subquery -- subconsulta dentro de subconsulta
GROUP BY temperature, mark
ORDER BY mark;

-- Exemplo 4 (consulta c/ junção implícita e subconsulta -- desnecessário -- 0.006s)
SELECT r1.temperature, COUNT(r1.mark) AS number_of_records
FROM (SELECT id, temperature, mark FROM records) AS r1, records r2 -- poderia usar * para ocultar o id, temperature, e mark no select
WHERE r1.id = r2.id
GROUP BY r1.temperature, r1.mark
ORDER BY r1.mark;

-- Exemplo 5 (consulta c/ junção explícita -- desneceessário -- 0.005s)
SELECT r1.temperature, COUNT(r1.mark) AS number_of_records
FROM records r1
INNER JOIN records r2 ON r1.id = r2.id
GROUP BY r1.temperature, r1.mark
ORDER BY r1.mark;

-- Exemplo 6 (consulta c/ junção explícita e subconsulta -- desneceessário -- 0.005s)
SELECT r1.temperature, COUNT(r1.mark) AS number_of_records
FROM records r1
INNER JOIN (
	SELECT id, temperature, mark -- ou *
    FROM records
) r2 ON r1.id = r2.id
GROUP BY r1.temperature, r1.mark
ORDER BY r1.mark;

-- Testes enfadonhos...
-- Treinando VIEW, PROCEDURE, FUNCTION, TRIGGER E EVENT

CREATE VIEW view_exemplo1
AS
SELECT temperature, COUNT(mark) AS number_of_records
FROM records
GROUP BY mark, temperature
ORDER BY mark;

SELECT * FROM view_exemplo1;

DELIMITER %%
CREATE PROCEDURE procedure_exemplo1()
BEGIN
	SELECT temperature, COUNT(mark) AS number_of_records
	FROM records
	GROUP BY mark, temperature
	ORDER BY mark;
END%%
DELIMITER ;

CALL procedure_exemplo1;

DELIMITER %%
CREATE FUNCTION function_maior_temperature ()
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE maior_temperature INT;
    SELECT MAX(temperature) INTO maior_temperature
    FROM records;
    RETURN maior_temperature;
END%%
DELIMITER ;

SELECT function_maior_temperature();

CREATE TABLE log_delete_id (
	id SMALLINT,
    temperature SMALLINT,
    mark SMALLINT,
    user VARCHAR(25),
    date TIMESTAMP
);

DELIMITER &&
CREATE TRIGGER trigger_delete_records AFTER DELETE
ON records
FOR EACH ROW
BEGIN
	INSERT INTO log_delete_id (
		id,
		temperature,
		mark,
		user,
		date
	) VALUES (
		OLD.id,
		OLD.temperature,
		OLD.mark,
		USER(),
		NOW()
);
END&&
DELIMITER ;

DELIMITER ##
CREATE EVENT event_delete_id
ON SCHEDULE
AT CURRENT_TIMESTAMP + INTERVAL + 1 MINUTE
DO
BEGIN
	DELETE FROM records WHERE id >= 13;
END##
DELIMITER ;

SHOW EVENTS;
SELECT * FROM records;
SELECT * FROM log_delete_id;
