CREATE DATABASE beecrowd2739;
USE beecrowd2739;

CREATE TABLE loan (
	id INT AUTO_INCREMENT,
	name VARCHAR(30) NOT NULL,
    value NUMERIC(8, 2) NOT NULL,
    payday DATE NOT NULL,
    
    PRIMARY KEY (id),
    INDEX idx_id (id) -- não tem necessidade de criar um INDEX para a chave primária pois já cria automaticamente (é ideal criar para as chaves estrangeiras por questões de performance)
);

ALTER TABLE loan MODIFY COLUMN payday TIMESTAMP NOT NULL; -- alterei pois o exercício pede TIMESTAMP, não DATE

INSERT INTO loan (name, value, payday) VALUES ('Cristian Ghyprievy', 3000.50,'2017-10-19');
INSERT INTO loan (name, value, payday) VALUES ('John Serial', 10000, '2017-10-10');
INSERT INTO loan (name, value, payday) VALUES ('Michael Seven', 5000.40, '2017-10-17');
INSERT INTO loan (name, value, payday) VALUES ('Joana Cabel', 2000, '2017-10-05');
INSERT INTO loan (name, value, payday) VALUES ('Miguel Santos', 4050, '2017-10-20');

SELECT * FROM loan;

-- Exemplo 1 (RUN TIME ERROR -- não funciona pois neste caso pode contabilizar o número 0 antes, exemplo: dia 05)
/*SELECT l.name, 
	CONCAT ( 
		SUBSTRING(l.payday, 9, 2)
    ) AS day
FROM loan AS l;

-- Exemplo 1.1 (RUNTIME ERROR)
SELECT l.name, DAY(l.payday) AS day 
FROM loan AS l;

-- Exemplo 1.2 (10% de erro, tem que converter de novo usando CAST -- não tem sentido pois a funcção já faz isso, mas foi o que deu certo)
SELECT l.name, EXTRACT(DAY FROM l.payday) AS day -- no MYSQL é diferentes 
FROM loan AS l;

-- Exemplo 1.3 (RUNTIME ERROR)
SELECT l.name, DAYOFMONTH(l.payday) AS day
FROM loan AS l;

-- Exemplo 1.4 (RUNTIME ERROR)
SELECT l.name, CONVERT(EXTRACT(DAY FROM l.payday), INT) AS day -- funciona no MySQL (embora apereça com erro), mas no PostgresSQL não
FROM loan AS l;*/

-- Exemplo 1.5
SELECT l.name, CAST(EXTRACT(DAY FROM l.payday) AS INTEGER) AS day -- funciona no MySQL (embora apereça com erro) e no PostgresSQL -- 3s -- extraindo a parte do dia e reconvertendo para INT, pois a extração já faz isso
FROM loan AS l;

-- Exemplo 2 (completamente desnecessário -- 6s)
SELECT l.name, CAST(EXTRACT(DAY FROM l.payday) AS INT) AS day
FROM loan AS l
WHERE l.id IN (
	SELECT ll.id
    FROM loan AS ll
);

-- Exemplo 3 (completamente desnecessário -- 6s)
SELECT l.name, CAST(EXTRACT(DAY FROM l.payday) AS INT) AS day
FROM loan AS l
LEFT JOIN loan AS ll ON l.id = ll.id;

-- Exemplo 4 (completamente desnecessário -- 3s)
SELECT l.name, CAST(EXTRACT(DAY FROM l.payday) AS INT) AS day
FROM loan AS l
LEFT JOIN (
	SELECT id
    FROM loan
) AS ll ON l.id = ll.id;

-- Subconsultas aqui e JOIN são completamente desnecessárias.
-- Como usei MySQL, e o Beecrowd aceita apenas PostgresSQL, algumas sintaxes podem variar, por isso fiz vário exemplos.
-- Além disso, o próprio exercício ficou meio dúbio, pois certas funções já transforam o dia subtraído da data para inteiro automaticamente.