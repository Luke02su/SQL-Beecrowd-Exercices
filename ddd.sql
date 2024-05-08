CREATE DATABASE beecrowd2989;
USE beecrowd2989;

CREATE TABLE departamento (
	cod_dep INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(20) NOT NULL,
    endereco VARCHAR(10) NOT NULL
);

CREATE TABLE dependente (
	matr INT NOT NULL,
    nome VARCHAR(35) NOT NULL,
    endereco VARCHAR(10) NOT NULL,
    
    INDEX matr_idx (matr),
    
    CONSTRAINT fk_matr3 FOREIGN KEY dependente(matr) REFERENCES empregado(matr)
);

CREATE TABLE desconto (
	cod_desc INT PRIMARY KEY,
    nome VARCHAR(20),
    tipo CHAR(1),
    valor INT
);

CREATE TABLE divisao (
	cod_divisao INT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    endereco VARCHAR(10) NOT NULL,
    cod_dep INT NOT NULL,
    
    INDEX cod_dep_idx (cod_dep),
    
    CONSTRAINT fk_cod_dep FOREIGN KEY divisao(cod_dep) REFERENCES departamento(cod_dep)
);

CREATE TABLE empregado (
	matr INT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL, 
    endereco VARCHAR(10) NOT NULL,
    data_locacao TIMESTAMP NOT NULL,
    lotacao INT NOT NULL,
    gerencia_cod_dep INT,
    lotacao_div INT NOT NULL,
    gerencia_div INT,
    
    INDEX gerencia_cod_dep_idx (gerencia_cod_dep),
    INDEX lotacao_div_idx (lotacao_div),
    INDEX gerencia_div_idx (gerencia_div),
    
    CONSTRAINT fk_gerencia_cod_dep FOREIGN KEY empregado(gerencia_cod_dep) REFERENCES departamento(cod_dep),
    CONSTRAINT fk_lotacao_div FOREIGN KEY divisao(lotacao_div) REFERENCES divisao(cod_divisao),
    CONSTRAINT fk_gerencia_div FOREIGN KEY divisao(gerencia_div) REFERENCES divisao(cod_divisao)
);

CREATE TABLE emp_desc (
	cod_desc INT NOT NULL,
    matr INT NOT NULL,
    
    INDEX cod_desc_idx (cod_desc),
    INDEX matr_idx (matr),
	
    PRIMARY KEY (cod_desc, matr),
    CONSTRAINT fk_cod_desc FOREIGN KEY emp_desc(cod_desc) REFERENCES desconto(cod_desc),
    CONSTRAINT fk_matr FOREIGN KEY  emp_desc(matr) REFERENCES empregado(matr) 
);

CREATE TABLE vencimento (
	cod_venc INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    tipo CHAR(1) NULL,
    valor INT NOT NULL
);

CREATE TABLE emp_venc (
	cod_venc INT NOT NULL,
    matr INT NOT NULL, 
    
	INDEX cod_venc_idx (cod_venc),
    INDEX matr_idx (matr),
	
    PRIMARY KEY (cod_venc, matr),
    CONSTRAINT fk_cod_venc2 FOREIGN KEY emp_venc(cod_venc) REFERENCES vencimento(cod_venc), -- não se pode ter CONSTRAINT (nomes de FOREIGN KEY) repetidas
    CONSTRAINT fk_matr2 FOREIGN KEY  emp_venc(matr) REFERENCES empregado(matr) -- não se pode ter CONSTRAINT (nomes de FOREIGN KEY) repetidas
);


drop database beecrowd2989;

INSERT INTO departamento VALUES (1, 'Contabilidade', 'R. X'); -- poderia-se usar 'default' no lugar de 1, 2, 3, pois é auto_increment
INSERT INTO departamento VALUES (2, 'TI', 'R. Y');
INSERT INTO departamento VALUES (3, 'Engenharia', 'R. Y');

SELECT * FROM departamento;

INSERT INTO desconto VALUES ('91', 'IR', 'V', 400);
INSERT INTO desconto VALUES ('92', 'Plano de saude', 'V', 300);
INSERT INTO desconto VALUES ('93', null, null, null);

