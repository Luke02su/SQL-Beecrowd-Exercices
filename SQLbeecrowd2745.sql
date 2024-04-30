CREATE DATABASE beecrowd2745;
USE beecrowd2745;

CREATE TABLE people (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
    salary NUMERIC(4, 0)
);

INSERT INTO people (name, salary) VALUES ('James M. Tabarez', 883);
INSERT INTO people (name, salary) VALUES ('Rafael T. Hendon', 4281);
INSERT INTO people (name, salary) VALUES ('Linda J. Gardner', 4437);
INSERT INTO people (name, salary) VALUES ('Nicholas J. Conn', 8011);
INSERT INTO people (name, salary) VALUES ('Karol A. Morales', 2508);
INSERT INTO people (name, salary) VALUES ('Lolita S. Graves', 8709);

SELECT * FROM people;

-- Exemplo 1 (consulta -- ideal, simples e claro -- 3s c/ renomeação e 2s s/ renomeação)
SELECT p.name, ROUND(p.salary * 0.10, 2) AS tax
FROM people p
WHERE p.salary > 3000;

-- Exemplo 2 (junção implícita -- teste, totalmente desnecessário e redundante -- 5s)
SELECT p.name, ROUND(p.salary * 0.10, 2) AS tax
FROM people p, people pp
WHERE p.id = pp.id
AND p.salary > 3000;

-- Exemplo 3 (subconsulta -- teste, totalmente desnecessário e redundante -- 3s)
SELECT p.name, ROUND(p.salary * 0.10, 2) AS tax
FROM people p
WHERE p.id IN (
	SELECT p.id
    FROM people AS p
    WHERE p.salary > 3000
);

-- Exemplo 4 (junção explícita --  teste, totalmente desnecessário e redundante -- 3s c/ LEFT, [5s a 10] c/ INNER, 4s RIGHT)
SELECT p.name, ROUND(p.salary * 0.10, 2) AS tax
FROM people p
LEFT JOIN people AS pp ON p.id = pp.id
WHERE pp.salary > 3000;

-- Exemplo 5 (junção explícita c/ subconsulta -- teste, totalmente desnecessário e redundante -- 2s)
SELECT p.name, ROUND(p.salary * 0.10, 2) AS tax
FROM people p
INNER JOIN (
	SELECT p.id
    FROM people AS p
    WHERE p.salary > 3000
) pp ON p.id = pp.id;
