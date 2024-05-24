CREATE DATABASE beecrowd2994;
USE beecrowd2994;

CREATE TABLE doctors (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(25) NOT NULL
);

CREATE TABLE work_shifts (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
	bonus SMALLINT NOT NULL
);

CREATE TABLE attendances (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    id_doctor SMALLINT NOT NULL,
    hours SMALLINT NOT NULL,
    id_work_shift SMALLINT NOT NULL,
    
    INDEX id_doctor_idx (id_doctor),
    INDEX id_work_shift_idx (id_work_shift),
    
    CONSTRAINT pk_id_doctor FOREIGN KEY (id_doctor) REFERENCES doctors(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT pk_id_work_shift FOREIGN KEY (id_work_shift) REFERENCES work_shifts(id) ON UPDATE RESTRICT ON DELETE RESTRICT
);

INSERT INTO doctors VALUES (default, 'Arlino');
INSERT INTO doctors VALUES (default, 'Tiago');
INSERT INTO doctors VALUES (default, 'Amanda');
INSERT INTO doctors VALUES (default, 'Wellington');

SELECT * FROM doctors;

INSERT INTO work_shifts VALUES (default, 'nocturnal', 15);
INSERT INTO work_shifts VALUES (default, 'afternoon', 2);
INSERT INTO work_shifts VALUES (default, 'day', 1);

SELECT * FROM work_shifts;

INSERT INTO attendances VALUES (default, 1, 5, 1);
INSERT INTO attendances VALUES (default, 3, 2, 1);
INSERT INTO attendances VALUES (default, 3, 3, 2);
INSERT INTO attendances VALUES (default, 2, 2, 3);
INSERT INTO attendances VALUES (default, 1, 5, 3);
INSERT INTO attendances VALUES (default, 4, 1, 3);
INSERT INTO attendances VALUES (default, 4, 2, 1);
INSERT INTO attendances VALUES (default, 3, 2, 2);
INSERT INTO attendances VALUES (default, 2, 4, 2);

SELECT * FROM attendances;

-- Exemplo 1 (consulta c/junção implícita -- pode gerar ambiguidade -- 0.003s) 
SELECT d.name, ROUND(SUM((a.hours * 150.0) * (1.0 + (w.bonus / 100.0))), 1) AS salary
FROM attendances a, doctors d, work_shifts w
WHERE a.id_doctor = d.id AND a.id_work_shift = w.id
GROUP BY d.name
ORDER BY salary DESC;

-- Exemplo 2 (consulta c/subconsulta-- gambiarra total -- 0.0011s)
SELECT (SELECT d.name FROM doctors d WHERE d.id = a.id_doctor) AS name, 
ROUND(SUM((a.hours * 150.0) * (1.0 + ((SELECT w.bonus FROM work_shifts w WHERE w.id = a.id_work_shift) / 100.0))), 1) AS salary
FROM attendances a
	WHERE EXISTS (
		SELECT 1
        FROM doctors d, work_shifts w
        WHERE a.id_doctor = d.id AND a.id_work_shift = w.id
	)
GROUP BY (SELECT d.name FROM doctors d WHERE d.id = a.id_doctor)
ORDER BY salary DESC;

-- Exemplo 3 (consulta c/ junção implícita e subconsulta -- gambiarra -- 0.005s)
SELECT d.name, ROUND(SUM((a.hours * 150.0) * (1.0 + ((SELECT w.bonus FROM work_shifts w WHERE w.id = a.id_work_shift) / 100.0))), 1) AS salary
FROM attendances a, doctors d
WHERE a.id_doctor = d.id 
	AND EXISTS (
		SELECT 1
        FROM work_shifts w
        WHERE a.id_work_shift = w.id
	)
GROUP BY d.name
ORDER BY salary DESC;

-- Exemplo 4 (consulta c/ junção explícita -- ideal -- 0.005s)
SELECT d.name, ROUND(SUM((a.hours * 150.0) + ((a.hours * 150.0) * (w.bonus / 100.0))), 1) AS salary
FROM attendances a
INNER JOIN doctors d ON a.id_doctor = d.id
INNER JOIN work_shifts w ON a.id_work_shift = w.id
GROUP BY d.name
ORDER BY salary DESC;


CREATE VIEW view_exemple3 AS (
	SELECT d.name, ROUND(SUM((a.hours * 150.0) + ((a.hours * 150.0) * (w.bonus / 100.0))), 1) AS salary
	FROM attendances a
	INNER JOIN doctors d ON a.id_doctor = d.id
	INNER JOIN work_shifts w ON a.id_work_shift = w.id
	GROUP BY d.name
	ORDER BY salary DESC
);

SELECT * FROM view_query;

-- Exemplo 4.1 (consulta c/ junção explícita -- ideal (cálculo de porcentagem mais direto)-- 0.004s)
SELECT d.name, ROUND(SUM((a.hours * 150.0) * (1.0 + (w.bonus / 100.0))), 1) AS salary
FROM attendances a
INNER JOIN doctors d ON a.id_doctor = d.id
INNER JOIN work_shifts w ON a.id_work_shift = w.id
GROUP BY d.name
ORDER BY salary DESC;

-- Exemplo 5 (consulta c/ junção explícita e subconsulta -- desnecessário -- 0.008s)
SELECT d.name, ROUND(SUM((a.hours * 150.0) * (1.0 + (w.bonus / 100.0))), 1) AS salary
FROM attendances a
INNER JOIN (
	SELECT d.id, d.name
    FROM doctors d
) d ON a.id_doctor = d.id
INNER JOIN (
	SELECT w.id, w.bonus
    FROM work_shifts w
) w ON a.id_work_shift = w.id
GROUP BY d.name
ORDER BY salary DESC;

DELIMITER %%
CREATE PROCEDURE proc_doctors_name_info (IN name_doc VARCHAR(20))
BEGIN
	SELECT * FROM doctors
    INNER JOIN attendances a ON a.id = id_doctor
    WHERE name_doc = name;
END%%
DELIMITER ;
CALL proc_doctors_name_info ('Arlino');

CREATE TEMPORARY TABLE delete_doctor (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    user VARCHAR(20) NOT NULL,
    date TIMESTAMP NOT NULL
);

DELIMITER %%
CREATE TRIGGER trg_delete_doctor_old AFTER DELETE
ON doctors
FOR EACH ROW
BEGIN
	INSERT INTO delete_doctor (
		id,
		name, 
		user,
		date
	)
    VALUES (
		OLD.id,
		OLD.name,
		USER(),
        NOW()
    );
END%%
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM doctors WHERE id = 4;

SELECT * FROM doctors;
SELECT * FROM delete_doctor;

DELIMITER %%
CREATE FUNCTION attendances_avg_hours () -- função retorna apenas um valor
RETURNS FLOAT DETERMINISTIC 
BEGIN
	DECLARE media_hours FLOAT;
		SELECT ROUND(AVG(CAST(hours AS FLOAT)), 2) INTO media_hours FROM attendances; -- CAST converter, neste caso, para FLOAT
    RETURN media_hours;
END%%
DELIMITER ;

SELECT attendances_avg_hours();

-- Testando exemplos e treinando outras funcionalidades.
