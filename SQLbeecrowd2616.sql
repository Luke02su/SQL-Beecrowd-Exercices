CREATE DATABASE beecrowd2616;
USE beecrowd2616;

CREATE TABLE customers (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(35) NOT NULL UNIQUE,
    street VARCHAR(35) NOT NULL UNIQUE,
    city varchar(20) NOT NULL UNIQUE
);

CREATE TABLE locations (
	id INT AUTO_INCREMENT PRIMARY KEY,
	locations_date DATE NOT NULL,
    id_customers INT NOT NULL,

	FOREIGN KEY fk_id_customers(id_customers) REFERENCES customers(id)
);

INSERT INTO customers (name, street, city) VALUES ('Giovanna Goncalves Oliveira', 'Rua Mato Grosso', 'Canoas');
INSERT INTO customers (name, street, city) VALUES ('Kauã Azevedo Ribeiro Travessa', 'Ibiá', 'Uberlândia');
INSERT INTO customers (name, street, city) VALUES ('Rebeca Barbosa Santos', 'Rua Observatório Meteorológico', 'Salvador');
INSERT INTO customers (name, street, city) VALUES ('Sarah Carvalho Correia', 'Rua Antônio Carlos da Silva', 'Apucarana');
INSERT INTO customers (name, street, city) VALUES ('João Almeida Lima', 'Rua Rio Taiuva', 'Ponta Grossa');
INSERT INTO customers (name, street, city) VALUES ('Diogo Melo Dias', 'Rua Duzentos e Cinqüenta	Várzea', 'Grande');

SELECT * FROM customers;

INSERT INTO locations (locations_date, id_customers) VALUES ('2016-10-09', 3);
INSERT INTO locations (locations_date, id_customers) VALUES ('2016-09-02', 1);
INSERT INTO locations (locations_date, id_customers) VALUES ('2016-08-02', 4);
INSERT INTO locations (locations_date, id_customers) VALUES ('2016-09-02', 2);
INSERT INTO locations (locations_date, id_customers) VALUES ('2016-03-02', 6);
INSERT INTO locations (locations_date, id_customers) VALUES ('2016-04-04', 4);

SELECT * FROM locations;

-- Exemplo 1 (terceira melhor forma)
SELECT customers.id, name
FROM customers
WHERE NOT EXISTS (
	SELECT id_customers -- poderia usar 1 para verificar se estiste uma tabela ue satisfaça a condição
    FROM locations
    WHERE customers.id = id_customers
);

-- Exemplo 2 (segunda melhor forma)
SELECT customers.id, name
FROM customers
WHERE customers.id NOT IN ( 
	SELECT id_customers -- poderia usar 1 para verificar se estiste uma tabela ue satisfaça a condição
    FROM locations
);

/*-- Exemplo 3 (funciona, mas deu erro beecrowd)
SELECT customers.id, name
FROM customers
LEFT JOIN locations ON customers.id = id_customers 
WHERE customers.id NOT IN (
	SELECT id_customers -- poderia usar 1 para verificar se existe uma tabela que satisfaça a condição
	FROM locations
	WHERE customers.id = id_customers
);/*

/*-- Exemplo 4 (funciona, mas deu erro no beecrowd)
SELECT customers.id, name
FROM customers
LEFT JOIN locations ON customers.id = id_customers
WHERE NOT EXISTS (
	SELECT id_customers -- poderia usar 1 para verificar se existe uma tabela que satisfaça a condição
    FROM locations
    WHERE customers.id = id_customers
);*/

-- Exemplo 5 (melhor forma, simples, ideal)
SELECT customers.id, name
FROM customers
LEFT JOIN locations ON customers.id = id_customers -- tanto faz adicionar o OUTER na consulta
WHERE id_customers IS NULL;