SELECT * FROM desconto;

INSERT INTO divisao VALUES (11, 'Ativo', 'R. X', 1);
INSERT INTO divisao VALUES (12, 'Passivo',	'R. X', 1);
INSERT INTO divisao VALUES (21, 'Desenvoilvimento de Projetos', 'R. Y', 2);
INSERT INTO divisao VALUES (22, 'Analise de Sistemas', 'R. Y', 2);
INSERT INTO divisao VALUES (23, 'Programacao', 'R. W', 2);
INSERT INTO divisao VALUES (31, 'Concreto', 'R. Y', 3);
INSERT INTO divisao VALUES (32, 'Calculo Estrutural', 'R. Y', 3);

SELECT * FROM divisao;

INSERT INTO emp_desc VALUES (91, 3);
INSERT INTO emp_desc VALUES (91, 27);
INSERT INTO emp_desc VALUES (91, 9999);
INSERT INTO emp_desc VALUES (92, 27);
INSERT INTO emp_desc VALUES (92, 71);
INSERT INTO emp_desc VALUES (92, 88);
INSERT INTO emp_desc VALUES (92, 9999);

SELECT * FROM emp_desc;

INSERT INTO empregado VALUES (9999, 'Jose Sampaio', 'R. Z', '2006-06-06T00:00:00Z', 1, 1, 12, null);
INSERT INTO empregado VALUES (33, 'Jose Maria', 'R. 21', '2006-03-01T00:00:00Z', 1, null, 11, 11);
INSERT INTO empregado VALUES (1, 'Maria Jose', 'R. 52',	'2003-03-01T00:00:00Z', 1, null, 11, null);
INSERT INTO empregado VALUES (7, 'Yasmim', 'R. 13', '0210-07-02T00:00:00Z', 1, null, 11, null);
INSERT INTO empregado VALUES (5, 'Rebeca', 'R. 1', '2011-04-01T00:00:00Z', 1, null, 12, 12);
INSERT INTO empregado VALUES (13, 'Sofia', 'R. 28', '2010-09-09T00:00:00Z', 1, null, 12, null);
INSERT INTO empregado VALUES (27, 'Andre', 'R. Z', '2005-05-01T00:00:00Z', 2, 2, 22, null);
INSERT INTO empregado VALUES (88, 'Yami', 'R. T', '2014-02-01T00:00:00Z', 2, null, 21, 21);
INSERT INTO empregado VALUES (431, 'Joao da Silva', 'R. Y', '2011-07-03T00:00:00Z', 2, null, 21, null);
INSERT INTO empregado VALUES (135, 'Ricardo Reis', 'R. 33', '2009-08-01T00:00:00Z', 2, null, 21, null);
INSERT INTO empregado VALUES (254, 'Barbara', 'R. Z', '2008-01-03T00:00:00Z', 2, null, 22, 22);
INSERT INTO empregado VALUES (25, 'Lina', 'R. 67', '2014-09-01T00:00:00Z', 2, null, 23, null);
INSERT INTO empregado VALUES (3, 'Jose da Silva', 'R. 8', '2011-01-02T00:00:00Z', 3, 3, 31, null);
INSERT INTO empregado VALUES (71, 'Silverio dos Reis', 'R. C', '2009-01-05T00:00:00Z', 3, null, 31, 31);
INSERT INTO empregado VALUES (91, 'Reis da Silva', 'R. Z', 't2011-11-05T00:00:00Z', 3, null, 31, null);
INSERT INTO empregado VALUES (55, 'Lucas', 'R. 31', '2013-07-01T00:00:00Z', 3, null, 32, 32);
INSERT INTO empregado VALUES (222, 'Marina', 'R. 31', '2015-01-07T00:00:00Z', 3, null, 32, null);
INSERT INTO empregado VALUES (725, 'Angelo', 'R. X', '2001-03-01T00:00:00Z', 2, null, 21, null);

SELECT * FROM empregado;