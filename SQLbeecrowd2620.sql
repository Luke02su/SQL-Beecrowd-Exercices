CREATE DATABASE beecrowd2620;
USE beecrowd2620;

CREATE TABLE customers (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    street VARCHAR(40) NOT NULL,
    city VARCHAR(20) NOT NULL,
    state CHAR(2) NOT NULL,
    credit_limit NUMERIC(4, 0) NOT NULL
);

CREATE TABLE orders (
	id INT AUTO_INCREMENT PRIMARY KEY,
    orders_date DATE NOT NULL,
    id_customers INT NOT NULL, 
    
    CONSTRAINT pk_id_customers FOREIGN KEY (id_customers) REFERENCES customers(id)
);

INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Nicolas Diogo Cardoso', 'Acesso Um', 'Porto Alegre', 'RS', 475);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Cecília Olivia Rodrigues', 'Rua Sizuka Usuy', 'Cianorte', 'PR', 3170);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Augusto Fernando Carlos Eduardo Cardoso', 'Rua Baldomiro Koerich', 'Palhoça', 'SC', 1067);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Nicolas Diogo Cardoso', 'Acesso Um', 'Porto Alegre', 'RS', 475);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Sabrina Heloisa Gabriela Barros', 'Rua Engenheiro Tito Marques Fernandes', 'Porto Alegre', 'RS', 4312);
INSERT INTO customers (name, street, city, state, credit_limit) VALUES ('Joaquim Diego Lorenzo Araújo', 'Rua Vitorino', 'Novo Hamburgo', 'RS', 2314);

SELECT * FROM customers;

INSERT INTO orders (orders_date, id_customers) VALUES ('2016-05-13', 3);
INSERT INTO orders (orders_date, id_customers) VALUES ('2016-01-12', 2);
INSERT INTO orders (orders_date, id_customers) VALUES ('2016-04-18', 5);
INSERT INTO orders (orders_date, id_customers) VALUES ('2016-09-07', 4);
INSERT INTO orders (orders_date, id_customers) VALUES ('2016-02-13', 6);
INSERT INTO orders (orders_date, id_customers) VALUES ('2016-08-05', 3);

SELECT * FROM orders;



-- Exemplo 3
SELECT customers.name, orders.id
FROM customers
INNER JOIN orders ON customers.id = id_customers
WHERE orders.orders_date <= '2016-06-30'; -- ou BETWEEN '2016-01-01' AND '2016-06-30';

