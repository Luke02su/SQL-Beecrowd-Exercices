CREATE DATABASE beecrowd2742;
USE beecrowd2742;

CREATE TABLE dimensions (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
    
    INDEX id_idx (id) -- cria automaticamente
);

CREATE TABLE life_registry (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    omega FLOAT NOT NULL,
    dimensions_id INT NOT NULL,

	INDEX dimensions_id_idx (dimensions_id),
    
    CONSTRAINT fk_dimensions_id 
    FOREIGN KEY life_registry(dimensions_id) 
    REFERENCES dimensions(id)
);

INSERT INTO dimensions (name) VALUES ('C774');
INSERT INTO dimensions (name) VALUES ('C784');
INSERT INTO dimensions (name) VALUES ('C794');
INSERT INTO dimensions (name) VALUES ('C824');
INSERT INTO dimensions (name) VALUES ('C875');
    
SELECT * FROM dimensions;

INSERT INTO life_registry (name, omega, dimensions_id) VALUES ('Richard Postman', 5.6, 2);
INSERT INTO life_registry (name, omega, dimensions_id) VALUES ('Simple Jelly', 1.4, 1);
INSERT INTO life_registry (name, omega, dimensions_id) VALUES ('Richard Gran Master', 2.5, 1);
INSERT INTO life_registry (name, omega, dimensions_id) VALUES ('Richard Turing', 6.4, 4);
INSERT INTO life_registry (name, omega, dimensions_id) VALUES ('Richard Strall', 1.0, 3);

SELECT * FROM life_registry;

-- Exemplo 1 (junção implícita -- não é o ideal)
SELECT l.name, ROUND((l.omega * 1.618), 3) AS "Fator N"
FROM life_registry AS l, dimensions AS d
WHERE l.dimensions_id = d.id
AND l.name LIKE 'Richard%' AND (d.name = 'C774' OR d.name = 'C875');

/*-- Exemplo 2 (junção implícita e subconsulta -- gambiarra total -- não usar -- não rodou no Beecrowd)
SELECT DISTINCT l.name, ROUND((l.omega * 1.618), 3) AS "Fator N" -- como duplicou os valores com a junção implícita e subconsulta, DISTINCT foi importante, caso contrário deveria se usar LIMIT 1, mas mesmo assim, ambas formas o Beecrowd dá erro, com LIMIT 30%, com DISTINCT 0%, mas como as duas são gambiarras, faz sentido
FROM life_registry AS l, dimensions AS d
WHERE l.name LIKE 'Richard%' 
AND l.dimensions_id AND (
	SELECT d.id
	FROM dimensions AS d
    WHERE d.name = 'C774' OR d.name = 'C875'
);
-- LIMIT 1;*/

-- Exemplo 3 (junção explícita com LEFT JOIN -- 2s -- ideal [c/ INNER JOIN levou 3s e c/ RIGTH levou 8s])
SELECT l.name, ROUND((l.omega * 1.618), 3) AS "Fator N" 
FROM life_registry AS l
LEFT JOIN dimensions AS d ON l.dimensions_id = d.id
WHERE l.name LIKE 'Richard%' AND (d.name = 'C774' OR d.name = 'C875'); -- ideal usar parênteses quando se usa OR para não haver confusão com AND no meio, como ocorreu no Beecrowd, embora no MySQL não seja necessário

-- Exemplo 4 (juncão explícita c/ subconsulta -- desnecessário e confuso -- 4s)
SELECT l.name, ROUND((l.omega * 1.618), 3) AS "Fator N"
FROM life_registry AS l
RIGHT JOIN ( -- tem que ser INNER ou RIGHT (ambos derem 4s)
	SELECT d.id
	FROM dimensions AS d
    WHERE d.name = 'C774' OR d.name = 'C875'
) dimensions ON l.dimensions_id = dimensions.id
WHERE l.name LIKE 'Richard%';

-- Vários exemplos para teste, mas é óbvio que o Exemplo 3 sempre será o ideal.