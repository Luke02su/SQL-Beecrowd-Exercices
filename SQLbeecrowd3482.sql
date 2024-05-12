CREATE DATABASE beecrowd3482;
USE beecrowd3482;

CREATE TABLE users (
	user_id	INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(25) NOT NULL,
    posts SMALLINT NOT NULL
);

CREATE TABLE followers (
	follower_id	INT AUTO_INCREMENT PRIMARY KEY,
    user_id_fk INT NOT NULL,
    following_user_id_fk INT NOT NULL,
    
    INDEX user_id_idx (user_id_fk),
    INDEX following_user_id_fk_idx (following_user_id_fk),
    
    CONSTRAINT user_id_fk FOREIGN KEY (user_id_fk) REFERENCES users(user_id), -- pode-se ocultar a tabela followers para se referir a sua chave estrangeira
    CONSTRAINT following_user_id_fk FOREIGN KEY followers(following_user_id_fk) REFERENCES users(user_id) 
);

INSERT INTO users VALUES (default, 'Francisco', 23);
INSERT INTO users VALUES (default, 'Brenda', 51);
INSERT INTO users VALUES (default, 'Helena', 12);
INSERT INTO users VALUES (default, 'Miguel', 70);
INSERT INTO users VALUES (default, 'Laura', 55);
INSERT INTO users VALUES (default, 'Arthur', 2);
INSERT INTO users VALUES (default, 'Alice', 3);

SELECT * FROM users;

INSERT INTO followers VALUES (default, 1, 5);
INSERT INTO followers VALUES (default, 2, 4);
INSERT INTO followers VALUES (default, 3, 7);
INSERT INTO followers VALUES (default, 3, 6);
INSERT INTO followers VALUES (default, 4, 2);
INSERT INTO followers VALUES (default, 4, 5);
INSERT INTO followers VALUES (default, 5, 1);
INSERT INTO followers VALUES (default, 5, 3);
INSERT INTO followers VALUES (default, 5, 4);
INSERT INTO followers VALUES (default, 5, 2);
INSERT INTO followers VALUES (default, 7, 3);

CREATE VIEW selectFollowers AS
SELECT * FROM followers;
SELECT * FROM selectFollowers;

-- Exemplo 1
SELECT u.user_name AS u1_name, u.user_name AS u2_name
FROM users u
INNER JOIN followers f ON f.user_id_fk = u.user_id
INNER JOIN followers ff ON u.user_id = ff.following_user_id_fk
WHERE follower_id IN  (f.user_id_fk + ff.following_user_id_fk);

drop database beecrowd3482;