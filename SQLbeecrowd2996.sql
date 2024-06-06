CREATE DATABASE beecrowd2996;
USE beecrowd2996;

CREATE TABLE users (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    address VARCHAR(25) NOT NULL
);

CREATE TABLE packages (
	id_package INT AUTO_INCREMENT PRIMARY KEY,
    id_user_sender INT NOT NULL,
    id_user_receiver INT NOT NULL,
    color VARCHAR(20) NOT NULL,
    year INT NOT NULL,
    
    INDEX idx_id_user_sender (id_user_sender),
    INDEX idx_id_user_receiver (id_user_receiver),
    
    CONSTRAINT fk_id_user_sender FOREIGN KEY (id_user_sender) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_id_user_receiver FOREIGN KEY (id_user_receiver) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO users VALUES (default, 'Edgar Codd', 'England');
INSERT INTO users VALUES (default, 'Peter Chen', 'Taiwan');
INSERT INTO users VALUES (default, 'Jim Gray', 'United States');
INSERT INTO users VALUES (default, 'Elizabeth O''Neil', 'United States');

SELECT * FROM users;

INSERT INTO packages VALUES (default, 1, 2, 'blue', 2015);
INSERT INTO packages VALUES (default, 1, 3, 'blue', 2019);
INSERT INTO packages VALUES (default, 2, 4, 'red', 2019);
INSERT INTO packages VALUES (default, 2, 1, 'green', 2018);
INSERT INTO packages VALUES (default, 3, 4, 'red', 2015);
INSERT INTO packages VALUES (default, 4, 3, 'blue', 2019);

SELECT * FROM packages;

-- Exemplo 1 (consulta c/ junção implícita -- não é ideal, pode gerar ambiguidade -- 0.004s) 
SELECT year, u.name AS sender, uu.name AS receiver
FROM users u, users uu, packages
WHERE u.id != uu.id
AND u.id = id_user_sender AND uu.id = id_user_receiver
AND (color = 'blue' OR year = 2015)
AND u.address != 'Taiwan' AND uu.address != 'Taiwan'
ORDER BY year DESC;

-- Exemplo 2.1 (consulta c/ subconsulta -- desnecessário -- 0.006s)
SELECT year, (SELECT u.name FROM users u WHERE u.id = id_user_sender) AS sender, (SELECT uu.name FROM users uu WHERE uu.id = id_user_receiver) AS receiver
FROM packages
WHERE (color = 'blue' OR year = 2015)
AND EXISTS (
	SELECT u.id
    FROM users u
    WHERE u.id = id_user_sender
    AND u.address != 'Taiwan')
AND EXISTS (
	SELECT uu.id
    FROM users uu
    WHERE uu.id = id_user_receiver
    AND uu.address != 'Taiwan')
ORDER BY year DESC;

-- Exemplo 2.2 (consulta c/ subconsulta -- desnecessário -- 0.003s)
SELECT year, (SELECT u.name FROM users u WHERE u.id = id_user_sender) AS sender, (SELECT uu.name FROM users uu WHERE uu.id = id_user_receiver) AS receiver
FROM packages
WHERE (color = 'blue' OR year = 2015)
AND id_user_sender IN (
	SELECT u.id
    FROM users u
    WHERE u.address != 'Taiwan')
AND id_user_receiver IN(
	SELECT uu.id
    FROM users uu
    WHERE uu.address != 'Taiwan')
ORDER BY year DESC;

-- Exemplo 3 (consulta c/ junção implícita e subconsulta -- gambiarra, desnecessário -- 0.004s)
SELECT year, u.name AS sender, (SELECT uu.name FROM users uu WHERE uu.id = id_user_receiver) AS receiver
FROM packages, users u
WHERE (color = 'blue' OR year = 2015)
AND id_user_sender = u.id
AND u.address != 'Taiwan'
AND id_user_receiver IN(
	SELECT uu.id
    FROM users uu
    WHERE uu.address != 'Taiwan')
ORDER BY year DESC;

-- Exemplo 4.1 (consulta c/ junção explícita -- ideal, mas o debaixo é mais simplificado -- 0.004s)
SELECT year, u.name AS sender, uu.name AS receiver
FROM users u
INNER JOIN users uu ON u.id != uu.id -- necessário duplicar users para distinguir sender e receiver
INNER JOIN packages ON u.id = id_user_sender AND uu.id = id_user_receiver
WHERE (color = 'blue' OR year = 2015) -- optar por usar parênteses quando se trata de OR para evitar erros
AND NOT u.address = 'Taiwan' AND NOT uu.address = 'Taiwan' -- ou simplesmente usar !=
ORDER BY year DESC;

-- Exemplo 4.2 (consulta c/ junção explícita -- ideal -- 0.003s) -- algumas modificações na ordem com o de cima quanto as tables e joins
SELECT year, u.name AS sender, uu.name AS receiver
FROM packages
INNER JOIN users u ON id_user_sender = u.id
INNER JOIN users uu ON id_user_receiver = uu.id
WHERE (color = 'blue' OR year = 2015) 
AND NOT u.address = 'Taiwan' AND NOT uu.address = 'Taiwan'
ORDER BY year DESC;

-- Exemplo 5 (consulta c/ junção explícita e subconsulta -- desnecessário -- 0.004s)
SELECT year, u.name AS sender, uu.name AS receiver
FROM packages
INNER JOIN (
	SELECT u.id, u.name
    FROM users u
    WHERE NOT u.address = 'Taiwan'
) u ON id_user_sender = u.id
INNER JOIN (
	SELECT uu.id, uu.name
    FROM users uu
    WHERE NOT uu.address = 'Taiwan'
) uu ON id_user_receiver = uu.id
WHERE (color = 'blue' OR year = 2015)
ORDER BY year DESC;

-- Testes
-- Treinando VIEW, ROTINAS, TRIGGER E EVENT:

CREATE VIEW view_exemplo42
AS 
SELECT year, u.name AS sender, uu.name AS receiver
FROM packages
INNER JOIN users u ON id_user_sender = u.id
INNER JOIN users uu ON id_user_receiver = uu.id
WHERE (color = 'blue' OR year = 2015) 
AND NOT u.address = 'Taiwan' AND NOT uu.address = 'Taiwan'
ORDER BY year DESC;

SELECT * FROM view_exemplo42;

DELIMITER %%
CREATE PROCEDURE proc_exemplo42 ()
BEGIN
	SELECT year, u.name AS sender, uu.name AS receiver
	FROM packages
	INNER JOIN users u ON id_user_sender = u.id
	INNER JOIN users uu ON id_user_receiver = uu.id
	WHERE (color = 'blue' OR year = 2015) 
	AND NOT u.address = 'Taiwan' AND NOT uu.address = 'Taiwan'
ORDER BY year DESC;
END%%
DELIMITER ;

CALL proc_exemplo42;

DELIMITER %%
CREATE FUNCTION func_packages_count_blue ()
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE qtd_blue INT;
	SELECT COUNT(color) INTO qtd_blue
    FROM packages
    WHERE color = 'blue';
    RETURN qtd_blue;
END %%
DELIMITER ;

SELECT func_packages_count_blue();

CREATE TABLE log_add_users (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    address VARCHAR(25) NOT NULL,
    user VARCHAR(20) NOT NULL,
    date TIMESTAMP NOT NULL
);

DELIMITER &&
CREATE TRIGGER trg_insert_users AFTER INSERT
ON users
FOR EACH ROW
BEGIN
	INSERT INTO log_add_users (
		id,
		name,
		address,
		user,
		date
) VALUES (
		NEW.id,
		NEW.name,
		NEW.address,
		USER(),
		CURRENT_TIMESTAMP()
);
END&&
DELIMITER ;

DELIMITER $$
CREATE EVENT event_insert_users
 ON SCHEDULE EVERY 2 MINUTE
 STARTS NOW()
 ENDS NOW() + INTERVAL 1 HOUR
 DO
BEGIN
    INSERT INTO users VALUES ('Nome teste', 'Endereço teste');
END$$
DELIMITER ;

SHOW EVENTS;
SELECT * FROM users;
SELECT * FROM log_add_users;
