CREATE DATABASE beecrowd2614;
USE beecrowd2614;

CREATE TABLE customers (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name varchar(50) NOT NULL UNIQUE,
    street VARCHAR(50) NOT NULL UNIQUE,
    city VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO customers (name, street, city) VALUES ('Giovanna Goncalves Oliveira', 'Rua Mato Grosso', 'Canoas');
INSERT INTO customers (name, street, city) VALUES ('Kauã Azevedo Ribeiro', 'Travessa Ibiá',	'Uberlândia');
INSERT INTO customers (name, street, city) VALUES ('Rebeca Barbosa Santos', 'Rua Observatório Meteorológico', 'Salvador');
INSERT INTO customers (name, street, city) VALUES ('Sarah Carvalho Correia', 'Rua Antônio Carlos da Silva', 'Apucarana');
INSERT INTO customers (name, street, city) VALUES ('João Almeida Lima', 'Rua Rio Taiuva', 'Ponta Grossa');
INSERT INTO customers (name, street, city) VALUES ('Diogo Melo Dias', 'Rua Duzentos e Cinqüenta', 'Várzea Grande');

SELECT * FROM customers;

CREATE TABLE rentals (
	id INT AUTO_INCREMENT PRIMARY KEY,
    rentals_date DATE NOT NULL,
    id_customers INT NOT NULL,
    
    FOREIGN KEY fk_id_customers(id_customers) REFERENCES customers(id)
);

INSERT INTO rentals (rentals_date, id_customers) VALUES ('2016-09-10', 3);
INSERT INTO rentals (rentals_date, id_customers) VALUES ('2016-02-09', 1);
INSERT INTO rentals (rentals_date, id_customers) VALUES ('2016-02-08', 4);
INSERT INTO rentals (rentals_date, id_customers) VALUES ('2016-02-09', 2);
INSERT INTO rentals (rentals_date, id_customers) VALUES ('2016-02-03', 6);
INSERT INTO rentals (rentals_date, id_customers) VALUES ('2016-04-04', 4);

SELECT * FROM rentals;

-- Exemplo 1 (não tão ideal)
SELECT name, rentals_date
FROM customers, rentals
WHERE customers.id = id_customers
AND rentals_date BETWEEN '2016-09-01' AND '2016-09-30';

/*-- Exemplo 2 (gambiarra -- beecrowd não aceita)
SELECT name, rentals_date
FROM customers, rentals
WHERE customers.id IN ( -- posso usar = no lugar do IN
	SELECT id_customers, rentals_date
    FROM rentals
    WHERE rentals_date BETWEEN '2016-09-01' AND '2016-09-30'
)
LIMIT 1;*/

-- Exemplo 3 (ideal, mais clara e simples)
SELECT name, rentals_date
FROM customers
INNER JOIN rentals ON customers.id = id_customers
WHERE rentals_date BETWEEN '2016-09-01' AND '2016-09-30';

-- Exemplo 4 (pode ter um desempenho melhor, mas no beecrowd foi a que levou mais tempo -- em suma é subcolsulta aqui desnecessário sendo que where funcionou perfeitamente)
SELECT name, rentals_date
FROM customers
INNER JOIN (
	SELECT id_customers, rentals_date -- subconsulta
    FROM rentals
	WHERE rentals_date BETWEEN '2016-09-01' AND '2016-09-30'
) rentals ON customers.id = id_customers;

