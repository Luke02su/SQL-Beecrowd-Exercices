CREATE DATABASE beecrowd3483;
USE beecrowd3483;

CREATE TABLE cities (
	id INT AUTO_INCREMENT PRIMARY KEY,
	city_name VARCHAR(35),
    population BIGINT
);

INSERT INTO cities (city_name, population) VALUES ('São Paulo', 12396372);
INSERT INTO cities (city_name, population) VALUES ('Rio de Janeiro', 6775561);
INSERT INTO cities (city_name, population) VALUES ('Brasília', 3094325);
INSERT INTO cities (city_name, population) VALUES ('Salvador', 2900319);
INSERT INTO cities (city_name, population) VALUES ('Fortaleza', 2703391);
INSERT INTO cities (city_name, population) VALUES ('Belo Horizonte', 2530701);
INSERT INTO cities (city_name, population) VALUES ('Manaus', 2255903);
INSERT INTO cities (city_name, population) VALUES ('Curitiba', 1963726);
INSERT INTO cities (city_name, population) VALUES ('Recife', 1661017);
INSERT INTO cities (city_name, population) VALUES ('Goiânia', 1555626);
INSERT INTO cities (city_name, population) VALUES ('Belém', 1506420);
INSERT INTO cities (city_name, population) VALUES ('Porto Alegre', 1492530);

SELECT * FROM cities;

-- Exemplo 1 (consulta c/ 2 subconsultas -- 3s s/ renomeação de tabela)
SELECT city_name, population
FROM cities 
WHERE population = (
	SELECT MAX(population)
    FROM cities  
    WHERE population < (
		SELECT MAX(population)
		FROM cities
    )
)
UNION ALL
SELECT city_name, population
FROM cities
WHERE population = (
	SELECT MIN(population)
	FROM cities
    WHERE population > (
		SELECT MIN(population)
        FROM cities
    )
);

-- Exemplo 1.1 (consulta c/ subconsulta -- 5s c/ renomeacao de tabela)
SELECT c.city_name, c.population
FROM cities c
WHERE c.population = ( -- IN (verifica se a pelo menos um valor na lista, podendo retornar mais) e = (verifica se há exatamente um igual a ele na lista, retornando apenas um)
	SELECT MAX(c.population)
    FROM cities c
    WHERE c.population < (
		SELECT MAX(c.population)
		FROM cities c
    )
)
UNION ALL
SELECT c.city_name, c.population
FROM cities c
WHERE c.population = (
	SELECT MIN(c.population)
    FROM cities c
    WHERE c.population > (
		SELECT MIN(c.population)
		FROM cities c
    )
);

-- Exemplo 2 (5s)
SELECT c.city_name, c.population
FROM cities c, cities cc
WHERE c.id = cc.id
AND c.population = (
	SELECT MAX(cc.population)
    FROM cities cc
    WHERE population < (
		SELECT MAX(cc.population)
		FROM cities cc
    )
)
UNION ALL
SELECT c.city_name, c.population
FROM cities c, cities cc
WHERE c.id = cc.id
AND cc.population = (
	SELECT MIN(c.population)
    FROM cities c
    WHERE c.population > (
		SELECT MIN(c.population)
		FROM cities c
    )
);



-- Exempo 3 (10s)
SELECT c.city_name, c.population
FROM cities c
INNER JOIN (
	SELECT MAX(c.population)
    FROM cities c
) cc ON c.id = cc.id;


UNION ALL
SELECT c.city_name, c.population
FROM cities c, cities cc

AND cc.population = (
	SELECT MIN(c.population)
    FROM cities c
    WHERE c.population > (
		SELECT MIN(c.population)
		FROM cities c
    )
);