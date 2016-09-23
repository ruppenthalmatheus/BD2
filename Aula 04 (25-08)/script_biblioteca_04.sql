CREATE TABLE Editoras (
	IdEditora INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(40) NOT NULL
);

CREATE TABLE Assuntos (
	IdAssunto CHAR(1) NOT NULL PRIMARY KEY,
    Descricao VARCHAR(40) NOT NULL
);

CREATE TABLE Autores (
	Matricula INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(40) NOT NULL,
    CPF VARCHAR(11) NOT NULL,
    Endereco VARCHAR(50),
    Data_Nascimento DATE,
    Nacionalidade VARCHAR(30)
);

CREATE TABLE Livros (
	IdLivro INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    IdAssunto CHAR(1) NOT NULL,
    IdEditora INT NOT NULL,
    Titulo VARCHAR(80) NOT NULL,
    Preco DOUBLE NOT NULL,
    Lancamento DATE,
    FOREIGN KEY (IdAssunto) REFERENCES Assuntos (IdAssunto)
		ON DELETE RESTRICT
        ON UPDATE CASCADE,
	FOREIGN KEY (IdEditora) REFERENCES Editoras (IdEditora)
		ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE Autores_Livros (
	Matricula INT NOT NULL,
    IdLivro INT NOT NULL,
    PRIMARY KEY (Matricula, IdLivro),
    FOREIGN KEY (Matricula) REFERENCES Autores (Matricula)
		ON DELETE RESTRICT
        ON UPDATE CASCADE,
	FOREIGN KEY (IdLivro) REFERENCES Livros (IdLivro)
		ON DELETE RESTRICT
        ON UPDATE CASCADE
);

INSERT INTO Editoras (Nome) VALUES
	("Mirandela Editora"),
    ("Editora Via-Norte"),
    ("Editora Ilhas Tijucas"),
    ("Maria José Editora");
    
INSERT INTO Assuntos (IdAssunto, Descricao) VALUES
	("B", "Banco de Dados"),
    ("P", "Programação"),
    ("R", "Redes"),
    ("S", "Sistemas Operacionais");
    
INSERT INTO Livros (Titulo, Preco, Lancamento, IdAssunto, IdEditora) VALUES
	("Bancos de Dados para a Web", "31.20", "1999-01-10", "B", "1"),
    ("Programando em Linguagem C", "30.00", "1997-10-01", "P", "1"),
    ("Programando em Linguagem C++", "111.50", "1998-11-01", "P", "3"),
    ("Bancos de Dados na Bioinformática", "48.00", NULL,"B", "2"),
    ("Redes de Computadores", "42.00", "1996-09-01", "R", "2");
    
INSERT INTO Autores (Nome, CPF, Endereco, Data_Nascimento, Nacionalidade) VALUES
	("Keith W. Ross", "12345678910", NULL, NULL, "Estados Unidos"),
    ("Antonio H. Reis", "01987654321", "Rua Dezessete, 456. Rio de Janeiro - RJ", "1990-03-15", "Brasil"),
    ("João A. Carvalho", "78965432112", "Rua Carlos Alves, 147. Curitiba - PR", "1978-05-23", "Brasil");
    
INSERT INTO Autores_Livros (Matricula, IdLivro) VALUES
	("1", "5"),
    ("1", "4"),
    ("2", "2"),
    ("2", "1"),
    ("3","3");

/*1.	Estão sendo estudados aumentos nos preços dos livros. Escreva o comando SQL que retorna uma listagem contendo o titulo dos livros, 
e mais três colunas: uma contendo os preços dos livros acrescidos de 10% (deve ser chamada de ‘Opção_1’), 
a segunda contendo os preços acrescidos de 15% (deve ser chamada de ‘Opção_2’) e a terceira contendo os preços dos livros acrescidos de 20% (deve ser chamada de ‘Opção_3’). 
Somente devem ser considerados livros que já tenham sido lançados.*/

SELECT Titulo AS 'Título do Livro', 
	   Preco * 1.10 AS 'Opção_1', 
	   Preco * 1.15 AS 'Opção_2', 
       Preco * 1.20 AS 'Opção_3' 
FROM Livros
WHERE Lancamento IS NOT NULL AND Lancamento < NOW();

/*2.	Escreva o comando SQL que apresenta uma listagem contendo o código da editora, a sigla do assunto e o titulo dos livros que já foram lançados. 
Os dados devem estar em ordem decrescente de preço, e ascendente de código da editora e de titulo do livro.*/

SELECT E.IdEditora AS 'Código da Editora',
	   A.IdAssunto AS 'Sigla do Assunto',
	   L.Titulo AS 'Livro'
FROM Livros L
WHERE Lancamento IS NOT NULL AND Lancamento < NOW()
ORDER BY L.Preco DESC, E.IdEditora ASC, L.Titulo ASC;


/*3.	Escreva o comando que apresente uma listagem dos nomes dos autores e do seu ano e mês de nascimento, para os autores brasileiros. 
A listagem deve estar ordenada em ordem crescente de nome.*/

SELECT Nome, 
	   YEAR(Data_Nascimento) AS 'Ano de Nascimento', 
       MONTH(Data_Nascimento) AS 'Mês de Nascimento'
FROM Autores
WHERE Nacionalidade LIKE 'Br%'
ORDER BY Nome;

/*4.	Escreva o comando que retorna o nome dos autores e o título dos livros de sua autoria. A listagem deve estar ordenada pelo nome do autor.*/

SELECT A.Nome AS 'Nome do Autor', 
	   L.Titulo AS 'Título do Livro'
FROM Autores A
	 INNER JOIN Autores_Livros AL
		   ON A.Matricula=AL.Matricula
	 INNER JOIN Livros L 
		   ON AL.IdLivro=L.IdLivro
ORDER BY A.Nome DESC;

/*5.	Monte a consulta SQL que retorna as editoras que publicaram livros escritos pelo autora 'Ana da Silva'*/

SELECT E.Nome AS 'Editora'
FROM Editoras E
	 INNER JOIN Livros L 
		   ON E.IdEditora=L.IdEditora
	 INNER JOIN Autores_Livros AL
		   ON AL.IdLivro=L.IdLivro
	 INNER JOIN Autores A 
		   ON A.Matricula=AL.Matricula
WHERE A.Nome = 'Ana da Silva'
	  AND L.Lancamento IS NOT NULL
      AND L.Lancamento < NOW();

/*6. FUS (faça um SQL) que apresente o título do livro e o nome da editora que o publica para todos os livros que custam menos que 50 reais.*/

SELECT L.Titulo AS 'Livro',
	   E.Nome AS 'Editora'
FROM Editoras E
	 INNER JOIN Livros L 
		   ON E.IdEditora=L.IdEditora
	 INNER JOIN Autores_Livros AL
		   ON AL.IdLivro=L.IdLivro
	 INNER JOIN Autores A 
		   ON A.Matricula=AL.Matricula
WHERE L.Preco < 50;

/*7.	FUS que apresente o CPF, nome do autor e o preço máximo dos livros de sua autoria. Apresente somente as informações para os autores cujo preço máximo for superior a 50.*/

SELECT A.Nome AS 'Autor',
	   A.CPF,
	   MAX(L.Preco) AS 'Preço Máximo de Publicação'
FROM Livros L 
	   INNER JOIN Autores_Livros AL
			 ON AL.IdLivro=L.IdLivro
	   INNER JOIN Autores A 
			 ON A.Matricula=AL.Matricula
WHERE L.Preco > 50;