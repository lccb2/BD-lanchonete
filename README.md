# BD-lanchonete
Projeto da disciplina de Banco de Dados do curso de Sistemas da Informação da UFPE

# Integração com Banco de Dados - Projeto Lanchonete

Este projeto demonstra a integração do banco de dados PostgreSQL (via Docker) com a linguagem Python.

##  Banco de Dados (PostgreSQL)

- Banco: `projeto`
- Usuário: `lccb2`
- Senha: `senha123`
- Porta: `5432`

O script `PROJETOBD.sql` contém a criação das tabelas e inserção de dados.

##  Script Python

O script `integracao.py` realiza:
- Inserções no banco
- Remoções de dados
- Consultas (com pandas)

Para executar:

```bash
pip install psycopg2 pandas
python integracao.py
