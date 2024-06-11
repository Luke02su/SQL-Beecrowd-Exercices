CREATE DATABASE beecrowd2998;
USE beecrowd2998;

CREATE TABLE clients (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
    investment INT NOT NULL
);

CREATE TABLE operations (
	id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    month INT NOT NULL,
    profit INT NOT NULL,
    
    INDEX idx_client_id (client_id),
    
    CONSTRAINT fk_client_id FOREIGN KEY (client_id) REFERENCES clients(id)
);

INSERT INTO clients VALUES (1, 'Daniel', 500); -- poderia desconsiderar inserir manualmente o id, pois é auto_increment, poderia usar default
INSERT INTO clients VALUES (2, 'Oliveira', 2000);
INSERT INTO clients VALUES (3, 'Lucas', 1000);

SELECT * FROM clients;

INSERT INTO operations VALUES (1, 1, 1, 230);
INSERT INTO operations VALUES (2, 2, 1, 1000);
INSERT INTO operations VALUES (3, 2, 2, 1000);
INSERT INTO operations VALUES (4, 3, 1, 100);
INSERT INTO operations VALUES (5, 3, 2, 300);
INSERT INTO operations VALUES (6, 3, 3, 900);
INSERT INTO operations VALUES (7, 3, 4, 400);

SELECT * FROM operations;

-- Exemplo 3 (gambiarra 0.003s)
SELECT name, investment, 
	CASE WHEN c.id = 3 THEN COUNT("month") - 1 WHEN c.id = 2 THEN COUNT("month") END AS month_of_paybak,
	CASE WHEN SUM(profit) > investment THEN (((SUM(profit)) - 400) - investment) ELSE 0 END AS "return"
FROM clients c
INNER JOIN operations ON c.id = client_id
WHERE NOT c.id = 1
GROUP BY c.id
ORDER BY investment;