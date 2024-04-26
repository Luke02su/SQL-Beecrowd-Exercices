CREATE DATABASE beecrowd2741;
USE beecrowd2741;

CREATE TABLE students (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(40),
    grade NUMERIC(2, 1),
    
    INDEX id_idx (id)
);

INSERT INTO students (name, grade) VALUES ('Terry B. Padilla', 7.3);
INSERT INTO students (name, grade) VALUES ('William S. Ray', 0.6);
INSERT INTO students (name, grade) VALUES ('Barbara A. Gongora', 5.2);
INSERT INTO students (name, grade) VALUES ('Julie B. Manzer', 6.7);
INSERT INTO students (name, grade) VALUES ('Teresa J. Axtell', 4.6);
INSERT INTO students (name, grade) VALUES ('Ben M. Dantzler', 9.6);

SELECT * FROM students;

-- Exemplo 1 (consulta ideal, simplificado, claro -- 4s)
SELECT CONCAT('Approved: ', s.name) AS name, s.grade
FROM students AS s
WHERE s.grade >= 7
ORDER BY s.grade DESC; -- antes estava ordenando implicitamento pelo id

-- Exemplo 2 (subconsulta da própria tabela -- desnecessário pois uma simples consulta realiza isso -- 5s)
SELECT CONCAT('Approved: ', s.name) AS name, s.grade
FROM students AS s
WHERE s.id IN (
	SELECT s.id
	FROM students AS s
    WHERE s.grade >= 7
)
ORDER BY s.grade DESC;

-- Exrmplo 3 (LEFT JOIN -- desnecessário pois uma simples consulta realiza isso -- 2s [por incrível que pareça, teve um desempenho melhor que o exemplo 1])
SELECT CONCAT('Approved: ', s.name) AS name, s.grade
FROM students AS s
LEFT JOIN students AS ss ON s.id = ss.id
WHERE s.grade >= 7
ORDER BY s.grade DESC;

-- Exemplo 4 (INNER JOIN + subconsulta -- desnecessário pois uma simples consulta realiza isso -- 4s)
SELECT CONCAT('Approved: ', s.name) AS name, s.grade
FROM students AS s
INNER JOIN (
	SELECT s.id, s.grade
	FROM students AS s
    WHERE s.grade >= 7
) AS ss ON s.id = ss.id
ORDER BY ss.grade DESC;