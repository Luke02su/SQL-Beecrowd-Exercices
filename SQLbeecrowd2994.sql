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

-- Exemplo 3 (consulta c/ junção explícita -- ideal -- 0.006s)
SELECT d.name, ROUND(SUM((a.hours * 150) + ((a.hours * 150) * (w.bonus / 100))), 1) AS salary
FROM attendances a
INNER JOIN doctors d ON a.id_doctor = d.id
INNER JOIN work_shifts w ON a.id_work_shift = w.id
GROUP BY d.name
ORDER BY salary DESC;

CREATE VIEW view_query AS (
	SELECT d.name, ROUND(SUM((a.hours * 150) + ((a.hours * 150) * (w.bonus / 100))), 1) AS salary
	FROM attendances a
	INNER JOIN doctors d ON a.id_doctor = d.id
	INNER JOIN work_shifts w ON a.id_work_shift = w.id
	GROUP BY d.name
	ORDER BY salary DESC
);

SELECT * FROM view_query;