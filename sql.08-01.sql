-- Início da transação para criar as tabelas
BEGIN;

-- Criação da tabela cliente
create table if not exists cliente( 
    id serial primary key,
    nome varchar(100) not null,
    cpf varchar(11) unique not null,
    email varchar(100) unique,
    telefone varchar(20),
    data_cadastro date not null default current_date
);

-- Criação da tabela produto
create table if not exists produto(
    id serial primary key,
    nome varchar(100) not null,
    descricao text,
    preco decimal(10,2) not null,
    data_cadastro date not null default current_date,
    constraint preco_maior_zero check (preco > 0)
);

-- Criação da tabela funcionario
create table if not exists funcionario(
    id serial primary key,
    nome varchar(100) not null,
    cpf varchar(11) unique not null,
    cargo varchar(120) not null,
    salario decimal(10,2) not null,
    email varchar(100) unique,
    constraint salario_maior_zero check (salario > 0),
    date_contracao date not null default current_date
);

-- Criação da tabela venda
create table if not exists venda(
    id serial primary key,
    cliente_id int not null,
    funcionario_id int,
    data_venda date default current_date,
    total_venda decimal(10,2) not null,
    constraint total_venda_maior_zero check (total_venda > 0),
    constraint fk_cliente foreign key (cliente_id) references cliente(id) on delete cascade,
    constraint fk_funcionario foreign key (funcionario_id) references funcionario(id) on delete set null
);

-- Criação da tabela itens_venda
create table if not exists itens_venda(
    id serial primary key,
    venda_id int,
    produto_id int,
    quantidade_itens integer not null,
    preco_unitario decimal(10,2) not null,
    subtotal decimal(10,2) not null,
    constraint fk_venda foreign key (venda_id) references venda(id) on delete cascade,
    constraint fk_produto foreign key (produto_id) references produto(id) on delete cascade,
    constraint quantidade_maior_zero check (quantidade_itens > 0),
    constraint preco_unitario_maior_zero check (preco_unitario > 0)
);

-- Se todas as operações forem bem-sucedidas, confirme a transação
COMMIT;

-- Caso algum erro aconteça em qualquer parte do processo, reverte as mudanças
-- ROLLBACK;

-- Início da transação para criar os registros nas tabelas
BEGIN;

-- Inserção de 5 registros de exemplo na tabela cliente
insert into cliente (nome, cpf, email, telefone) values
('João Silva', '12345678901', 'joao@exemplo.com', '11987654321'),
('Maria Oliveira', '23456789012', 'maria@exemplo.com', '11976543210'),
('Pedro Costa', '34567890123', 'pedro@exemplo.com', '11965432109'),
('Ana Santos', '45678901234', 'ana@exemplo.com', '11954321098'),
('Carlos Souza', '56789012345', 'carlos@exemplo.com', '11943210987');

-- Inserção de 5 registros de exemplo na tabela produto
insert into produto (nome, descricao, preco) values
('Notebook', 'Notebook 15 polegadas', 3500.00),
('Smartphone', 'Smartphone Android 6GB RAM', 1500.00),
('Cadeira Escritório', 'Cadeira ergonômica', 700.00),
('Teclado Mecânico', 'Teclado mecânico RGB', 300.00),
('Mouse', 'Mouse óptico sem fio', 80.00);

-- Inserção de 5 registros de exemplo na tabela funcionario
insert into funcionario (nome, cpf, cargo, salario, email) values
('Roberta Lima', '67890123456', 'Gerente', 5000.00, 'roberta@empresa.com'),
('Felipe Almeida', '78901234567', 'Vendedor', 3000.00, 'felipe@empresa.com'),
('Luciana Pereira', '89012345678', 'Assistente Administrativo', 2500.00, 'luciana@empresa.com'),
('Marcos Silva', '90123456789', 'Analista de TI', 4000.00, 'marcos@empresa.com'),
('Juliana Costa', '01234567890', 'Supervisor', 4500.00, 'juliana@empresa.com');

-- Inserção de 5 registros de exemplo na tabela venda
insert into venda (cliente_id, funcionario_id, total_venda) values
(1, 2, 4000.00),
(2, 3, 1500.00),
(3, 4, 3000.00),
(4, 5, 2200.00),
(5, 1, 5000.00);

-- Inserção de 5 registros de exemplo na tabela itens_venda
insert into itens_venda (venda_id, produto_id, quantidade_itens, preco_unitario, subtotal) values
(1, 1, 2, 3500.00, 7000.00),
(1, 2, 1, 1500.00, 1500.00),
(2, 3, 1, 700.00, 700.00),
(3, 4, 1, 300.00, 300.00),
(4, 5, 3, 80.00, 240.00);

-- Se todas as operações forem bem-sucedidas, confirme a transação
COMMIT;

-- Caso algum erro aconteça em qualquer parte do processo, reverte as mudanças
-- ROLLBACK;

-- Consultas as tabelas
SELECT * FROM cliente;
SELECT * FROM produto;
SELECT * FROM funcionario;
SELECT * FROM venda;
SELECT * FROM itens_venda;


-- 1. listar total vendas por cada cliente
select * from venda;
select cliente.nome, count(venda.cliente_id) as total_vendas
from venda
join cliente on venda.id = cliente.id
group by cliente.nome
order by cliente.nome asc;

-- 2. listar total vendas por funcionario

select * from venda;
select funcionario.nome, count(venda.funcionario_id) as total_venda
from venda
join funcionario on venda.id = funcionario.id
group by funcionario.nome
order by funcionario.nome asc;

-- 3 liste a quantidade total de produtos vendidos por cada venda
select * from itens_venda;
select * from venda; -- pedido
select * from itens_venda; --itens do pedido

select venda_id, sum (quantidade_itens) as quantidade_total_itens
from itens_venda
group by venda_id;

--5 Liste os clientes que realizaram mais de 5 compras
select * from venda;
select * from itens_venda;
select * from cliente;

select cliente.nome , count (venda.cliente_id)
from venda
join itens_venda on venda.cliente_id = itens_venda.venda_id
join cliente on cliente.id = venda.cliente_id
group by nome
having count (venda.cliente_id) >= 1;

-- 6 liste os produtos que possuem mais de 50 unidade em estoque 

select * from produto;
select nome, quantidade_estoque 
from produto
where quantidade_estoque > 50
order by quantidade_estoque asc;

--7 
select * from venda;
select funcionario.nome, count (venda.funcionario_id) as total_vendas
from venda
join funcionario on funcionario.id = venda.funcionario_id
group by funcionario.nome
having count (venda.funcionario_id)>=1

--8

select * from itens_venda;
select produto_id, sum (itens_venda.quantidade_itens) AS total_produtos
from itens_venda
join produto on itens_venda.produto_id = produto.id
group by produto_id
having sum (itens_venda.quantidade_itens) >=1
order by total_produtos desc;

--9 
select * from venda;

select cliente.nome, sum (venda.total_venda) as total_venda
from venda 
join cliente on cliente.id= venda.cliente_id
group by cliente.nome
order by total_venda desc;
