-- Active: 1752939671030@@127.0.0.1@3306
-- CRIAÇÃO DE TABELAS E RELAÇÕES

CREATE TABLE Fornecedor (
   cnpj VARCHAR(18) PRIMARY KEY,
   email VARCHAR(100),
   telefone VARCHAR(15)
);




CREATE TABLE Ingredientes (
   nome VARCHAR(100),
   quantidade_estoque INTEGER NOT NULL,
   vencimento DATE NOT NULL,
   f_cnpj VARCHAR(18) NOT NULL,
   PRIMARY KEY (nome),
   FOREIGN KEY (f_cnpj) REFERENCES Fornecedor(cnpj)
);




CREATE TABLE Produto (
   id SERIAL PRIMARY KEY,
   nome VARCHAR(100) NOT NULL,
   preco NUMERIC(8,2) NOT NULL,
   quantidade_estoque INTEGER,
   lucro NUMERIC(8,2)
);


ALTER TABLE Produto
ALTER COLUMN quantidade_estoque SET NOT NULL;


ALTER TABLE Produto
ADD CONSTRAINT chk_qtd_estoque CHECK (quantidade_estoque >= 0);


ALTER TABLE Produto
ADD CONSTRAINT chk_preco_pos CHECK (preco > 0);




CREATE TABLE Comida (
   id INTEGER PRIMARY KEY,
   categoria VARCHAR(50),
   FOREIGN KEY (id) REFERENCES Produto(id)
);




CREATE TABLE Bebida (
   id INTEGER PRIMARY KEY,
   f_cnpj VARCHAR(18),
   FOREIGN KEY (id) REFERENCES Produto(id),
   FOREIGN KEY (f_cnpj) REFERENCES Fornecedor(cnpj)
);




CREATE TABLE Usa (
   id_comida INTEGER,
   nome_ingrediente VARCHAR(100),
   PRIMARY KEY (id_comida, nome_ingrediente),
   FOREIGN KEY (id_comida) REFERENCES Comida(id),
   FOREIGN KEY (nome_ingrediente) REFERENCES Ingredientes(nome)
);




CREATE TABLE Funcionario (
   id SERIAL PRIMARY KEY,
   nome VARCHAR(100) NOT NULL
);




CREATE TABLE Cliente (
   id SERIAL PRIMARY KEY,
   endereco VARCHAR(150),
   mesa INTEGER,
   pagamento VARCHAR(50)
);


ALTER TABLE Cliente
ADD CONSTRAINT chk_pagamento CHECK (pagamento IN ('Dinheiro', 'Cartão', 'PIX'));




CREATE TABLE Comanda (
   id SERIAL PRIMARY KEY,
   id_cliente INTEGER NOT NULL,
   FOREIGN KEY (id_cliente) REFERENCES Cliente(id)
);




CREATE TABLE Pedido (
   id SERIAL PRIMARY KEY,
   nome_atendente VARCHAR(100),
   mesa INTEGER,
   preco NUMERIC(8,2),
   id_produto INTEGER NOT NULL,
   quantidade_produto INTEGER NOT NULL,
   comanda_cliente INTEGER NOT NULL,
   FOREIGN KEY (id_produto) REFERENCES Produto(id),
   FOREIGN KEY (comanda_cliente) REFERENCES Comanda(id)
);




CREATE TABLE Atendente (
   id INTEGER PRIMARY KEY,
   comanda_cliente INTEGER,
   FOREIGN KEY (id) REFERENCES Funcionario(id),
   FOREIGN KEY (comanda_cliente) REFERENCES Comanda(id)
);




CREATE TABLE Entregador (
   id INTEGER PRIMARY KEY,
   comanda_cliente INTEGER,
   FOREIGN KEY (id) REFERENCES Funcionario(id),
   FOREIGN KEY (comanda_cliente) REFERENCES Comanda(id)
);




CREATE TABLE Gerente (
   id INTEGER PRIMARY KEY,
   comanda_cliente INTEGER,
   acesso_estoque BOOLEAN DEFAULT TRUE,
   FOREIGN KEY (id) REFERENCES Funcionario(id),
   FOREIGN KEY (comanda_cliente) REFERENCES Comanda(id)
);






-- INSERÇÃO DE DADOS


-- Fornecedores
INSERT INTO Fornecedor VALUES
('12.345.678/0001-90', 'contato@bomgosto.com', '(81) 98765-4321'),
('98.765.432/0001-10', 'bebidas@prime.com', '(81) 99887-1122');


-- Ingredientes
INSERT INTO Ingredientes VALUES
('Queijo Mussarela', 30, '2025-09-10', '12.345.678/0001-90'),
('Presunto', 20, '2025-08-15', '12.345.678/0001-90'),
('Pão de Hambúrguer', 40, '2025-08-01', '12.345.678/0001-90'),
('Alface', 25, '2025-07-28', '12.345.678/0001-90'),
('Tomate', 30, '2025-07-28', '12.345.678/0001-90'),
('Refrigerante Cola', 50, '2026-01-01', '98.765.432/0001-10'),
('Suco de Laranja', 35, '2025-12-01', '98.765.432/0001-10');


