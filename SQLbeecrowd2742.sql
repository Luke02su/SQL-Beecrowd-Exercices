CREATE DATABASE beecrowd2742;
USE beecrowd2742;

CREATE TABLE dimensions (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
    
    INDEX id_idx (id)
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

life_registry
id	name	omega	dimensions_id
1	Richard Postman	5.6	2
2	Simple Jelly	1.4	1
3	Richard Gran Master	2.5	1
4	Richard Turing	6.4	4
5	Richard Strall	1.0	3