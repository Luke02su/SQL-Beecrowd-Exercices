CREATE DATABASE beecrowd2618;
USE beecrowd2618;

CREATE TABLE products (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    amount INT NOT NULL,
    price  FLOAT NOT NULL,
    id_providers  INT NOT NULL,
    id_categories INT NOT NULL,
    
    FOREIGN KEY pk_id_providers(id_providers) REFERENCES providers(id),
    FOREIGN KEY pk_id_categories(id_categories) REFERENCES categories(id)
);

CREATE TABLE providers (
	id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(40) NOT NULL,
    city VARCHAR(25) NOT NULL,
	state CHAR(2) NOT NULL
);

CREATE TABLE categories (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(25) NOT NULL
);

ALTER TABLE providers ADD COLUMN name VARCHAR(25) NOT NULL AFTER id; -- esqueci de adicionar a coluna name

INSERT INTO products (name, amount, price, id_providers, id_categories) VALUES ('Blue Chair', 30, 300.00, 5, 5);
INSERT INTO products (name, amount, price, id_providers, id_categories) VALUES ('Red Chair', 50, 2150.00, 2, 1);
INSERT INTO products (name, amount, price, id_providers, id_categories) VALUES ('Disney Wardrobe', 400,	829.50,	4, 1);
INSERT INTO products (name, amount, price, id_providers, id_categories) VALUES ('Blue Toaster', 20, 9.90, 3, 1);
INSERT INTO products (name, amount, price, id_providers, id_categories) VALUES ('TV', 30, 3000.25, 2, 2);

SELECT * FROM products;

INSERT INTO providers (name, street, city, state) VALUES ('Ajax SA', 'Rua Presidente Castelo Branco', 'Porto Alegre', 'RS');
INSERT INTO providers (name, street, city, state) VALUES ('Sansul SA', 'Av Brasil', 'Rio de Janeiro', 'RJ');
INSERT INTO providers (name, street, city, state) VALUES ('South Chairs', 'Rua do Moinho', 'Santa Maria', 'RS');
INSERT INTO providers (name, street, city, state) VALUES ('Elon Electro', 'Rua Apolo', 'São Paulo', 'SP');
INSERT INTO providers (name, street, city, state) VALUES ('Mike Electro', 'Rua Pedro da Cunha', 'Curitiba', 'PR');

SELECT * FROM providers;

INSERT INTO categories (name) VALUES ('Super Luxury');
INSERT INTO categories (name) VALUES ('Imported');
INSERT INTO categories (name) VALUES ('Tech');
INSERT INTO categories (name) VALUES ('Vintage');
INSERT INTO categories (name) VALUES ('Supreme');

SELECT * FROM categories;

/*-- Exemplo 1 (menos ideal -- erro no beecrowd)
SELECT products.name, providers.name, categories.name
FROM products, providers, categories
WHERE providers.id = id_providers AND providers.id = id_categories
AND providers.name = 'Sansul SA' AND categories.name = 'Imported';*/

-- Exemplo 2 (gambiarra subcosulta, não usar!)
/*SELECT products.name, providers.name, categories.name
FROM products, providers, categories
WHERE id_providers IN (
	SELECT providers.id
	FROM providers
    WHERE providers.name = 'Sansul SA'
) AND id_categories In (
	SELECT categories.id
    FROM categories
	WHERE categories.name = 'Imported'
)
LIMIT 1;*/

-- Exemplo 3 (ideal)
SELECT products.name, providers.name, categories.name
FROM products
INNER JOIN providers ON id_providers = providers.id 
INNER JOIN categories ON id_categories = categories.id
WHERE providers.name = 'Sansul SA' AND categories.name = 'Imported';

-- Exemplo 4 (desnecessário subconsulta -- fica redundante e perde desempenho)
SELECT products.name, providers.name, categories.name
FROM products
INNER JOIN providers ON id_providers = providers.id
INNER JOIN categories ON id_categories = categories.id
WHERE id_providers IN (
	SELECT providers.id
    FROM providers
    WHERE providers.name = 'Sansul SA'
)
AND id_categories IN (
	SELECT categories.id
    FROM categories
    WHERE categories.name = 'Imported'
);