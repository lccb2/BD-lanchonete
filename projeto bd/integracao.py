import psycopg2
import pandas as pd

# Conecta ao banco PostgreSQL no Docker
conn = psycopg2.connect(
    host="localhost",
    port="5432",
    database="projeto",
    user="lccb2",
    password="senha123"
)
cursor = conn.cursor()

print("Conexão realizada com sucesso.\n")

# INSERÇÕES
print("Inserindo um novo produto e cliente...")

# Insere um novo produto
cursor.execute("""
    INSERT INTO Produto (nome, preco, quantidade_estoque, lucro)
    VALUES ('Hambúrguer Vegano', 18.90, 10, 7.00);
""")

# Insere um novo cliente
cursor.execute("""
    INSERT INTO Cliente (endereco, mesa, pagamento)
    VALUES ('Rua Verde, 101', 4, 'PIX');
""")

conn.commit()
print("Inserções realizadas com sucesso.\n")

# REMOÇÕES
print("Removendo um produto e cliente de teste...")

# Remover o produto inserido acima
cursor.execute("""
    DELETE FROM Produto
    WHERE nome = 'Hambúrguer Vegano';
""")

# Remover o cliente inserido acima
cursor.execute("""
    DELETE FROM Cliente
    WHERE endereco = 'Rua Verde, 101';
""")

conn.commit()
print("Remoções realizadas com sucesso.\n")

# CONSULTAS
print("Consultas:")

# Consulta 1: Faturamento por forma de pagamento
query1 = """
SELECT c.pagamento, SUM(pe.preco) AS faturamento
FROM Pedido pe
JOIN Comanda co ON pe.comanda_cliente = co.id
JOIN Cliente c ON co.id_cliente = c.id
GROUP BY c.pagamento;
"""
df1 = pd.read_sql_query(query1, conn)
print("\n Faturamento por forma de pagamento:")
print(df1)

# Consulta 2: Produtos mais vendidos (TOP 3)
query2 = """
SELECT p.nome, SUM(pe.quantidade_produto) AS total
FROM Pedido pe
JOIN Produto p ON p.id = pe.id_produto
GROUP BY p.nome
ORDER BY total DESC
LIMIT 3;
"""
df2 = pd.read_sql_query(query2, conn)
print("\n Produtos mais vendidos:")
print(df2)

conn.close()
print("Consultas realizadas com sucesso. \n")
print("Conexão encerrada.")
