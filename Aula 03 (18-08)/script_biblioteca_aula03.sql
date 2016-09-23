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
 
DELETE FROM Livros WHERE IdLivro >= 2 AND Preco > 50.00 AND Lancamento < NOW();
    
SELECT Nome, CPF, Endereco FROM Autores WHERE Nome LIKE '%João%';

DELETE FROM Livros WHERE Titulo = 'Banco de Dados Distrituído' OR Titulo = 'Bancos de Dados Distribuídos';

SELECT Nome, CPF FROM Autores WHERE Data_Nascimento > 1990-01-01;

SELECT Matricula, Nome FROM Autores WHERE Endereco LIKE '%Rio de Janeiro%';

UPDATE Livros SET Preco = 0 WHERE Lancamento = NULL OR Preco < 55;

DELETE FROM Livros WHERE IdAssunto != 'S' OR IdAssunto != 'P' OR IdAssunto != 'B';

SELECT COUNT(*) AS 'Total de Autores' FROM Autores;




