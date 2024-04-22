CREATE DATABASE beecrowd2625;
USE beecrowd2625;

CREATE TABLE customers (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
    street VARCHAR(45) NOT NULL,
    city VARCHAR(25) NOT NULL,
    state CHAR(2) NOT NULL,
    credit_limit INT NOT NULL
);

CREATE TABLE natural_person (
	id_customers INT NOT NULL,
	cpf CHAR(14) NOT NULL,
    
    PRIMARY KEY (id_customers, cpf),
    CONSTRAINT pk_id_customers FOREIGN KEY (id_customers)
    REFERENCES customers(id)
);

INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Nicolas Diogo Cardoso', 'Acesso Um', 'Porto Alegre', 'RS', 475);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Cecília Olivia Rodrigues', 'Rua Sizuka Usuy', 'Cianorte', 'PR', 3170);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Augusto Fernando Carlos', 'Eduardo Cardoso', 'Rua Baldomiro Koerich', 'Palhoça	SC', 1067);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Nicolas Diogo Cardoso', 'Acesso Um', 'Porto Alegre', 'RS', 475);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Sabrina Heloisa Gabriela Barros', 'Rua Engenheiro Tito Marques Fernandes', 'Porto Alegre', 'RS', 4312);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Joaquim Diego Lorenzo Araújo', 'Rua Vitorino', 'Novo Hamburgo', 'RS', 2314 );

SELECT * FROM customers;

INSERT INTO natural_person (id_customers, cpf) VALUES (1, '26774287840');
INSERT INTO natural_person (id_customers, cpf) VALUES (2, '97918477200');

SELECT * FROM natural_person;

-- Exemplo 1 (junção impli=ícita pode gerar erros -- 4s)
SELECT CONCAT (
	SUBSTRING(cpf, 1, 3), '.',
    SUBSTRING(cpf, 4, 3), '.',
    SUBSTRING(cpf, 7, 3), '-',
	SUBSTRING(cpf, 10, 2)
) AS cpf
FROM customers AS c, natural_person AS n
WHERE c.id = n.id_customers;

-- Exemplo 2 (mais ideal neste caso -- 0.161s)
SELECT CONCAT (
	SUBSTRING(cpf, 1, 3), '.',
    SUBSTRING(cpf, 4, 3), '.',
    SUBSTRING(cpf, 7, 3), '-',
    SUBSTRING(cpf, 10, 2)
) AS cpf
FROM customers AS c, natural_person AS n
WHERE c.id IN (
	SELECT n.id_customers
	FROM natural_person
);

-- Exemplo 3 (Junção explícita -- subconsulta se sobressai com melhor desempenho -- 4s)
SELECT CONCAT (
	SUBSTRING(cpf, 1, 3), '.',  -- funcão para extrair parte de uma string (atributo, x [posição], y [quantidade de caracteres])
    SUBSTRING(cpf, 4, 3), '.',
    SUBSTRING(cpf, 7, 3), '-',
    SUBSTRING(cpf, 10, 2)
) AS cpf
FROM natural_person AS n
LEFT JOIN customers AS c ON c.id = n.id_customers;

-- Exemplo 4 (junção explícita com subconsulta. Subquery se torna desnecessária pois JOIN já garante o retorno -- 5s)
SELECT CONCAT (
	SUBSTRING(cpf, 1, 3), '.',
	SUBSTRING(cpf, 4, 3), '.',
    SUBSTRING(cpf, 7, 3), '-',
    SUBSTRING(cpf, 10, 2)
) AS cpf
FROM customers AS c 
RIGHT JOIN natural_person AS n ON c.id = n.id_customers
WHERE n.id_customers IN (
	SELECT c.id 
    FROM customers AS c
);