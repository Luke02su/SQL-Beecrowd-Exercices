CREATE DATABASE beecrowd2737;
USE beecrowd2737;

CREATE TABLE lawyers (
	register INT,
    name VARCHAR(40) NOT NULL,
	customers_number INT NOT NULL,
    
    PRIMARY KEY (register)
);

INSERT INTO lawyers (register, name, customers_number) VALUES (1648, 'Marty M. Harrison', 5);
INSERT INTO lawyers (register, name, customers_number) VALUES (2427, 'Jonathan J. Blevins', 15);
INSERT INTO lawyers (register, name, customers_number) VALUES (3365, 'Chelsey D. Sanders', 20);
INSERT INTO lawyers (register, name, customers_number) VALUES (4153, 'Dorothy W. Ford', 16);
INSERT INTO lawyers (register, name, customers_number) VALUES (5525, 'Penny J. Cormier', 6);

SELECT * FROM lawyers;

-- Exemplo 1 (subconsulta sem join -- 4s)
SELECT l.name, l.customers_number
FROM lawyers AS l
WHERE customers_number IN (
	SELECT MAX(customers_number) 
    FROM lawyers
)

UNION ALL 

SELECT l.name, l.customers_number
FROM lawyers AS l
WHERE customers_number IN (
	SELECT MIN(customers_number)
	FROM lawyers
)

UNION ALL

SELECT 'Average' AS name, ROUND(AVG(l.customers_number))
FROM lawyers AS l;

-- Exemplo 2 (RUNTIME ERROR no Beecrowd por causa do GROUP BY, no entanto, funciona, embora seja mais confuso -- MAX e MIN devem ser calculados separadamente -- 4s)
/*SELECT l.name, l.customers_number
FROM lawyers AS l
INNER JOIN (
	SELECT MAX(customers_number) AS max_customers_number, 
		MIN(customers_number) AS min_customers_number
    FROM lawyers
) AS subquery ON l.customers_number = subquery.max_customers_number OR l.customers_number = subquery.min_customers_number
GROUP BY l.name, l.customers_number DESC -- ordenar primeiramente pelo name (asc) e depois customers_number
UNION -- combina resultado de duas ou mais consultas -- retirando as duplicadas
SELECT 'Average' AS name, ROUND(AVG(customers_number)) AS customers_number
FROM lawyers;*/

-- Exemplo 3 (funcionou com o diferencial do UNION ALL para cada consulta separada feita com JOIN e subconsulta -- 6s)
SELECT l.name, l.customers_number
FROM lawyers AS l
INNER JOIN (
    SELECT MAX(customers_number) AS max_customers_number
    FROM lawyers
) AS subquery 
ON l.customers_number = subquery.max_customers_number

UNION ALL -- combina resultado de duas ou mais consultas (UNION ALL consome menos processamento que o UNION) -- Como já se sabe que não há resultados duplicados, UNION torna-se desnecessário

SELECT l.name, l.customers_number
FROM lawyers AS l
INNER JOIN (
    SELECT MIN(customers_number) AS min_customers_number
    FROM lawyers
) AS subquery 
ON l.customers_number = subquery.min_customers_number

UNION ALL -- combina resultado de duas ou mais consultas

SELECT 'Average' AS name, ROUND(AVG(customers_number)) AS customers_number -- Insiro nome 'Average' na coluna 'name' -- ROUND serve para arredondar [arredonda de todos valores da tabela customers_numer]
FROM lawyers;

-- PODE HAVER OUTRAS FORMAS MAIS EFICIENTES QUE ESSAS