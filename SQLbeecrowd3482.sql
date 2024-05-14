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

BEGIN;
INSERT INTO users VALUES (default, 'Francisco', 23);
INSERT INTO users VALUES (default, 'Brenda', 51);
INSERT INTO users VALUES (default, 'Helena', 12);
INSERT INTO users VALUES (default, 'Miguel', 70);
INSERT INTO users VALUES (default, 'Laura', 55);
INSERT INTO users VALUES (default, 'Arthur', 2);
INSERT INTO users VALUES (default, 'Alice', 3);

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
-- ROLLBACK;
COMMIT;

SELECT * FROM users;
SELECT * FROM followers;

CREATE VIEW view_users AS SELECT * FROM users; -- view deve possuir um nome diferente da tabela a partir da qual ela é criada
CREATE VIEW View_followers AS SELECT * FROM followers; -- view deve possuir um nome diferente da tabela a partir da qual ela é criada

SELECT * FROM view_users;
SELECT * FROM view_followers;

-- Exemplo 1 (junção implícita -- não é o ideal por poder gerar ambiguidade -- 0,006s)
SELECT
	CASE WHEN u1.posts < u2.posts THEN u1.user_name ELSE u2.user_name END AS u1_name,
    CASE WHEN u1.posts < u2.posts THEN u2.user_name ELSE u1.user_name END AS u2_name
FROM users u1, users u2, followers f1, followers f2
WHERE u1.user_id < u2.user_id
AND u1.user_id = f1.user_id_fk AND u2.user_id = f1.following_user_id_fk
AND u2.user_id = f2.user_id_fk AND u1.user_id = f2.following_user_id_fk
ORDER BY 
	CASE WHEN u1.posts < u2.posts THEN u1.user_id ELSE u2.user_id END;

-- Exemplo 2 (junção explícita -- ideal -- 0.003s)
SELECT 
	CASE WHEN u1.posts < u2.posts THEN u1.user_name ELSE u2.user_name END AS u1_name, -- caso da primeira coluna com usuários c/ menos postagens
    CASE WHEN u1.posts < u2.posts THEN u2.user_name ELSE u1.user_name END as u2_name -- caso da segunda coluna com usuários c/ mais postagen
FROM users u1
INNER JOIN users u2 ON u1.user_id < u2.user_id -- duplicando tabela users e evitando duplicação de resultados (1,2 e 2,1)
INNER JOIN followers f1 ON u1.user_id = f1.user_id_fk AND u2.user_id = f1.following_user_id_fk -- u1 segue u2
INNER JOIN followers f2 ON u2.user_id = f2.user_id_fk AND u1.user_id = f2.following_user_id_fk -- u2 segue u1
ORDER BY 
	CASE WHEN u1.posts < u2.posts THEN u1.user_id ELSE u2.user_id END; -- ordenando id do usuário com menos postagens
    
-- Pode haver outras formas, inclusive com subconsultas, mas creio que são desnecessárias e muito confusas. Quanto mais complexo o código, melhor fazer de formas mais objetivas, claras e simplificadas, como no Exemplo 2.
