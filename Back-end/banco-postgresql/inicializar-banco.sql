DROP SCHEMA public CASCADE; 
CREATE SCHEMA public;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    avatar VARCHAR(255),
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    senha VARCHAR(64)
);

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    idUsuario INTEGER REFERENCES users(id),
    rating DECIMAL(2, 1),
    comentario TEXT,
    data DATE DEFAULT CURRENT_DATE
);

DROP TABLE IF EXISTS companies;
CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    razao_social VARCHAR(255) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL
);

DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries (
    id SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(255) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_entrega TIMESTAMP,
    status VARCHAR(50) DEFAULT 'PENDENTE',
    valor DECIMAL(10, 2) NOT NULL,
    id_usuario INTEGER,
    id_estabelecimento INTEGER,
    FOREIGN KEY (id_usuario) REFERENCES users(id),
    FOREIGN KEY (id_estabelecimento) REFERENCES companies(id)
);







--- inserts ------
INSERT INTO users (avatar, nome, email, senha)
VALUES
    ('assets/images/mulher.png', 'Alice Silva', 'alice@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/homem.png', 'Carlos Oliveira', 'carlos@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/mulher.png', 'Cristina Santos', 'cristina@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/homem.png', 'Daniel Almeida', 'daniel@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/mulher.png', 'Eduarda Rocha', 'eduarda@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/homem.png', 'Fábio Lima', 'fabio@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/mulher.png', 'Gabriela Pereira', 'gabriela@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/homem.png', 'Hugo Santos', 'hugo@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/mulher.png', 'Isabela Oliveira', 'isabela@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/homem.png', 'João Costa', 'joao@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/mulher.png', 'Juliano Rocha', 'juliano@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/homem.png', 'Larissa Lima', 'larissa@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/mulher.png', 'Marcelo Silva', 'marcelo@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/homem.png', 'Natália Almeida', 'natalia@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/mulher.png', 'Otávio Santos', 'otavio@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/homem.png', 'Paula Lima', 'paula@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/mulher.png', 'Rafaela Oliveira', 'rafaela@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/homem.png', 'Samuel Santos', 'samuel@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92'),
    ('assets/images/mulher.png', 'Tatiane Rocha', 'tatiane@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF'),
    ('assets/images/homem.png', 'Antonio Rocha', 'antonio@email.com', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF');

INSERT INTO reviews (idUsuario, rating, comentario)
VALUES
    (1, 4.5, 'Excelente serviço! Recomendo a todos.'),
    (2, 3.8, 'Bom atendimento, mas pode melhorar.'),
    (3, 5.0, 'Maravilhoso! Não tenho do que reclamar.'),
    (4, 4.2, 'Serviço rápido e eficiente.'),
    (5, 4.7, 'Gostei muito! Entrega no prazo.'),
    (6, 3.5, 'Poderia ser melhor.'),
    (7, 4.9, 'Atendimento de qualidade.'),
    (8, 4.0, 'Recomendo, mas há espaço para melhorias.'),
    (9, 4.6, 'Satisfeita com o serviço prestado.'),
    (10, 3.0, 'Decepcionado com a entrega.'),
    (11, 4.8, 'Ótimo serviço! Entrega rápida.'),
    (12, 3.9, 'Aceitável, mas esperava mais.'),
    (13, 4.4, 'Serviço eficiente e de qualidade.'),
    (14, 3.2, 'Alguns problemas na entrega.'),
    (15, 4.3, 'Recomendo a todos!'),
    (16, 3.7, 'Bom, mas pode melhorar.'),
    (17, 4.1, 'Entrega no prazo e atendimento excelente.'),
    (18, 3.3, 'Não atendeu totalmente às expectativas.'),
    (19, 4.5, 'Serviço de qualidade.'),
    (20, 3.6, 'Regular, mas esperava mais.');

INSERT INTO companies (razao_social, endereco, latitude, longitude)
VALUES
    ('Empresa A LTDA', 'Rua A, 123. Centro', -14.25635, -40.54445),
    ('Empresa B LTDA', 'Rua B, 456. Centro', -14.25645, -40.54435),
    ('Empresa C LTDA', 'Rua C, 789. Centro', -14.25655, -40.54425);

INSERT INTO deliveries (nome_cliente, endereco, latitude, longitude,
    valor, id_usuario, id_estabelecimento)
VALUES
    ('Ana Júlia', 'Rua das Facas, 99. Recreio', -14.25535, -40.54745, 
       10.50, NULL, 1),
    ('Ricardo Silva', 'Rua Primeira, 50. Felicia', -14.25335, -40.54785, 
       10.50, NULL, 2),
    ('Dora Almeida', 'Rua do Bosque, 69. Atlantica', -14.25525, -40.54795, 
       10.50, NULL, 3);