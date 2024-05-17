CREATE DATABASE beecrowd3480;
USE beecrowd3480;

CREATE TABLE chairs (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    queue SMALLINT NOT NULL,
    available BOOLEAN NOT NULL -- FALSE = 0 TRUE = 1 
);

BEGIN;
INSERT INTO chairs VALUES (1, 1, FALSE); -- poderia inserir default por causa do AUTO_INCREMENT, ou ocultar completamente definindo quais colunas tais atributos estão sendo inseridos
INSERT INTO chairs VALUES (2, 1, FALSE);
INSERT INTO chairs VALUES (3, 1, TRUE);
INSERT INTO chairs VALUES (4, 1, FALSE);
INSERT INTO chairs VALUES (5, 1, FALSE);
INSERT INTO chairs VALUES (6, 1, FALSE);
INSERT INTO chairs VALUES (7, 1, TRUE);
INSERT INTO chairs VALUES (8, 1, TRUE);
INSERT INTO chairs VALUES (9, 2, TRUE);
INSERT INTO chairs VALUES (10, 2, FALSE);
INSERT INTO chairs VALUES (11, 2, TRUE);
INSERT INTO chairs VALUES (12, 2, TRUE);
INSERT INTO chairs VALUES (13, 2, FALSE);
INSERT INTO chairs VALUES (14, 2, TRUE);
INSERT INTO chairs VALUES (15, 2, TRUE);
INSERT INTO chairs VALUES (16, 2, FALSE);
INSERT INTO chairs VALUES (17, 3, TRUE);
INSERT INTO chairs VALUES (18, 3, FALSE);
INSERT INTO chairs VALUES (19, 3, TRUE);
INSERT INTO chairs VALUES (20, 3, FALSE);
INSERT INTO chairs VALUES (21, 3, TRUE);
INSERT INTO chairs VALUES (22, 3, TRUE);
INSERT INTO chairs VALUES (23, 3, FALSE);
INSERT INTO chairs VALUES (24, 3, FALSE);
INSERT INTO chairs VALUES (25, 4, TRUE);
INSERT INTO chairs VALUES (26, 4, FALSE);
INSERT INTO chairs VALUES (27, 4, FALSE);
INSERT INTO chairs VALUES (28, 4, TRUE);
INSERT INTO chairs VALUES (29, 4, TRUE);
INSERT INTO chairs VALUES (30, 4, FALSE);
INSERT INTO chairs VALUES (31, 4, FALSE);
INSERT INTO chairs VALUES (32, 4, TRUE);
-- ROLLBACK;
COMMIT;

SELECT * FROM chairs;

CREATE VIEW view_chairs AS SELECT * FROM chairs; -- treinando view
SELECT * FROM view_chairs;

DELIMITER $$ -- Treinanando procedure

CREATE PROCEDURE procedure_chairs (list_queue SMALLINT)
BEGIN -- apenas para uma instrução é desnecessário begin e end
SELECT * FROM chairs
WHERE queue = list_queue;
END$$ -- apenas para uma instrução é desnecessário begin e end

DELIMITER ;

CALL procedure_chairs(1);

SET @queue = 1; -- Treinando: atribuindo valor na variável por meio do @ (ideal para usar quando não será reutilizado, como no caso do procedure)
SELECT * FROM chairs
WHERE queue = @queue; -- comparando

SET @chairs_count = ( -- Treinando (isso pode ser útil em uma store procedure pois pode ser reutilizado sem ter que fazer todo o bloco de código do select
	SELECT COUNT(*) 
    FROM chairs
);

SELECT @chairs_count;

DELIMITER $$
CREATE PROCEDURE chairs_count (count INT) -- não precisa ter o OUT necessariamente
BEGIN
SELECT @chairs_count INTO count; -- chamando variável que armazenu COUNT anteriormente
END$$
DELIMITER ;

CALL chairs_count(@count); -- chamando a variável de saída
SELECT @count; -- imprimindo-a

DELIMITER $$
CREATE PROCEDURE chairs_count2 (OUT count INT)
BEGIN
SELECT COUNT(*) INTO count -- COUNT diretamente neste select
FROM chairs; 
END$$
DELIMITER ;

CALL chairs_count2(@count2);
SELECT @count2;

DELIMITER $$
CREATE PROCEDURE countChairsQueue (IN queueX SMALLINT, OUT countChairs SMALLINT) -- aqui também pode-se ocultar IN e OUT
BEGIN
SELECT COUNT(queue) INTO countChairs
FROM chairs
WHERE available = TRUE AND queueX = queue;
END$$
DELIMITER ;

CALL countChairsQueue(2, @countChairs); -- entrada e saída respectivamente IN e OUT
SELECT @countChairs;

SET @queueX = 2; -- setando (SET) @queue como 2
CALL countChairsQueue(@queueX, @countChairs); -- passando @queue como parâmetro 
SELECT @countChairs;

-- Exemplo 1 (junção implícita -- pode gerar ambiguidade -- 0.004s)
SELECT c.queue, c.id AS "left", cc.id AS "right"
FROM chairs c, chairs cc
WHERE c.id < cc.id
AND (c.available AND cc.available) = TRUE AND cc.id = c.id + 1 AND c.queue = cc.queue
ORDER BY "left";

-- Exemplo 2 (subconsulta -- gambiarra -- 0.002s s/ usar ORDER BY "left" e 0.003s usando-o)
SELECT c.queue, c.id AS "left", c.id + 1 AS "right" -- gambiarra c.id + 1 para o right funcionar, pois não tem acesso a chairs cc
FROM chairs c
WHERE c.available = TRUE
AND EXISTS  (
	SELECT 1 -- não tem necessidade de usar cc.id
    FROM chairs cc
	WHERE cc.available = TRUE AND c.id = cc.id - 1 AND c.queue = cc.queue
)
ORDER BY "left";

-- Exemplo 2.1 (subconsulta -- gambiarra -- 0.003s)
SELECT cc.queue, cc.id - 1 AS "left", cc.id AS "right"
FROM chairs cc
WHERE cc.available = TRUE
AND EXISTS (
	SELECT 1
    FROM chairs c
    WHERE c.available = TRUE AND cc.id = c.id + 1 AND cc.queue = c.queue
)
ORDER BY "left";

-- Exemplo 3 (junção implícita c/ subconsulta -- pode ser usado, mas ainda prefiro o JOIN -- 0.002s)
SELECT c.queue, c.id AS "left", cc.id AS "right"
FROM chairs c,
	(SELECT cc.id, cc.queue
    FROM chairs cc
    WHERE cc.available = TRUE) AS cc -- (poderia ocultar o AS)
WHERE c.available = TRUE AND c.queue = cc.queue AND cc.id = c.id + 1
ORDER BY "left";

-- Exemplo 4 (junção explícita -- ideal, clara e simples, eu acho, embora tenha demorado mais tempo -- 0.005s)
SELECT c.queue, c.id AS "left", cc.id AS "right"
FROM chairs c
INNER JOIN chairs cc ON c.id < cc.id -- duplicando a tabela para realizar comparações -- como a adajcente sempre é a seguinte maior, usa-se <
WHERE c.available = TRUE AND cc.available = TRUE AND cc.id = c.id + 1 AND c.queue = cc.queue -- comparações (cc.id = c.id + 1 para validar que será maior que c.id)
ORDER BY "left";

-- Exemplo 5 (juncão explícita c/ subconsulta -- desnecessário -- 0.003s)
SELECT c.queue, c.id AS "left", cc.id AS "right"
FROM chairs c
INNER JOIN (
	SELECT cc.id, cc.queue
    FROM chairs cc
	WHERE cc.available = TRUE
) AS cc ON c.id < cc.id 
WHERE c.available = TRUE AND cc.id = c.id + 1 AND c.queue = cc.queue
ORDER BY "left";

-- Testes de consultas
