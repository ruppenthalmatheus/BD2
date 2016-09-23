CREATE TABLE Grupos (
	idGrupo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE Cidades (
	idCidade INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    estado VARCHAR(30) NOT NULL
);

CREATE TABLE Clientes (
	idCliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idCidade INT NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    data_nasc DATE,
    FOREIGN KEY (idCidade) REFERENCES Cidades (idCidade)
			ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE Produtos (
	idProduto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idGrupo INT NOT NULL,
    descricao VARCHAR(50) NOT NULL,
    valor_unit NUMERIC(18,2) NOT NULL,
    data_cadastro DATE,
    FOREIGN KEY (idGrupo) REFERENCES Grupos (idGrupo)
			ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE Vendas (
	idVenda INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    data_venda DATE NOT NULL,
    total_venda NUMERIC(18,2) NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Clientes (idCliente)
			ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE Vendas_Itens (
	idVenda INT NOT NULL,
    idProduto INT NOT NULL,
    quant DOUBLE NOT NULL,
    valor_unit DOUBLE NOT NULL,
    total_item DOUBLE NOT NULL,
    CONSTRAINT PK_Vendas_Itens PRIMARY KEY (idVenda, idProduto),
    FOREIGN KEY (idVenda) REFERENCES Vendas (idVenda)
			ON UPDATE CASCADE
            ON DELETE RESTRICT,
	FOREIGN KEY (idProduto) REFERENCES Produtos (idProduto)
			ON UPDATE CASCADE
            ON DELETE RESTRICT
);

/*a) Monte um comando para excluir da tabela produtos aqueles que possuem o código maior ou igual a 1000, data de cadastro inferior ao ano de 2005.*/

DELETE FROM Produtos 
WHERE idProduto >= 1000
AND YEAR(data_cadastro) < 2005;

/*b) Escreva o comando que seleciona as colunas NOME, CPF e DATA_NASC, da tabela CLIENTES, para aqueles que possuem a palavra ‘amelia’ no nome.*/

SELECT nome AS 'Nome do Cliente',
	   cpf AS 'CPF',
	   data_nasc AS 'Data de Nascimento'
FROM Clientes
WHERE nome LIKE '%amelia%';

/*c) Excluir os produtos pertencentes ao Grupo “Fermentados” cujo valor_unit é menor que 100,00. */

DELETE Produtos FROM Produtos  
		INNER JOIN Grupos
				ON Produtos.idGrupo=Grupos.idGrupo
WHERE Grupos.nome = 'Fermentados' AND Produtos.valor_unit < 100;

/*d) Selecione o nome e o CPF de todos os clientes que estão aniversariando neste no mês de setembro. */

SELECT nome AS 'Nome do Cliente',
	   cpf AS 'CPF'
FROM Clientes
WHERE MONTH(data_nasc) = 9;

/*e) Selecione o CPF e o nome dos 5 clientes que mais compraram e moram na Cidade de Torres. 
Considera o maior valor monetário de compra. Mostrar somente os que compraram acima de R$ 1000.00*/

SELECT CL.nome AS 'Nome do Cliente',
	   CL.cpf AS 'CPF',
       SUM(V.total_venda) AS 'Total_Gasto'
FROM Clientes CL
		INNER JOIN Cidades C 
				ON CL.idCidade = C.idCidade
		INNER JOIN Vendas V
				ON CL.idCliente = V.idCliente
WHERE C.nome = 'Torres'
GROUP BY CL.nome
HAVING SUM(V.total_venda) > 1000
ORDER BY SUM(V.total_venda) DESC
LIMIT 5;

/*f) Atualize para menos 20% o preço de todos os produtos que ainda não foram vendidos.*/

UPDATE Produtos
	SET valor_unit = valor_unit - valor_unit * 0.20
WHERE idProduto NOT IN (SELECT idProduto FROM Vendas_Itens WHERE idProduto = Produtos.IdProduto);

/*g) Escreva um comando que apresente os 10 produtos que mais foram vendidos na primeira
quinzena do mês de março e abril do ano passado.*/

SELECT P.descricao AS 'Produto',
       SUM(VI.quant) AS 'Total de Vendas'
FROM Produtos P
		INNER JOIN Vendas_Itens VI
				ON P.idProduto = VI.idProduto
		INNER JOIN Vendas V
				ON V.idVenda = VI.idVenda
WHERE (V.data_venda BETWEEN '2015-03-1' AND '2015-03-15') OR
	  (V.data_venda BETWEEN '2015-04-1' AND '2015-04-15')
GROUP BY P.descricao
ORDER BY SUM(VI.quant) DESC
LIMIT 10;

/*h) Escreva o comando para apresentar o preço médio dos produtos por código de grupo.
Considere somente aqueles que custam mais de R$ 29,90.*/

SELECT idGrupo,
	   AVG(P.valor_unit)
FROM Produtos P 
	   INNER JOIN Grupos G 
			ON G.idGrupo = P.idGrupo
WHERE P.valor_unit >= 29.90
GROUP BY idGrupo;

/*i) Monte a consulta SQL que retorna os grupos que possuem produtos comprados pela cliente
“Aleide Maciel”*/

SELECT * FROM GRUPOS
		INNER JOIN Produtos 
				ON Grupos.idGrupo = Produtos.idProduto
		INNER JOIN Vendas_Itens
				ON Produtos.idProduto = Vendas_Itens.idProduto
		INNER JOIN Vendas
				ON Vendas_Itens.idVenda = Vendas.idVenda
		INNER JOIN Clientes
				ON Vendas.idCliente = Clientes.idCliente
WHERE Clientes.nome = 'Aleide Maciel';
        

/*j) Monte a consulta SQL que retorna o código do produto a sua descrição e uma coluna
STATUS. A coluna status deve conter: Para os produtos acima de 500 reais ‘Produto com
valor Elevado”. Para os produtos entre 50 e 200 reais ‘Produtos com preço Bom” e para o
restante, “produtos em destaque”.*/


/*k) Monte uma consulta SQL que apresente os clientes e o preço máximo dos produtos
comprados por ele. Apresente somente as informações para os clientes cujo o preço máximo
for superior a 250,00.*/