CREATE database beecrowd2619;
USE beecrowd2619;

CREATE TABLE products (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    amount INT NOT NULL,
    price FLOAT NOT NULL,
    id_providers INT NOT NULL,
    id_categories INT NOT NULL,
	
    CONSTRAINT pk_id_providers FOREIGN KEY (id_providers) REFERENCES providers(id), -- poderia usar: FOREIGN KEY pk_id_providers (id_providers) REFERENCES providers(id)
    CONSTRAINT pk_id_categories FOREIGN KEY (id_categories) REFERENCES categories(id) -- -- poderia usar: FOREIGN KEY pk_id_categories (id_providers) REFERENCES categories(id)
);

CREATE TABLE providers (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    street VARCHAR(45) NOT NULL,
    city VARCHAR(25) NOT NULL,
    state CHAR(2) NOT NULL
);

CREATE TABLE categories (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(25) NOT NULL
);

INSERT INTO products (name, amount, price, id_providers, id_categories) VALUES ('Blue Chair', 30, 300.00, 5, 5);
INSERT INTO products (name, amount, price, id_providers, id_categories) VALUES ('Red Chair', 50, 2150.00, 2, 1);
INSERT INTO products (name, amount, price, id_providers, id_categories) VALUES ('Disney Wardrobe', 400, 829.50, 4, 1);
INSERT INTO products (name, amount, price, id_providers, id_categories) VALUES ('Blue Toaster', 20, 9.90, 3, 1);
INSERT INTO products (name, amount, price, id_providers, id_categories) VALUES ('TV', 30, 3000.25, 2, 2);

SELECT * FROM products;
TRUNCATE products; -- como redefini o id de providers, foi apagado dados de products relacionados. Preferi apagar toda a tabela e inserá-la novamente

INSERT INTO providers (name, street, city, state) VALUES ('Ajax SA', 'Rua Presidente Castelo Branco', 'Porto Alegre', 'RS'); 
INSERT INTO providers (name, street, city, state) VALUES ('Sansul SA', 'Av Brasil', 'Rio de Janeiro', 'RJ'); 
INSERT INTO providers (name, street, city, state) VALUES ('Sansul SA', 'Av Brasil', 'Rio de Janeiro', 'RJ'); -- duplicado
INSERT INTO providers (name, street, city, state) VALUES ('South Chairs', 'Rua do Moinho', 'Santa Maria', 'RS'); 
INSERT INTO providers (name, street, city, state) VALUES ('Elon Electro', 'Rua Apolo', 'São Paulo', 'SP'); 
INSERT INTO providers (name, street, city, state) VALUES ('Mike electro', 'Rua Pedro da Cunha', 'Curitiba', 'PR'); 

ALTER TABLE products DROP CONSTRAINT pk_id_categories; -- apagando a chave estrangeira para redefinir as restrições para alterar os dados duplicados inseridos (poderia ser FOREIGN KEY no lugar de CONSTRAINT)

ALTER TABLE products DROP FOREIGN KEY pk_id_providers; -- não era necessário redefinir esta (poderia ser CONSTARINT no lugar de FOREIGN KEY)

ALTER TABLE products
ADD CONSTRAINT pk_id_providers FOREIGN KEY (id_providers) REFERENCES providers(id) 
ON UPDATE CASCADE ON DELETE CASCADE; -- alterando restriçã de providers para poder alterar chaves primárias

ALTER TABLE products
ADD FOREIGN KEY pk_id_categories (id_categories) REFERENCES categories(id)
ON UPDATE CASCADE ON DELETE CASCADE; -- neste caso não era necessário alterar categories pois não foi inserido nada errado

SELECT * FROM providers;

DELETE FROM providers WHERE id = 2;
INSERT INTO providers (id, name, street, city, state) VALUES (2, 'Sansul SA', 'Av Brasil', 'Rio de Janeiro', 'RJ');
DELETE FROM providers WHERE id = 3;
UPDATE providers SET id = 3 WHERE id = 4;
UPDATE providers SET id = 4 WHERE id = 5;
UPDATE providers SET id = 5 WHERE id = 6;

INSERT INTO categories (name) VALUES ('Super Luxury');
INSERT INTO categories (name) VALUES ('Imported');
INSERT INTO categories (name) VALUES ('Tech');
INSERT INTO categories (name) VALUES ('Vintage');
INSERT INTO categories (name) VALUES ('Supreme');

SELECT * FROM categories;

-- Exemplo 1 (não é o ideal, gera ambiguidade e pode ocasionar erros)
SELECT products.name, providers.name, products.price
FROM products, providers, categories
WHERE id_providers = providers.id AND id_categories = categories.id
AND products.price > 1000 AND categories.name = 'Super Luxury';

-- Exemplo 2 (gambiarra total, beecrowd não aceita, além de não ser o ideal e totalmente desnecessário e gerar erros)
/*SELECT products.name, providers.name, products.price
FROM products, providers, categories
WHERE id_providers IN (
	SELECT providers.id
    FROM providers
    WHERE providers.id = id_providers
)
AND id_categories IN (
	SELECT categories.id
    FROM categories
    WHERE categories.id = id_categories
) 
AND products.price > 1000 AND categories.name = 'Super Luxury'
LIMIT 1;*/

-- Exemplo 3 (ideal, simples, fácil, legível)
SELECT products.name, providers.name, products.price
FROM products
INNER JOIN providers ON id_providers = providers.id
INNER JOIN categories ON id_categories = categories.id
WHERE products.price > 1000 AND categories.name = 'Super Luxury';

-- Exemplo 4 (beecrowd aceitou, mas é descenessário subconsulta aqui, redundante)
SELECT products.name, providers.name, products.price
FROM products
INNER JOIN providers ON id_providers = providers.id
INNER JOIN categories ON id_categories = categories.id
WHERE id_providers IN (
	SELECT providers.id
    FROM providers
    WHERE providers.id = id_providers
)
AND id_categories IN (
	SELECT categories.id
    FROM categories
    WHERE categories.id = id_categories AND categories.name = 'Super Luxury'
) 
AND products.price > 1000;