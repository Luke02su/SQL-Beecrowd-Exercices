CREATE DATABASE beecrowd2990;
USE beecrowd2990;

CREATE TABLE empregados (
	cpf VARCHAR(15) NOT NULL PRIMARY KEY,
    enome VARCHAR(60),
    salario FLOAT NOT NULL,
    cpf_supervisor VARCHAR(15),
    dnumero INT NOT NULL,
    
    INDEX cpf_supervisor_idx (cpf_supervisor),
    
    CONSTRAINT auto_fk_cpf_supervisor FOREIGN KEY (cpf_supervisor) REFERENCES empregados(cpf)
);

INSERT INTO empregados VALUES (2434332222, 'Aline Barros', 2350, null, 1010);
INSERT INTO empregados VALUES (049382234322, 'João Silva', 2350, 2434332222, 1010);
INSERT INTO empregados VALUES (586733922290, 'Mario Silveira', 3500, 2434332222, 1010);
INSERT INTO empregados VALUES (1733332162, 'Tulio Vidal', 8350, null, 1020);
INSERT INTO empregados VALUES (4244435272, 'Juliana Rodrigues', 3310, null, 1020);
INSERT INTO empregados VALUES (1014332672, 'Natalia Marques', 2900, null, 1010);

SELECT * FROM empregados;

CREATE TABLE departamentos (
	dnumero INT NOT NULL PRIMARY KEY,
	dnome VARCHAR(60),
    cpf_gerente VARCHAR(15),
    
    INDEX cpf_gerente_idx (cpf_gerente),

	CONSTRAINT fk_cpf_gerente FOREIGN KEY (cpf_gerente) REFERENCES empregados(cpf)
);

INSERT INTO departamentos VALUES (1010, 'Pesquisa', 049382234322);
INSERT INTO departamentos VALUES (1020, 'Ensino', 2434332222);

SELECT * FROM departamentos;

CREATE TABLE trabalha (
	cpf_emp VARCHAR(15) NOT NULL,
    pnumero INT NOT NULL,
    
    INDEX cpf_emp_idx (cpf_emp),
    
    CONSTRAINT fk_cpf_emp FOREIGN KEY (cpf_emp) REFERENCES empregados(cpf)
);

INSERT INTO trabalha VALUES (49382234322, 2010);
INSERT INTO trabalha VALUES (586733922290, 2020);
INSERT INTO trabalha VALUES (49382234322, 2020);

SELECT * FROM trabalha;

CREATE TABLE projetos (
	pnumero INT NOT NULL PRIMARY KEY,
    pnome VARCHAR(45),
    dnumero INT NOT NULL,
    
    INDEX dnumero_idx (dnumero),
	
    CONSTRAINT fk_dnumero FOREIGN KEY (dnumero) REFERENCES departamentos(dnumero)
);

INSERT INTO projetos VALUES (2010, 'Alpha', 1010);
INSERT INTO projetos VALUES (2020, 'Beta', 1020);

SELECT * FROM projetos;

-- Estranhei no princípio não haver algumas FOREIGN KEYS essenciais na descrição da solução de problemas. Depois vi, ao baixar o SQL, que o autor esqueceu de inserir na descrição, usando o ALTER para adicionar as CONSTRAINTS. (Como todos necessitam de FK, caso fizesse a criação da TABLES já com todas CONSTRAINTS, seria necessário usar SET FOREIGN_KEY_CHECKS = 0, depois religar após a criação para dar o INSERT.) 
ALTER TABLE empregados ADD INDEX dnumero_idx (dnumero);
ALTER TABLE empregados ADD CONSTRAINT fk_dnum FOREIGN KEY (dnumero) REFERENCES departamentos(dnumero); -- fk_dnumero estava dando erro de duplicidade (sem lógica), tive de usar fk_num

ALTER TABLE trabalha ADD INDEX pnumero_idx(pnumero);
ALTER TABLE trabalha ADD CONSTRAINT fk_pnumero FOREIGN KEY (pnumero) REFERENCES projetos(pnumero);

-- Exemplo 1 (junção implícita -- não é o ideal -- runtime error por usar group by, mas não tem outro jeito)
/*SELECT cpf, enome, dnome
FROM empregados, departamentos d
WHERE cpf_supervisor IS NULL
GROUP BY enome -- tive de usar pois a junção implícita com departamentos estava duplicando valores
ORDER BY cpf;*/

-- Exemplo 2 (subconsulta -- desnecessário, gambiarra -- 0.003s)
SELECT cpf, enome, (SELECT dnome FROM departamentos d WHERE e.dnumero = d.dnumero) AS dnome -- tive de usar uma subconsulta aqui pois a debaixo não trás o dnome
FROM empregados e
WHERE EXISTS (
	SELECT 1
    FROM departamentos d
    WHERE e.dnumero = d.dnumero
    AND cpf_supervisor IS NULL
)
ORDER BY cpf;

-- Exemplo 3 (junção implícita c/ subconsulta -- desnecessário, gambiarra -- 0.002s)
SELECT cpf, enome, dnome -- tive de usar uma subconsulta aqui pois a debaixo não trás o dnome
FROM empregados e, departamentos d
WHERE e.dnumero IN (
	SELECT d.dnumero
    WHERE e.dnumero = d.dnumero
    AND cpf_supervisor IS NULL
)
ORDER BY cpf;

SELECT cpf, enome, dnome -- tive de usar uma subconsulta aqui pois a debaixo não trás o dnome
FROM empregados e, departamentos d, trabalha t
WHERE cpf IN (
	SELECT cpf_emp
    FROM trabalha 
    WHERE cpf = cpf_emp
    AND cpf_supervisor IS NULL
)
ORDER BY cpf;

-- Exemplo 4 (junção explícita -- acessa indiretamente os que não trabalham em um projeto pelo cpf_supervisor is null-- 0.003s)
SELECT cpf, enome, dnome
FROM empregados e
INNER JOIN departamentos d ON e.dnumero = d.dnumero
WHERE cpf_supervisor IS NULL
ORDER BY cpf;

-- Exemplo 4.1 (junção explícita -- acessa diretamente os que não trabalham em um projeto trazendo os dados à esquerda (LEFT) da junção -- 0.004s)
SELECT cpf, enome, dnome
FROM empregados e
INNER JOIN departamentos d ON e.dnumero = d.dnumero
LEFT JOIN trabalha t ON cpf = cpf_emp
WHERE cpf_emp IS NULL
ORDER BY cpf;

-- Exemplo 4 (junção explícita c/ subconsulta -- desnecessário -- 0.004s)
SELECT cpf, enome, dnome
FROM empregados e
INNER JOIN departamentos d ON e.dnumero = d.dnumero
WHERE NOT EXISTS ( -- onde nçao existir
	SELECT 1
    FROM trabalha
    WHERE cpf_emp = cpf
)
ORDER BY cpf;

-- Testes.
