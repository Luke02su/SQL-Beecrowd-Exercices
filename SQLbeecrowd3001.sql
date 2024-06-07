CREATE DATABASE beecrowd3901;
USE beecrowd3901;

CREATE TABLE products (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    type CHAR(1) NOT NULL,
	price FLOAT NOT NULL
);

INSERT INTO products VALUES (default, 'Monitor', 'B', 0);
INSERT INTO products VALUES (default, 'Headset', 'A', 0);
INSERT INTO products VALUES (default, 'PC Case', 'A', 0);
INSERT INTO products VALUES (default, 'Computer Desk', 'C', 0);
INSERT INTO products VALUES (default, 'Gaming Chair', 'C', 0);
INSERT INTO products VALUES (default, 'Mouse', 'A', 0);

SELECT * FROM products;

-- Exemplo 1 (consulta -- ideal -- 0.002s)
SELECT name,
	CASE 
		WHEN type = 'A' THEN 20.0 -- THEN se refere ao valor que será retornado
        WHEN type = 'B' THEN 70.0 
        WHEN type = 'C' THEN 530.5 
	END AS price
FROM products
ORDER BY type, id DESC; -- ASC oculto

-- Exemplo 2 (consulta c/ junção implícita -- teste, desnecessário -- 0.004s)
SELECT p.name,
	CASE 
		WHEN p.type = 'A' THEN 20.0
        WHEN pp.type = 'B' THEN 70.0
        WHEN p.type = 'C' THEN 530.5
	END AS price
FROM products p, products pp
WHERE p.id = pp.id -- evitar duplicação
ORDER BY p.type, pp.id DESC;

-- Exemplo 3 (consulta c/ subconsulta -- teste, desnecessário -- 0.004s)
SELECT name,
	CASE 
		WHEN type = 'A' THEN 20.0
        WHEN type = 'B' THEN 70.0
        WHEN type = 'C' THEN 530.5
	END AS price
FROM (SELECT id, name, type
	FROM products) p
ORDER BY type, id DESC;

-- Exemplo 4 (consulta c/ junção implícita e subconsulta -- teste, gambiarra, desnecessário -- 0.005s)
SELECT (SELECT name FROM products WHERE id = p.id) AS name,
	CASE 
		WHEN (SELECT type = 'A'FROM products WHERE id = pp.id) THEN 20.0
        WHEN (SELECT type = 'B'FROM products WHERE id = p.id) THEN 70.0
        WHEN (SELECT type = 'C'FROM products WHERE id = pp.id) THEN 530.5
	END AS price
FROM products p, products pp
WHERE p.id = pp.id
ORDER BY pp.type, pp.id DESC;

-- Exemplo 5 (consulta c/ junção explícita -- teste, gambiarra, desnecessário -- 0.002s)
SELECT p.name,
	CASE 
		WHEN pp.type = 'A' THEN 20.0
        WHEN p.type = 'B' THEN 70.0 
        WHEN p.type = 'C' THEN 530.5 
	END AS price
FROM products p
INNER JOIN products pp ON p.id = pp.id
ORDER BY p.type, pp.id DESC;

-- Exemplo 6 (consulta c/ junção explícita -- teste, desnecessário -- 0.003s)
SELECT p.name,
	CASE 
		WHEN p.type = 'A' THEN 20.0
        WHEN p.type = 'B' THEN 70.0 
        WHEN p.type = 'C' THEN 530.5 
	END AS price
FROM products p
INNER JOIN (
	SELECT id
	FROM products 
) pp ON p.id = pp.id
ORDER BY p.type, pp.id DESC;

-- Testes
-- Treinando VIEW, rotinas, FUNTION, TRIGGER, EVENT

CREATE VIEW view_exemplo1
AS
SELECT name,
	CASE 
		WHEN type = 'A' THEN 20.0
        WHEN type = 'B' THEN 70.0 
        WHEN type = 'C' THEN 530.5 
	END AS price
FROM products
ORDER BY type, id DESC;

SELECT * FROM view_exemplo1;

DELIMITER %%
CREATE PROCEDURE proc_exemplo1 ()
BEGIN
	SELECT name,
		CASE 
			WHEN type = 'A' THEN 20.0 -- THEN se refere ao valor que será retornado
			WHEN type = 'B' THEN 70.0 
			WHEN type = 'C' THEN 530.5 
		END AS price
	FROM products
	ORDER BY type, id DESC;
END%%
DELIMITER ;

CALL proc_exemplo1;

DELIMITER &&
CREATE FUNCTION func_count_typeA ()
RETURNS SMALLINT
BEGIN
	DECLARE count_typeA SMALLINT;
    SELECT COUNT(type) INTO count_typeA  FROM products
    WHERE type = 'A';
    RETURN count_typeA;
END&&
DELIMITER ;

SELECT func_count_typeA();

CREATE TABLE log_old_update_products (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    type CHAR(1) NOT NULL,
	price FLOAT NOT NULL,
    user VARCHAR(20) NOT NULL,
    date TIMESTAMP NOT NULL
);

DELIMITER %%
CREATE TRIGGER trg_old_update_products AFTER UPDATE
ON products
FOR EACH ROW
BEGIN
	INSERT INTO log_old_update_products (
		id, 
		name,
		type,
		price,
        user,
        date
	) VALUES (
		OLD.id,
        OLD.name,
        OLD.type,
        OLD.price,
        USER(),
        NOW()
);
END%%
DELIMITER ;

SET GLOBAL event_scheduler = ON;

DELIMITER %%
CREATE EVENT event_old_update_products
ON SCHEDULE
AT NOW() + INTERVAL + 10 SECOND
DO
BEGIN
	UPDATE products SET type = 'B' WHERE type = 'A' AND id != 0; -- id != 0 ou desativar FK usando SET SQL_SAFE_UPDATES = 0;
END%%
DELIMITER ;

SHOW EVENTS;
SELECT * FROM products;
SELECT * FROM log_old_update_products;
