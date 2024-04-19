CREATE DATABASE beecrowd2623;
USE beecrowd2623;

CREATE TABLE products (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(30),
    amount NUMERIC(3, 0),
    price NUMERIC(6, 2),
    id_categories INT NOT NULL,

	CONSTRAINT pk_id_categories FOREIGN KEY (id_categories) 
    REFERENCES categories(id)
);

CREATE TABLE categories (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20)
);

INSERT products (name, amount, price, id_categories) VALUES ('Blue Chair', 30, 300.00, 9);
INSERT products (name, amount, price, id_categories) VALUES ('Red Chair', 200, 2150.00, 2);
INSERT products (name, amount, price, id_categories) VALUES ('Disney Wardrobe', 400, 829.5, 4);
INSERT products (name, amount, price, id_categories) VALUES ('Blue Toaster', 20, 9.90, 3);
INSERT products (name, amount, price, id_categories) VALUES ('Solar Panel', 30, 3000.25, 4);

SELECT * FROM products;

INSERT INTO categories (name) VALUES ('Superior');
INSERT INTO categories (name) VALUES ('Super Luxury');
INSERT INTO categories (name) VALUES ('Modern');
INSERT INTO categories (name) VALUES ('Nerd');
INSERT INTO categories (name) VALUES ('Infantile');
INSERT INTO categories (name) VALUES ('Robust');
INSERT INTO categories (name) VALUES ('Wood');

UPDATE categories SET id = 9 WHERE id = 7; -- alterando conforme o beecrowd pede, pois é o id é auto_increment

SELECT * FROM categories;


-- Exemplo 2
SELECT p.name, c.name
FROM products AS p
INNER JOIN categories AS c ON p.id_categories = c.id
WHERE p.amount > 100 AND p.id_categories = 1 OR 2 OR 3 OR 6 OR 9;