CREATE DATABASE beecrowd2622;
USE beecrowd2622;

CREATE TABLE customers (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
    street VARCHAR(45) NOT NULL,
    city VARCHAR(25),
    state CHAR(2),
	credit_limit NUMERIC (4, 0)
);

CREATE TABLE legal_person (
	id_customers INT NOT NULL,
    CNPJ INT NOT NULL UNIQUE, -- (desnecessário ser UNIQUE sendo que será parte da chave composta. Neste caso deve ser BIGINT, INT não consegue comportar)
	contact VARCHAR(15),
    
    CONSTRAINT pk_id_customers FOREIGN KEY (id_customers) 
    REFERENCES customers(id),
    PRIMARY KEY (id_customers, CNPJ)
);

ALTER TABLE legal_person MODIFY COLUMN CNPJ BIGINT NOT NULL; -- alterand INT para BIGINT e retirando o UNIQUE desnecessário

INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Nicolas Diogo Cardoso', 'Acesso Um', 'Porto Alegre', 'RS', 475);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Cecília Olivia Rodrigues', 'Rua Sizuka Usuy', 'Cianorte', 'PR', 3170);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Augusto Fernando Carlos Eduardo Cardoso', 'Rua Baldomiro Koerich', 'Palhoça', 'SC', 1067);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Nicolas Diogo Cardoso', 'Acesso Um', 'Porto Alegre', 'RS', 475);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Sabrina Heloisa Gabriela Barros', 'Rua Engenheiro Tito Marques Fernandes', 'Porto Alegre', 'RS', 4312);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Joaquim Diego Lorenzo Araújo', 'Rua Vitorino', 'Novo Hamburgo', 'RS', 2314);

SELECT * FROM customers;

INSERT INTO legal_person (id_customers, CNPJ, contact) VALUES (4, 85883842000191, '99767-0562');
INSERT INTO legal_person (id_customers, CNPJ, contact) VALUES (5, 47773848000117, '99100-8965');

SELECT * FROM legal_person;

-- Exemplo 1 (junção implícita -- não muito ideal, embora funcione)
SELECT c.name
FROM customers AS c, legal_person AS l
WHERE c.id = l.id_customers;

-- Exemplo 2 (subconsulta -- mais ideal que o exemplo 1)
SELECT c.name
FROM customers AS c
WHERE c.id IN (
	SELECT l.id_customers
    FROM legal_person AS l
);

-- Exemplo 3 (juncão explícita -- ideal)
SELECT c.name
FROM customers AS c
LEFT JOIN legal_person AS l ON c.id = l.id_customers -- AS é descenessário aqui, apenas para praticar
WHERE c.id = l.id_customers;
-- ORDER BY c.name ASC; -- por algum o SGBD retornou em ordem decrescente. (Dentro do Beecrowd não aceitou adicionar manualmente ASC 0% erro)

-- Exemplos 3.1
SELECT c.name
FROM customers AS c
INNER JOIN legal_person AS l ON c.id = l.id_customers; -- INNER JOIN aqui pode ser mais interessante, desfazendo a necessidade do WHERE espeficiando o LEFT JOIN

-- Exemplo 4 (junção explícita com subconsulta -- descenessário pois LEFT JOIN já garante a consulta)
SELECT c.name
FROM customers AS c
LEFT JOIN legal_person AS l On c.id = l.id_customers
WHERE c.id IN (
	SELECT l.id_customers
	FROM legal_person
);

-- Todas levaram 2 segundos, por ser muito simples
-- Notei que quando específicamos a tabela, seja renomeando com AS ou usando o próprio nome da tabela antes do atributo, o desempenho é melhor