CREATE DATABASE beecrowd2744;
USE beecrowd2744;

CREATE TABLE account (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
    login VARCHAR(45) NOT NULL,
    password VARCHAR(45) NOT NULL
);

INSERT INTO account (name, login, password) VALUES ('Joyce P. Parry', 'Promeraw', 'noh1Oozei');
INSERT INTO account (name, login, password) VALUES ('Michael T. Gonzalez', 'Phers1942', 'Iath3see9bi');
INSERT INTO account (name, login, password) VALUES ('Heather W. Lawless', 'Hankicht', 'diShono4');
INSERT INTO account (name, login, password) VALUES ('Otis C. Hitt', 'Conalothe', 'zooFohH7w');
INSERT INTO account (name, login, password) VALUES ('Roger N. Brownfield', 'Worseente', 'fah7ohNg');

SELECT * FROM account;

-- Exemplo 1 (consulta -- ideal, clara e simples -- 3s c/ renomeação da tabela, 2s s/ renomeação da tabela)
SELECT a.id, a.password, MD5(a.password) AS MD5
FROM account a; -- funciona sem o AS aqui

-- Exemplo 2 (consulta c/ subconsulta -- redundante e descenessária -- 2s)
SELECT aa.id, aa.password, MD5(aa.password) AS MD5
FROM (
	SELECT a.id, a.password, MD5(a.password)
    FROM account AS a
) AS aa;

-- Exemplo 3 (consulta c/ JOIN -- desnecessário e redundante -- 2s [2s LEFT e 3s RIGHT])
SELECT a.id, a.password, MD5(a.password) AS MD5
FROM account AS a
INNER JOIN account AS aa ON a.id = aa.id;

-- Exemplo 4 (consulta c/ JOIN e subconsulta -- desnecessário e redundante -- 2s [3s c/ LEFT e RIGHT])
SELECT a.id, a.password, MD5(a.password) AS MD5
FROM account AS a
INNER JOIN (
	SELECT id -- 17 segundos renomeando aqui com a.id
    FROM account -- 17 segundos renomeando aqui com AS a
) AS aa ON a.id = aa.id;

-- Os demais exemplos, com exceção do 1, são apenas testes -- os quais são extremamente redundantes -- de performance.