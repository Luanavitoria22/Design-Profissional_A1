
CREATE SCHEMA forestfiredetection;

CREATE TYPE status_sensor_enum AS ENUM ('ativo', 'inativo', 'manutencao');
CREATE TYPE risco_enum AS ENUM ('baixo', 'moderado', 'alto', 'critico');
CREATE TYPE nivel_incendio_enum AS ENUM ('baixo', 'medio', 'alto');
CREATE TYPE status_incendio_enum AS ENUM ('em_monitoramento', 'em_combate', 'controlado', 'extinto');

CREATE TABLE forestfiredetection.sensor (
    id_sensor SERIAL PRIMARY KEY,
    latitude NUMERIC(10,6),
    longitude NUMERIC(10,6),
    tipo_sensor VARCHAR(20),
    status status_sensor_enum
);
INSERT INTO forestfiredetection.sensor (latitude, longitude, tipo_sensor, status)
VALUES
(-15.793889, -47.882778, 'temperatura', 'ativo'),
(-15.794000, -47.883000, 'fumaca', 'ativo'),
(-15.795100, -47.884200, 'umidade', 'ativo'),
(-15.796500, -47.885300, 'temperatura', 'manutencao'),
(-15.797800, -47.886400, 'fumaca', 'inativo');

CREATE TABLE forestfiredetection.leitura_sensor (
    id_leitura SERIAL PRIMARY KEY,
    id_sensor INT NOT NULL REFERENCES forestfiredetection.sensor(id_sensor),
    temperatura NUMERIC(5,2),
    fumaca_detectada BOOLEAN,
    umidade NUMERIC(5,2),
    data_hora TIMESTAMP DEFAULT NOW()
);
INSERT INTO forestfiredetection.leitura_sensor (id_sensor, temperatura, fumaca_detectada, umidade)
VALUES
(1, 36.5, TRUE, 18.0),
(2, 29.8, FALSE, 42.5);

CREATE TABLE forestfiredetection.alerta (
    id_alerta SERIAL PRIMARY KEY,
    id_leitura INT NOT NULL REFERENCES forestfiredetection.leitura_sensor(id_leitura),
    confirmado BOOLEAN,
    risco risco_enum,
    data_hora TIMESTAMP DEFAULT NOW()
);
INSERT INTO forestfiredetection.alerta (id_leitura, confirmado, risco)
VALUES
(1, TRUE, 'alto'),
(2, FALSE, 'baixo');

CREATE TABLE forestfiredetection.incendio (
    id_incendio SERIAL PRIMARY KEY,
    id_alerta INT NOT NULL REFERENCES forestfiredetection.alerta(id_alerta),
    area_afetada NUMERIC(10,2),
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,
    nivel nivel_incendio_enum,
    status status_incendio_enum
);
INSERT INTO forestfiredetection.incendio (id_alerta, area_afetada, data_inicio, data_fim, nivel, status)
VALUES
(1, 10.5, NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day', 'medio', 'controlado');

CREATE TABLE forestfiredetection.brigadista (
    id_brigadista SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    especialidade VARCHAR(50)
);
INSERT INTO forestfiredetection.brigadista (nome, especialidade)
VALUES
('Brenon Rodrigo', 'combate direto'),
('Uriel Oliveira', 'monitoramento térmico'),
('Pola Victoria', 'logística de emergência'),
('Luana Vitoria', 'primeiros socorros'),
('George Santos', 'comunicação e coordenação');

CREATE TABLE forestfiredetection.telefone_brigadista (
    id_brigadista INT REFERENCES forestfiredetection.brigadista(id_brigadista),
    telefone VARCHAR(20),
    PRIMARY KEY (id_brigadista, telefone)
);
INSERT INTO forestfiredetection.telefone_brigadista (id_brigadista, telefone)
VALUES (3, '(61) 97777-3333');

UPDATE forestfiredetection.telefone_brigadista
SET telefone = '(61) 93333-4444'
WHERE id_brigadista = 2 AND telefone = '(61) 98888-2222';

DELETE FROM forestfiredetection.telefone_brigadista
WHERE id_brigadista = 1 AND telefone = '(61) 99999-1111';