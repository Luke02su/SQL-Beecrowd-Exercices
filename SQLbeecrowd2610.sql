CREATE DATABASE beecrowd2610;
USE beecrowd2610;

CREATE TABLE products (
	id int auto_increment primary key,
    name varchar(30),
    amount int not null,
    price float not null
);

INSERT INTO products VALUES ('default', 'Two-doors wardrobe', 100, 800);
INSERT INTO products VALUES ('default', 'Dining table', 1000, 560);
INSERT INTO products VALUES ('default', 'Towel holder', 10000, 25.50);
INSERT INTO products VALUES ('default', 'Computer desk', 350, 320.50);
INSERT INTO products VALUES ('default', 'Chair', 3000, 210.64);
INSERT INTO products VALUES ('default', 'Single bed', 750, 460);

SELECT * FROM products;

SELECT AVG(price) FROM PRODUCTS; -- média de todos os preços na coluna price sem arredondamento

ALTER TABLE products MODIFY COLUMN price decimal(5, 2); -- alterei os valores float da coluna preço para decimal (5 casas, duas após a vírgula)

SELECT ROUND(AVG(price), 2) AS price FROM products; -- tive de usar ROUND para arrendodar os dois valores decimais