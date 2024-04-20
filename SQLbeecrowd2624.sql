CREATE DATABASE beecrowd2624;
USE beecrowd2624;

CREATE TABLE customers (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45),
    street VARCHAR(45),
    city VARCHAR(20),
	state VARCHAR(2),
    credit_limit NUMERIC(4, 0)
);

INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Nicolas Diogo Cardoso', 'Acesso Um', 'Porto Alegre', 'RS', 475);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Cecília Olivia Rodrigues', 'Rua Sizuka Usuy', 'Cianorte', 'PR', 3170);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Augusto Fernando Carlos Eduardo Cardoso', 'Rua Baldomiro Koerich', 'Palhoça', 'SC', 1067);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Nicolas Diogo Cardoso', 'Acesso Um', 'Porto Alegre', 'RS', 475);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Sabrina Heloisa Gabriela Barros', 'Rua Engenheiro Tito Marques Fernandes', 'Porto Alegre', 'RS', 4312);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Joaquim Diego Lorenzo Araújo', 'Rua Vitorino', 'Novo Hamburgo', 'RS', 2314);

SELECT * FROM customers;

-- Exemplo 1 (ideal, mais claro e eficiente -- 3s)
SELECT COUNT(DISTINCT c.city) AS count
FROM customers AS c;

-- Exemplo 1.1 (6s)
SELECT COUNT(DISTINCT city) AS count
FROM customers;

-- Exemplo 2 (subconsulta desnecessária -- 7s -- menor desempenho)
SELECT COUNT(DISTINCT city) AS count
FROM (
	SELECT c.city
    FROM customers AS c
) AS subquery; -- necessário usar AS neste caso

-- Exemplo 3 (subconsulta com junção explícita -- desnecessário -- 5s)
SELECT COUNT(DISTINCT c.city) AS count
FROM customers AS c
INNER JOIN ( -- neste caso replica-se a tabela para usar INNER JOIN
	SELECT city
    FROM customers
) AS subquery ON c.city = subquery.city;