-- Produtos
INSERT INTO Produto (nome, preco, quantidade_estoque, lucro) VALUES
('X-Burguer', 15.90, 20, 5.90),
('X-Salada', 17.90, 15, 6.90),
('Refrigerante 350ml', 6.00, 50, 2.50),
('Suco de Laranja 300ml', 7.00, 35, 3.00),
('Água Mineral 500ml', 4.00, 60, 1.50);


-- Comidas
INSERT INTO Comida (id, categoria) VALUES
(1, 'Lanche'),
(2, 'Lanche');


-- Bebidas
INSERT INTO Bebida VALUES
(3, '98.765.432/0001-10'),
(4, '98.765.432/0001-10'),
(5, '98.765.432/0001-10');


-- Usa (Ingredientes nas Comidas)
INSERT INTO Usa VALUES
(1, 'Pão de Hambúrguer'),
(1, 'Queijo Mussarela'),
(1, 'Presunto'),
(2, 'Pão de Hambúrguer'),
(2, 'Queijo Mussarela'),
(2, 'Presunto'),
(2, 'Alface'),
(2, 'Tomate');


-- Funcionários
INSERT INTO Funcionario (nome) VALUES
('Ana Paula'),
('João Silva'),
('Carlos Souza');


-- Clientes
INSERT INTO Cliente (endereco, mesa, pagamento) VALUES
('Rua das Flores, 100', 5, 'Cartão'),
('Av. Brasil, 200', 7, 'PIX'),
('Rua Nova, 300', 3, 'Dinheiro');


-- Comandas
INSERT INTO Comanda (id_cliente) VALUES (1), (2), (3);


-- Relacionamentos de função
INSERT INTO Atendente VALUES (1, 1);
INSERT INTO Entregador VALUES (2, 1);
INSERT INTO Gerente VALUES (3, 1, TRUE);


-- Pedidos
INSERT INTO Pedido (nome_atendente, mesa, preco, id_produto, quantidade_produto, comanda_cliente) VALUES
('Ana Paula', 5, 15.90, 1, 1, 1),
('Ana Paula', 5, 6.00, 3, 1, 1),
('Ana Paula', 7, 17.90, 2, 1, 2),
('Ana Paula', 7, 7.00, 4, 1, 2),
('Ana Paula', 3, 4.00, 5, 1, 3);


-- ===============================
-- CONSULTAS ÚTEIS PARA ESTOQUE E PEDIDOS
-- ===============================


-- 1. Ingredientes com vencimento próximo (7 dias)
SELECT nome, quantidade_estoque, vencimento
FROM Ingredientes
WHERE vencimento <= CURRENT_DATE + INTERVAL '7 days';


-- 2. Produtos com estoque baixo
SELECT nome, quantidade_estoque
FROM Produto
WHERE quantidade_estoque < 10;


-- 3. Total vendido por produto
SELECT p.nome, SUM(pe.quantidade_produto) AS total_vendido
FROM Pedido pe
JOIN Produto p ON pe.id_produto = p.id
GROUP BY p.nome;


-- 4. Faturamento por forma de pagamento
SELECT c.pagamento, SUM(pe.preco) AS faturamento
FROM Pedido pe
JOIN Comanda co ON pe.comanda_cliente = co.id
JOIN Cliente c ON co.id_cliente = c.id
GROUP BY c.pagamento;


-- 5. Produtos mais vendidos (TOP 3)
SELECT p.nome, SUM(pe.quantidade_produto) AS total
FROM Pedido pe
JOIN Produto p ON p.id = pe.id_produto
GROUP BY p.nome
ORDER BY total DESC
LIMIT 3;


-- 6. Ingredientes usados por comida
SELECT pr.nome AS comida, i.nome AS ingrediente
FROM Comida c
JOIN Produto pr ON pr.id = c.id
JOIN Usa u ON c.id = u.id_comida
JOIN Ingredientes i ON u.nome_ingrediente = i.nome
ORDER BY pr.nome;


-- 7. Total de comandas abertas por mesa
SELECT mesa, COUNT(*) AS total_comandas
FROM Pedido
GROUP BY mesa;


-- 8. Faturamento total do dia
SELECT SUM(preco) AS total_dia
FROM Pedido
WHERE CURRENT_DATE = CURRENT_DATE;


-- 9. Ver os funcionários e suas funções
SELECT f.id, f.nome,
   CASE
       WHEN a.id IS NOT NULL THEN 'Atendente'
       WHEN e.id IS NOT NULL THEN 'Entregador'
       WHEN g.id IS NOT NULL THEN 'Gerente'
       ELSE 'Indefinido'
   END AS funcao
FROM Funcionario f
LEFT JOIN Atendente a ON f.id = a.id
LEFT JOIN Entregador e ON f.id = e.id
LEFT JOIN Gerente g ON f.id = g.id;


