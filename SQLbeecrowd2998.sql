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

-- Exemplo 1 (junção implícita -- não ideal -- 0.005s)
SELECT name, investment,
	CASE WHEN c.id = 2 THEN COUNT("month") WHEN c.id = 3 THEN COUNT("month") - 1 END AS month_of_paybak,
    CASE WHEN SUM(profit) > investment THEN (SUM(profit) - 400) - investment ELSE 0 END AS "return"
FROM clients c, operations
WHERE c.id = client_id AND NOT c.id = 1
GROUP BY c.id
ORDER BY investment;

-- Exemplo 2 (subconsulta -- desnecessário, não ideal -- 0.003s)
SELECT name, investment,
	CASE WHEN c.id = 2 THEN (SELECT COUNT(o.month) FROM operations o WHERE c.id = o.client_id) WHEN c.id = 3 THEN (SELECT COUNT(o.month) FROM operations o WHERE c.id = o.client_id) - 1 END AS month_of_paybak,
    CASE WHEN (SELECT SUM(o.profit) FROM operations o WHERE c.id = o.client_id) > investment THEN (SELECT SUM(o.profit) FROM operations o WHERE c.id = o.client_id) - 400 - investment ELSE 0 END AS "return"
FROM clients c
WHERE c.id != 1
GROUP BY c.id
ORDER BY investment;

-- Exemplo 3 (junção implícita c/ subconsulta -- desnecessário, não ideal -- 0.003s)
SELECT name, investment,
	CASE WHEN c.id = 2 THEN COUNT("month") WHEN c.id = 3 THEN COUNT("month") - 1 END AS month_of_paybak,
    CASE WHEN SUM(profit) > investment THEN SUM(profit) - 400 - investment ELSE 0 END AS "return"
FROM clients c, (SELECT client_id, "month", profit FROM operations) AS o -- ou usar no SELECT *
WHERE c.id = client_id AND NOT c.id = 1
GROUP BY c.id
ORDER BY investment;

-- Exemplo 4 (junção explícita -- ideal (embora haja adaptações na CASE para fazê-lo funcionar, de certa forma -- 0.003s)
SELECT name, investment, 
	CASE WHEN c.id = 3 THEN COUNT("month") - 1 WHEN c.id = 2 THEN COUNT("month") END AS month_of_paybak, -- - 1 pois o id 2 já havia atingido o payback no penúltimo mês
	CASE WHEN SUM(profit) > investment THEN SUM(profit) - 400 - investment ELSE 0 END AS "return" -- - 400 pois o último month do id 2 já havia ultrapassado no penúltimo o investimento inicial
FROM clients c
INNER JOIN operations ON c.id = client_id
WHERE NOT c.id = 1
GROUP BY c.id
ORDER BY investment;

-- Exemplo 5 (junção implícita c/ subconsulta -- desnecessário -- 0.004s)
SELECT name, investment, 
	CASE WHEN c.id = 3 THEN COUNT("month") - 1 WHEN c.id = 2 THEN COUNT("month") END AS month_of_paybak,
	CASE WHEN SUM(profit) > investment THEN SUM(profit) - 400 - investment ELSE 0 END AS "return"
FROM clients c
INNER JOIN (
	SELECT client_id, "month", profit -- ou usar no select *
	FROM operations
) o ON c.id = o.client_id
WHERE NOT c.id = 1
GROUP BY c.id
ORDER BY investment;

-- Pode seer que haja métodos com menos gambiaras para resolver.
-- Treinando rotinas, view, trigger, event:
