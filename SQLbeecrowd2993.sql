CREATE DATABASE beecrowd2993;
USE beecrowd2993;

CREATE TABLE value_table (
	amount SMALLINT NOT NULL
);

INSERT INTO value_table VALUES (4);
INSERT INTO value_table VALUES (6);
INSERT INTO value_table VALUES (7);
INSERT INTO value_table VALUES (1);
INSERT INTO value_table VALUES (1);
INSERT INTO value_table VALUES (2);
INSERT INTO value_table VALUES (3);
INSERT INTO value_table VALUES (1);
INSERT INTO value_table VALUES (5);
INSERT INTO value_table VALUES (6);
INSERT INTO value_table VALUES (1);
INSERT INTO value_table VALUES (7);
INSERT INTO value_table VALUES (8);
INSERT INTO value_table VALUES (9);
INSERT INTO value_table VALUES (10);
INSERT INTO value_table VALUES (11);
INSERT INTO value_table VALUES (12);
INSERT INTO value_table VALUES (4);
INSERT INTO value_table VALUES (5);
INSERT INTO value_table VALUES (5);
INSERT INTO value_table VALUES (3);
INSERT INTO value_table VALUES (6);
INSERT INTO value_table VALUES (2);
INSERT INTO value_table VALUES (2);
INSERT INTO value_table VALUES (1);

SELECT * FROM value_table;

-- Exemplo 1 (consulta não calcula diretamente a moda -- não é ideal em uma tabela on grandede não se sabe qual é a moda -- não era para funcionar no beecrowd, mas funcionou -- 0.003s)
SELECT MIN(amount) AS most_frequent_value
FROM value_table;

-- Exemplo 2 (consulta não calcula diretamente a moda -- não é ideal em uma tabela on grandede não se sabe qual é a moda --  não era para funcionar no beecrowd, mas funcionou -- 0.002s)
SELECT DISTINCT amount AS most_frequent_value
FROM value_table
WHERE amount = 1;

-- Exemplo 3 (consulta calcula diretamente a moda, mas usa o LIMIT para limitar, sendo mais adequado que os anteriores, os quais já dão o resultado por si mesmo -- 0.004s)
SELECT amount AS most_frequent_value
FROM value_table
GROUP BY amount -- agrupando os amount
ORDER BY COUNT(*) DESC -- ordenando em ordem decrescente pela quantidade de cada amount agrupado
LIMIT 1; -- limitando uma linha, a qual sempre, por estar em ordem decrescendo, pegará o num com maior frequência
    
-- Exemplo 4 (consulta c/ subconsulta -- muito complexo, desnecessário -- 0.007s)
SELECT amount AS most_frequent_value
FROM value_table
GROUP BY amount
HAVING COUNT(amount) = ( -- tendo que ter o COUNT amount o agrupameto, retorna o MAX da frequência de amount
	SELECT MAX(frequency)
    FROM (
		SELECT COUNT(amount) AS frequency
		FROM value_table
        GROUP BY amount
	) AS frequency
);

-- Desconsiderei fazer junções implícitas e explícitas pois são totalmente desnecessárias.
-- Treinando a criação de VIEW, STORE PROCEDURE, FUNCTION, TRIGGER E EVENT:
-- Procedure pode passar IN, OUT, INTOUT, ou nenhum parâmetro
-- FUNCTION somente IN ou nenhum parâmetro

CREATE VIEW maior_frequencia AS
	SELECT amount most_frequent_value
	FROM value_table
	GROUP BY amount
	ORDER BY COUNT(*) DESC
	LIMIT 1;
    
SELECT * FROM maior_frequencia;

DELIMITER **
CREATE PROCEDURE maior_frequencia ()
BEGIN
	SELECT amount
	FROM value_table
	GROUP BY amount
	ORDER BY COUNT(*) DESC
	LIMIT 1;
END**
DELIMITER ;

CALL maior_frequencia();

DELIMITER %%
CREATE FUNCTION maior_frequencia ()
	RETURNS SMALLINT
    BEGIN
	 DECLARE most_frequent_value SMALLINT;
        SELECT amount INTO most_frequent_value 
		FROM value_table
		GROUP BY amount
		ORDER BY COUNT(*) DESC
		LIMIT 1;
	 RETURN most_frequent_value;
    END%%
DELIMITER ;

SELECT maior_frequencia();

CREATE TABLE log_amount_2 (
	amount SMALLINT NOT NULL,
    date TIMESTAMP NOT NULL
);

DELIMITER %%
CREATE TRIGGER insert_amount_2 AFTER INSERT
ON value_table
FOR EACH ROW
BEGIN
	INSERT INTO log_amount_2 (
    amount,
    date
    ) VALUES (
    NEW.amount,
    NOW()
    );
END%%
DELIMITER ;

DELIMITER %%
CREATE EVENT insert_value_2
	ON SCHEDULE EVERY 1 MINUTE -- será executada a cada segundo
    STARTS NOW() -- começando no momento corrente do servidor sql (CURRENT_TIMESTAMP)
    ENDS NOW() + INTERVAL 1 DAY -- terminando no momento corrento do sql + intervalo de 1 day
    DO -- faça
	 BEGIN -- início do código
		INSERT INTO value_table (amount) VALUES (2); -- inserindo 
	 END%% -- término
DELIMITER ;

SHOW VARIABLES LIKE 'event%'; -- verificando se o agendador de eventos está ligado
SET GLOBAL event_scheduler = ON;
ALTER EVENT insert_value_2 DISABLE;
ALTER EVENT insert_value_2
	ON SCHEDULE EVERY 10 MINUTE -- será executada a cada 10 segundos
    STARTS NOW()
    ENDS NOW() + INTERVAL 1 DAY;
ALTER EVENT insert_value_2 ENABLE;

SHOW EVENTS;
SELECT * FROM value_table; --
SELECT * FROM log_amount_2; -- vendo na tabela de log os inserts na table_value_table