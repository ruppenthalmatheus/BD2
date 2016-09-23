/*1) - Criar tabelas do Slide 2*/

/*Criação da table Cidades*/
CREATE TABLE Cidades (
	codC INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    UF CHAR(2) NOT NULL
)engine=InnoDB;

/*Criação da table Fornecedores*/
CREATE TABLE Fornecedores (
	codF INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    codC INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    status BOOLEAN DEFAULT FALSE,
    fone VARCHAR(12),
    CONSTRAINT FK_Cidades_F
    FOREIGN KEY (codC) REFERENCES Cidades (codC)
		ON DELETE RESTRICT
        ON UPDATE CASCADE
)engine=InnoDB;

/*Criação da table Peças*/
CREATE TABLE Pecas (
	codP INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    codC INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    cor VARCHAR(20),
    peso float,
    CONSTRAINT FK_Cidades_P
    FOREIGN KEY (codC) REFERENCES Cidades (codC)
		ON DELETE RESTRICT
        ON UPDATE CASCADE
)Engine=InnoDB;

/*Criação da table Projetos*/
CREATE TABLE Projetos (
	codPR INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    codC INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Cidades_PR
    FOREIGN KEY (codC) REFERENCES Cidades (codC)
		ON DELETE RESTRICT
        ON UPDATE CASCADE
)engine=InnoDB;

/*Criação da table Fornecimentos*/
CREATE TABLE Fornecimentos (
	codF INT NOT NULL,
    codP INT NOT NULL,
    codPR INT NOT NULL,
    qtde INT NOT NULL,
    CONSTRAINT PK_Fornecimentos
    PRIMARY KEY (codF, codP, codPR),
    CONSTRAINT FK_Fornecedores
    FOREIGN KEY (codF) REFERENCES Fornecedores (codF)
		ON DELETE RESTRICT
        ON UPDATE CASCADE,
	CONSTRAINT FK_Pecas
    FOREIGN KEY (codP) REFERENCES Pecas (codP)
		ON DELETE RESTRICT
        ON UPDATE CASCADE,
	CONSTRAINT FK_Projetos
    FOREIGN KEY (codPR) REFERENCES Projetos (codPR)
		ON DELETE RESTRICT
        ON UPDATE CASCADE
)engine=InnoDB;

/*2) - Criar 2 cidades*/

INSERT INTO Cidades (nome, UF) VALUES 
('Torres', 'RS'),
('Arroio do Sal', 'RS');

/*3) Abrir uma transaction*/

START TRANSACTION;


/*4) Criar um fornecedor*/

INSERT INTO Fornecedores (codC, nome, status, fone) VALUES (1, 'Metalúrgica Ruppenthal', TRUE, '5599894584');

/*5) Criar uma peça*/

INSERT INTO Pecas (codC, nome, cor, peso) VALUES (1, 'Trava', 'Prata', '0.200');

/*6) Criar um projeto*/

INSERT INTO Projetos (codC, nome) VALUES (1, 'Projeto 1');

/*7) Criar um fornecimento*/

INSERT INTO Fornecimentos (codF, codP, codPR, qtde) VALUES (1, 1, 1, 30);

/*8) Fazer rollback*/

ROLLBACK;

/*9) Executar passos 3 a 7*/

START TRANSACTION;
INSERT INTO Fornecedores (codC, nome, status, fone) VALUES (1, 'Metalúrgica Ruppenthal', TRUE, '5599894584');
INSERT INTO Pecas (codC, nome, cor, peso) VALUES (1, 'Trava', 'Prata', '0.200');
INSERT INTO Projetos (codC, nome) VALUES (1, 'Projeto 1');
INSERT INTO Fornecimentos (codF, codP, codPR, qtde) VALUES (2, 2, 2, 30);
COMMIT;