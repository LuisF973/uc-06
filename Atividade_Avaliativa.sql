-- autor
-- id, nome,nacionalidade, data_nascimento.

--bicliotecario
--id, nome, email, telefone, id_unidade, data_contratacao.

-- categoria
-- id, nome, descricao.

--emprestimo
-- id, id_usuario, id_livro, data_emprestimo, data_devolucao, devolvido.

-- livro
-- id, titulo, id_autor, id _categoria, ano_publicado, numero_paginas, disponivel, id_unidade.

--unidade 
-- id,nome, endereco,telefone, horario_funcionamento, horario_atendimento.

-- usuario
-- id,nome,email,telefone,endereco,data_cadastro

select * from autor;
select * from bibliotecario;
select * from categoria;
select * from emprestimo;
select * from livro;
select * from unidade;
select * from usuario;

--1. Quantidade de bibliotecários responsáveis por cada unidade.

select unidade.nome as unidade_nome, count (b.id) as total_bibliotecarios
from unidade
left join bibliotecario b on b.id_unidade = unidade.id
group by unidade.id, unidade.nome;


--2. Quantidade de livros disponíveis em cada unidade.

select unidade.nome as unidade_nome, count (livro.id) as total_livro
from livro
join unidade on livro.id_unidade = unidade.id
group by unidade.id, unidade.nome;

-- 3. Quantidade de empréstimos realizados em cada unidade.

SELECT unidade.nome AS unidade_nome, COUNT(emprestimo.id) AS total_emprestimos
FROM livro
JOIN unidade ON livro.id_unidade = unidade.id
LEFT JOIN emprestimo ON livro.id = emprestimo.id_livro
GROUP BY unidade.id, unidade.nome
ORDER BY unidade.nome;

--5. Quantidade total de usuários cadastrados no sistema.

select count (usuario.id) as total_usuario
from usuario;

--6. Quantidade total de livros cadastrados no sistema.

select count (livro.id) as total_livro
from livro;

--7. Quantidade de livros emprestados por cada usuário. Ordene pelo total encontrado e em
--ordem decrescente.

select usuario.nome as usuario_nome, count (emprestimo.id )as total_emprestimo
from usuario
join emprestimo on usuario.id = emprestimo.id_usuario
group by usuario.id, usuario.nome
order by total_emprestimo desc;

--8. Quantidade de empréstimos realizados por mês. Use EXTRACT(MONTH FROM
--data_emprestimo) para extrair o mês.

select extract (month from emprestimo.data_emprestimo) as mes,
count (emprestimo.id) as total_emprestimo
from emprestimo
group by mes 
order by mes asc, total_emprestimo desc;

--9. Média do número de páginas dos livros cadastrados no sistema.

select round (avg(numero_paginas),2)
from livro;

--10. Quantidade de livros cadastrados em cada categoria.

SELECT categoria.nome AS categoria, COUNT(livro.id) AS total_livros
FROM categoria
LEFT JOIN livro ON categoria.id = livro.id_categoria
GROUP BY categoria.id
ORDER BY total_livros DESC;

--11. Liste os livros cujos autores possuem nacionalidade americana.

SELECT livro.titulo AS livro, autor.nome AS autor
FROM livro
JOIN autor ON livro.id_autor = autor.id
WHERE autor.nacionalidade = 'Americana';

--12. Quantidade de livros emprestados atualmente (não devolvidos).

SELECT 
COUNT(emprestimo.id) AS total_livros_emprestados
FROM livro
JOIN unidade ON livro.id_unidade = unidade.id
LEFT JOIN emprestimo ON livro.id = emprestimo.id_livro 
WHERE emprestimo.devolvido = 'false' OR emprestimo.devolvido IS NULL;

-- 13. Unidades com mais de 60 livros cadastrados.

SELECT unidade.nome, COUNT(livro.id) AS total_livros_cadastrados
FROM unidade
JOIN livro ON livro.id_unidade = unidade.id
GROUP BY unidade.nome
HAVING COUNT(livro.id) > 60
ORDER BY unidade.nome;

-- 14. Quantidade de livros por autor. Ordene pelo total e em ordem decrescente.

SELECT categoria.nome AS categoria_nome, COUNT(livro.id) AS total_livros_disponiveis
FROM categoria
LEFT JOIN livro ON livro.id_categoria = categoria.id
WHERE livro.disponivel = 'true'
GROUP BY categoria.id
ORDER BY total_livros_disponiveis DESC;

-- 15. Categorias que possuem mais de 5 livros disponíveis atualmente.

SELECT categoria.nome AS categoria_nome, COUNT(livro.id) AS total_livros_disponiveis
FROM categoria
LEFT JOIN livro ON livro.id_categoria = categoria.id
WHERE livro.disponivel = 'true'
GROUP BY categoria.id
ORDER BY total_livros_disponiveis DESC;

-- 16. Unidades com pelo menos um empréstimo em aberto.

SELECT unidade.nome AS unidade_nome, COUNT(emprestimo.id) AS total_emprestimos_emaberto
FROM unidade
LEFT JOIN livro ON livro.id_unidade = unidade.id
LEFT JOIN emprestimo ON livro.id = emprestimo.id_livro
WHERE emprestimo.devolvido = 'false' OR emprestimo.devolvido IS NULL
GROUP BY unidade.id, unidade.nome
ORDER BY total_emprestimos_emaberto DESC;
