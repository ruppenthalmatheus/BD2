/*a)	Temos uma tabela Produtos (id PK AI, codbar, descricao, valor) e o dba não colocou nenhuma regra quanto a unicidade da coluna código de barras. 
Ou seja, não pode ter dois produtos com o mesmo código de barras cadastrados nessa tabela. 
Bem, nem tudo são flores e o usuário é ótimo em fazer surpresas, o caboclo acabou cadastrando varios produtos com código de barras duplicados ou mais. 
Você para resolver isso deve FUS que retorne os produtos que tem mais de um código de barras cadastrado.*/

SELECT *, 
	   COUNT(codbar) Repetições 
FROM Produtos 
GROUP BY codbar 
HAVING Repetições > 1;

/*b)	Todos os alunos postam tarefas das disciplinas em que estão cursando. 
A coordenação do curso quer dar um presente para os 10 alunos que mais postam tarefas nas suas disciplinas. 
Liste esses alunos mostrando quantas tarefas eles postaram.*/

SELECT A.nome Aluno, 
	   COUNT(T.id) Tarefas
FROM Tarefas T
	   INNER JOIN Alunos A 
			 ON T.id_aluno=A.id
GROUP BY Aluno
ORDER BY Tarefas DESC
LIMIT 10;

/*c)	Aproveite também e liste as disciplinas que tem mais que 50 tarefas postadas pelos alunos no semestre 2016-1. */

SELECT D.nome Disciplina,
	   COUNT(T.id) Tarefas
FROM Tarefas T
	   INNER JOIN Disciplinas D
			 ON T.id_disciplina=D.id
GROUP BY Disciplina
HAVING Tarefas > 50;