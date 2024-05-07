CREATE DATABASE beecrowd2988;
USE beecrowd2988;

CREATE TABLE teams (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY, -- SMALLINT -> INT menor
    name Varchar(30)
);

CREATE TABLE matches (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    team_1 SMALLINT NOT NULL,
    team_2 SMALLINT NOT NULL,
    team_1_goals SMALLINT NOT NULL,
    team_2_goals SMALLINT NOT NULL,
    
    INDEX team_1_idx (team_1),
    INDEX team_2_idx (team_2),
    
    CONSTRAINT fk_team_1 FOREIGN KEY matches(team_1) REFERENCES teams(id),
    CONSTRAINT fk_team_2 FOREIGN KEY matches(team_2) REFERENCES teams(id)
);

INSERT INTO teams (name) VALUES ('CEARA');
INSERT INTO teams (name) VALUES ('FORTALEZA');
INSERT INTO teams (name) VALUES ('GUARANY DE SOBRAL');
INSERT INTO teams (name) VALUES ('FLORESTA');

SELECT * FROM teams;

INSERT INTO matches (team_1, team_2, team_1_goals, team_2_goals) VALUES (4, 1, 0, 4);
INSERT INTO matches (team_1, team_2, team_1_goals, team_2_goals) VALUES (3, 2, 0, 1);
INSERT INTO matches (team_1, team_2, team_1_goals, team_2_goals) VALUES (1, 3, 3, 0);
INSERT INTO matches (team_1, team_2, team_1_goals, team_2_goals) VALUES (3, 4, 0, 1);
INSERT INTO matches (team_1, team_2, team_1_goals, team_2_goals) VALUES (1, 2, 0, 0);
INSERT INTO matches (team_1, team_2, team_1_goals, team_2_goals) VALUES (2, 4, 2, 1);

SELECT * FROM matches;

-- Exemplo 1 (junção implícita -- funciona, mas o ideal é usar JOIN a fim de evitar possíveis erros -- 0.277s)
SELECT t.name, 
	COUNT(*) AS matches, -- contando tudo (matches)
	(SELECT COUNT(*) -- subconsultas sendo utilizadas
    FROM matches m
    WHERE t.id = m.team_1
    AND m.team_1_goals > m.team_2_goals) + -- fiz cada um separado ao invés de usar OR pois estava dando erro de lógica
    (SELECT COUNT(*)
    FROM matches m
    WHERE t.id = m.team_2
    AND m.team_2_goals > m.team_1_goals) AS victories,
    COUNT(*) - ((SELECT COUNT(*) -- importante usar parênteses para delimitar e evitar erros
				FROM matches m
                WHERE t.id = m.team_1
                AND m.team_1_goals > m.team_2_goals) +
                (SELECT COUNT(*)
                FROM matches m
                WHERE t.id = m.team_2
                AND m.team_2_goals > m.team_1_goals) +
                (SELECT COUNT(*)
                FROM matches m
                WHERE t.id IN (m.team_1, m.team_2)
                AND m.team_1_goals = m.team_2_goals)) AS defeats,
	(SELECT COUNT(*)
    FROM matches m
    WHERE t.id IN (m.team_1, m.team_2)
    AND m.team_1_goals = m.team_2_goals) AS draws,
    (3 * ((SELECT COUNT(*) -- importante usar parênteses para delimitar e evitar erros
		FROM matches m
		WHERE t.id = m.team_1
		AND m.team_1_goals > m.team_2_goals) +
        (SELECT COUNT(*)
        FROM matches m
        WHERE t.id = m.team_2
        AND m.team_2_goals > m.team_1_goals))) +
        (SELECT COUNT(*)
        FROM matches m
        WHERE t.id IN (m.team_1, m.team_2)
        AND m.team_1_goals = m.team_2_goals) AS score
FROM matches m, teams t
WHERE t.id IN (m.team_1, m.team_2) -- WHERE (t.id = m.team_1 OR t.id = m.team_2)-- sempre colocar parênteses quando se usar OR para garantir uma consulta correta, sem os parênteses ocasionava inconsistência nos dados
GROUP BY t.id
ORDER BY score DESC, name;

-- Exemplo 2 (junção explícita c/ subconsulta -- ideal -- 0.254s)
SELECT t.name, 
	COUNT(*) AS matches,
	(SELECT COUNT(*)
    FROM matches m
    WHERE t.id = m.team_1
    AND m.team_1_goals > m.team_2_goals) +
    (SELECT COUNT(*)
    FROM matches m
    WHERE t.id = m.team_2
    AND m.team_2_goals > m.team_1_goals) AS victories,
    COUNT(*) - ((SELECT COUNT(*)
				FROM matches m
                WHERE t.id = m.team_1
                AND m.team_1_goals > m.team_2_goals) +
                (SELECT COUNT(*)
                FROM matches m
                WHERE t.id = m.team_2
                AND m.team_2_goals > m.team_1_goals) +
                (SELECT COUNT(*)
                FROM matches m
                WHERE t.id IN (m.team_1, m.team_2)
                AND m.team_1_goals = m.team_2_goals)) AS defeats,
	(SELECT COUNT(*)
    FROM matches m
    WHERE t.id IN (m.team_1, m.team_2)
    AND m.team_1_goals = m.team_2_goals) AS draws,
    (3 * ((SELECT COUNT(*)
		FROM matches m
		WHERE t.id = m.team_1
		AND m.team_1_goals > m.team_2_goals) +
        (SELECT COUNT(*)
        FROM matches m
        WHERE t.id = m.team_2
        AND m.team_2_goals > m.team_1_goals))) +
        (SELECT COUNT(*)
        FROM matches m
        WHERE t.id IN (m.team_1, m.team_2)
        AND m.team_1_goals = m.team_2_goals) AS score
FROM matches m
INNER JOIN teams t ON t.id IN (m.team_1, m.team_2)
GROUP BY t.id
ORDER BY score DESC, name;

-- Pode haver outras formas de se resolver tal exercício, mas vi apenas essas duas, que, de certa forma, são idênticas.
