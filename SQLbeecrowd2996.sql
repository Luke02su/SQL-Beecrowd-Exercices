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

-- Exemplo 2 
SELECT year, u.name AS sender, uu.name AS receiver
FROM users u, users uu, packages
WHERE u.id != uu.id
AND u.id = id_user_sender AND uu.id = id_user_receiver
AND (color = 'blue' OR year = 2015)
AND u.address != 'Taiwan' AND uu.address != 'Taiwan';

-- Exemplo 3 (consulta c/ junção explícita -- ideal -- 0.005s)
SELECT year, u.name AS sender, uu.name AS receiver
FROM users u
INNER JOIN users uu ON u.id != uu.id -- necessário duplicar users para distinguir sender e receiver
INNER JOIN packages ON u.id = id_user_sender AND uu.id = id_user_receiver
WHERE (color = 'blue' OR year = 2015) -- optar por usar parênteses quando se trata de OR para evitar erros
AND NOT u.address = 'Taiwan' AND NOT uu.address = 'Taiwan' -- ou simplesmente usar !=
ORDER BY year DESC;