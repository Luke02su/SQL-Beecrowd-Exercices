CREATE DATABASE beecrowd3481;
USE beecrowd3481;

CREATE TABLE nodes (
	node_id SMALLINT NOT NULL,
    pointer SMALLINT UNIQUE 
);

INSERT INTO nodes VALUES (50, 30);
INSERT INTO nodes VALUES (50, 75);
INSERT INTO nodes VALUES (30, 15);
INSERT INTO nodes VALUES (30, 35);
INSERT INTO nodes VALUES (15, 1);
INSERT INTO nodes VALUES (15, 20);
INSERT INTO nodes VALUES (35, 32);
INSERT INTO nodes VALUES (35, 40);
INSERT INTO nodes VALUES (1, null);
INSERT INTO nodes VALUES (20, null);
INSERT INTO nodes VALUES (32, null);
INSERT INTO nodes VALUES (40, null);
INSERT INTO nodes VALUES (75, 60);
INSERT INTO nodes VALUES (75, 90);
INSERT INTO nodes VALUES (60, 55);
INSERT INTO nodes VALUES (60, 70);
INSERT INTO nodes VALUES (90, 80);
INSERT INTO nodes VALUES (90, 95);
INSERT INTO nodes VALUES (55, null);
INSERT INTO nodes VALUES (70, null);
INSERT INTO nodes VALUES (80, null);
INSERT INTO nodes VALUES (95, null);

SELECT * FROM nodes;

CREATE VIEW view_pointer_not_null AS 
	SELECT * FROM nodes
    WHERE pointer IS NOT NULL;

SELECT * FROM view_pointer_not_null;

DELIMITER &&
CREATE PROCEDURE procedure_nodeid_pointer (IN value_node SMALLINT, IN value_pointer SMALLINT)
BEGIN
	SELECT * FROM nodes
    WHERE node_id = value_node AND pointer = value_pointer;
END&&
DELIMITER ;

CALL procedure_nodeid_pointer(50, 30);

DELIMITER %%
CREATE FUNCTION function_count_pointer()
RETURNS SMALLINT DETERMINISTIC
BEGIN
	DECLARE cont SMALLINT;
	SELECT COUNT(pointer) INTO cont -- armazenando dentro de cont
    FROM nodes;
    RETURN cont;
END%%
DELIMITER ;

SELECT function_count_pointer();

-- Exemplo 1 -- (consulta -- ideal -- 0.005s s/ renomear table e 0.002s c/ renomear table)
SELECT DISTINCT n.node_id, -- este id não é uma PRIMARY KEY, pois se repete
	CASE WHEN n.node_id = 50 THEN 'ROOT' WHEN n.pointer IS NULL THEN 'LEAF' ELSE 'INNER' END AS type -- caso quando... então... quando.. então.. se falso... fim...
FROM nodes n
ORDER BY n.node_id;

-- Exemplo 2 (subconsulta -- desnecessário -- 0.005s)
SELECT DISTINCT n.node_id,
	CASE WHEN n.node_id = 50 THEN 'ROOT' WHEN n.pointer IS NULL THEN 'LEAF' ELSE 'INNER' END AS type
FROM (SELECT *
	FROM nodes) n 
ORDER BY n.node_id;

-- Exemplo 3 (junção implícita -- teste, completamente desnecessário -- não roda no Beecrowd [INVALID COLUMN REFERENCE])
/*SELECT DISTINCT n.node_id,
	CASE WHEN n2.node_id = 50 THEN 'ROOT' WHEN n.pointer IS NOT NULL THEN 'LEAF' ELSE 'INNER' END AS type
FROM nodes n, nodes n2
WHERE n.node_id = n2.node_id
ORDER BY n2.node_id;*/

/*-- Exemplo 4 (junção implícita -- teste, completamente desnecessário -- não roda no Beecrowd [INVALID COLUMN REFERENCE]) 
SELECT DISTINCT n2.node_id,
	CASE WHEN n.node_id = 50 THEN 'ROOT' WHEN n2.pointer IS NOT NULL THEN 'LEAF' ELSE 'INNER' END type -- oculto o AS
FROM nodes n
INNER JOIN nodes n2 ON n.node_id = n2.node_id
ORDER BY n.node_id;*/

-- Realizando testes absurdos para ver a performance.

CREATE TEMPORARY TABLE uploads_nodes (
	node_id SMALLINT NOT NULL,
    pointer SMALLINT UNIQUE,
    user VARCHAR(20) NOT NULL,
    date TIMESTAMP NOT NULL
);

DELIMITER %%
CREATE TRIGGER trigger_uploads_new_node AFTER INSERT
ON nodes
FOR EACH ROW
BEGIN
	INSERT INTO uploads_nodes (
		node_id,
        pointer,
        user,
        date
	)
    VALUES (
		NEW.node_id,
        NEW.pointer,
        USER(),
        NOW()
	);
END%%
DELIMITER ;

INSERT INTO nodes VALUES (21, 31), (1, 21), (9, null);

SELECT * FROM uploads_nodes;
SELECT * FROM nodes;

SELECT DISTINCT n.node_id,
	CASE WHEN n.node_id = 50 THEN 'ROOT' WHEN n.pointer IS NULL THEN 'LEAF' ELSE 'INNER' END AS type
FROM nodes n
ORDER BY n.node_id;