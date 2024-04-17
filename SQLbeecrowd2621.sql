CREATE DATABASE beecrowd2621;
USE beecrowd2621;

CREATE TABLE providers (
	id INT AUTO_INCREMENT PRIMARY KEY,
	street VARCHAR(45) NOT NULL,
    city VARCHAR(25) NOT NULL,
    state CHAR(2) NOT NULL
);

ALTER TABLE providers ADD COLUMN name VARCHAR(45) NOT NULL AFTER id; -- faltou a coluna name

CREATE TABLE products (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
    amount INT NOT NULL,
    price FLOAT NOT NULL,
    id_providers INT NOT NULL,
    
    CONSTRAINT pk_id_providers FOREIGN KEY (id_providers) REFERENCES providers(id)
);

INSERT INTO providers (name, street, city, state) VALUES ('Ajax SA', 'Rua Presidente Castelo Branco', 'Porto Alegre', 'RS');
INSERT INTO providers (name, street, city, state) VALUES ('Sansul SA', 'Av Brasil', 'Rio de Janeiro', 'RJ');
INSERT INTO providers (name, street, city, state) VALUES ('Pr Sheppard Chairs', 'Rua do Moinho', 'Santa Maria', 'RS');
INSERT INTO providers (name, street, city, state) VALUES ('Elon Electro', 'Rua Apolo', 'São Paulo', 'SP');
INSERT INTO providers (name, street, city, state) VALUES ('Mike Electro', 'Rua Pedro da Cunha', 'Curitiba', 'PR');

SELECT * FROM providers;

INSERT INTO products (name, amount, price, id_providers) VALUES ('Blue Chair', 30, 300.00, 5);
INSERT INTO products (name, amount, price, id_providers) VALUES ('Red Chair', 50, 2150.00, 2);
INSERT INTO products (name, amount, price, id_providers) VALUES ('Disney Wardrobe', 400, 829.50, 4);
INSERT INTO products (name, amount, price, id_providers) VALUES ('Executive Chair', 17, 9.90, 3);
INSERT INTO products (name, amount, price, id_providers) VALUES ('Solar Panel', 30, 3000.25, 4);

SELECT * FROM products;

-- Exemplo 1 (3 segundos)
SELECT products.name
FROM products, providers
WHERE id_providers = providers.id
AND products.amount BETWEEN 10 AND 20 AND providers.name LIKE 'P%';

/*-- Exemplo 2 (subconsulta funciona -- mas erro no beecrowd 60%)
SELECT products.name
FROM products, providers
WHERE id_providers = providers.id 
AND products.amount BETWEEN 10 AND 20 AND providers.id IN (
	SELECT id_providers
    FROM providers
    WHERE providers.name LIKE 'P%'
);*/

-- Exemplo 3 (IDEAL -- 5 segundos com INNER JOIN, 4 segundos com LEFT JOIN (neste caso é o melhor a se usar)
SELECT products.name
FROM products
LEFT JOIN providers ON id_providers = providers.id
WHERE products.amount BETWEEN 10 AND 20 AND providers.name LIKE 'P%';

-- Exemplo 4 (desnecessária a subconsulta, mas funciona -- erro no beecrowd 60%)
/*SELECT products.name
FROM products
LEFT JOIN providers ON id_providers = providers.id
WHERE products.amount BETWEEN 10 AND 20 AND providers.id IN (
	SELECT id_providers
    FROM providers
    WHERE providers.name LIKE 'P%'
);*/