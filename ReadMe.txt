/*
- Uma empresa vende produtos alimentícios
- A empresa dá pontos, para seus clientes, que podem ser revertidos em prêmios
- Para não prejudicar a tabela venda, nenhum produto pode ser deletado, mesmo que não venha mais a ser vendido
- Para não prejudicar os relatórios e a contabilidade, a tabela venda não pode ser alterada. 
- Ao invés de alterar a tabela venda deve-se exibir uma tabela com o nome do último cliente que comprou e o valor da 
última compra
- Após a inserção de cada linha na tabela venda, 10% do total deverá ser transformado em pontos.
- Se o cliente ainda não estiver na tabela de pontos, deve ser inserido automaticamente após sua primeira compra
- Se o cliente atingir 1 ponto, deve receber uma mensagem (PRINT SQL Server) dizendo que ganhou
*/
CREATE DATABASE ex_triggers_07
GO
USE ex_triggers_07
GO
CREATE TABLE cliente (
codigo		INT			NOT NULL,
nome		VARCHAR(70)	NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE venda (
codigo_venda	INT				NOT NULL,
codigo_cliente	INT				NOT NULL,
valor_total		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo_venda)
FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo)
)
GO
CREATE TABLE pontos (
codigo_cliente	INT					NOT NULL,
total_pontos	DECIMAL(4,1)		NOT NULL
PRIMARY KEY (codigo_cliente)
FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo)
)