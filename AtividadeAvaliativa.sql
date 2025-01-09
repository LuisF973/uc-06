-- Criação da tabela cliente
create table if not exists cliente( 
    id serial primary key,
    nome varchar(100) not null,
    email varchar (100) unique not null,
    telefone varchar(20) unique not null,
    data_cadastro date not null default current_date
);

-- Criação da tabela servico
create table if not exists servico(
    id serial primary key,
    nome varchar(100) not null,
    descricao text not null,
    preco decimal(10,2) not null,
    tipo_servico varchar(50) not null,
    constraint preco_maior_zero check (preco > 0),
    constraint servico_tipo check (tipo_servico = 'Consultoria' or tipo_servico = 'Suporte' or tipo_servico = 'Manutenção')
);

-- Criação da tabela tecnico
create table if not exists tecnico(
    id serial primary key,
    nome varchar(100) not null,
    especialidade varchar(50) not null,
    date_contracao date not null default current_date
);

-- Criação da tabela chamado
create table if not exists chamado(
    id serial primary key,
    cliente_id int,
    tecnico_id int,
    servico_id int,
    data_chamado date default current_date,
    status varchar(20) not null,
    descricao text not null,
    constraint fk_cliente foreign key (cliente_id) references cliente(id) on delete cascade,
    constraint fk_tecnico foreign key (tecnico_id) references tecnico(id) on delete cascade,
    constraint fk_servico foreign key (servico_id) references servico(id) on delete cascade,
    constraint status_tipo check (status = 'Pendente' or status = 'Em Andamento' or status = 'Finalizado')
);

-- Criação da tabela pagamento
create table if not exists pagamento(
    id serial primary key,
    cliente_id int,
    chamado_id int,
    valor_pago decimal(10,2) not null,
    data_pagamento date not null,
    forma_pagamento varchar(50) not null,
    constraint fk_cliente foreign key (cliente_id) references cliente(id) on delete cascade,
    constraint fk_chamado foreign key (chamado_id) references chamado(id) on delete cascade,
    constraint pagamento_maior_zero check (valor_pago > 0)
);

-- Inserção de dados na tabela cliente
INSERT INTO cliente (nome, email, telefone, data_cadastro)
VALUES 
('João Silva', 'joao.silva@email.com', '11987654321', '2023-01-15'),
('Maria Oliveira', 'maria.oliveira@email.com', '21996543210', '2023-02-20'),
('Pedro Souza', 'pedro@email.com', '31997651234', '2023-03-10'),
('Ana Costa', 'ana@email.com', '41988889999', '2023-04-25'),
('Lucas Almeida', 'lucas@email.com', '61991234567', '2023-05-30');

-- Inserção de dados na tabela servico
INSERT INTO servico (nome, descricao, preco, tipo_servico)
VALUES 
('Consultoria de TI', 'Consultoria em tecnologias da informação', 500.00, 'Consultoria'),
('Manutenção de Equipamentos', 'Manutenção preventiva e corretiva de equipamentos', 300.00, 'Manutenção'),
('Suporte Técnico', 'Assistência técnica para computadores', 200.00, 'Suporte');

-- Inserção de dados na tabela tecnico
INSERT INTO tecnico (nome, especialidade, date_contracao)
VALUES 
('Carlos Oliveira', 'Consultoria TI', '2022-10-10'),
('Fernanda Souza', 'Manutenção', '2021-06-15'),
('Roberto Costa', 'Suporte Técnico', '2020-08-20');

-- Inserção de dados na tabela chamado
INSERT INTO chamado (cliente_id, tecnico_id, servico_id, data_chamado, status, descricao)
VALUES 
(1, 1, 1, '2023-06-01','Pendente', 'Fiação da casa queimada.'),
(2, 2, 2, '2023-07-10','Em Andamento', 'Vazamento na tubulação.'),
(3, 3, 3, '2023-08-05','Finalizado', 'Reparação no ar-condicionado.'),
(4, 1, 2, '2023-09-20','Pendente', 'Manutenção no servidor.'),
(5, 2, 1, '2023-09-20','Finalizado', 'Suporte para software.');

-- Inserção de dados na tabela pagamento
INSERT INTO pagamento (cliente_id, chamado_id, valor_pago, data_pagamento, forma_pagamento)
VALUES 
(1, 1, 350.00, '2023-06-15', 'Cartão de Crédito'),
(2, 2, 450.00, '2023-07-15', 'Transferência Bancária'),
(3, 3, 600.00, '2023-08-10', 'Cartão de Crédito'),
(4, 4, 300.00, '2023-08-10', 'Transferência Bancária');

-- Consultas para verificar os dados inseridos
SELECT * FROM cliente;
SELECT * FROM servico;
SELECT * FROM tecnico;
SELECT * FROM chamado;
SELECT * FROM pagamento;

-- Consultar email de todos os clientes
SELECT nome, email
FROM cliente;

--Consultar preço de todos os serviços
SELECT nome, preco
FROM servico;

-- Consultar nome e especialidade dos tecnicos
SELECT nome, especialidade
FROM tecnico;

-- Consultar descrição e status dos chamados
SELECT descricao, status
FROM chamado;

--Consultar valor pago e data de pagamento
SELECT valor_pago, data_pagamento
FROM pagamento;

--Consultar nome do cliente e descrição dos seus chamados EM ANDAMENTO
SELECT cliente.nome, chamado.descricao
FROM cliente
JOIN chamado on cliente_id = chamado.id
WHERE chamado.status = 'Em Andamento';

-- Recupera os nomes dos técnicos que realizaram serviços com o tipo "Manutenção".
SELECT tecnico.nome, tecnico.especialidade
FROM tecnico
WHERE tecnico.especialidade = 'Manutenção';

--Mostra os nomes dos clientes e o valor total pago por cada um deles.
SELECT cliente.nome, valor_pago
FROM cliente 
JOIN pagamento on cliente_id = pagamento.id
WHERE (valor_pago > 0)

-- Listar os clientes e os serviços que eles solicitaram, incluindo a descrição do serviço.
SELECT cliente.nome, servico.nome, servico.descricao, servico.preco, servico.tipo_servico
FROM cliente
JOIN servico on cliente.id = servico.id

--Recupera os nomes dos técnicos que realizaram chamados para serviços com o preço superior a 400, e exiba também o nome do serviço.
SELECT tecnico.nome, servico.preco, servico.nome
FROM tecnico, servico
WHERE (servico.preco > 400)

--Atualiza o preço de todos os serviços do tipo "Manutenção" para 350, se o preço atual for inferior a 350
SELECT * FROM servico
UPDATE servico
SET preco = 350
WHERE tipo_servico = 'Manutenção' AND preco < 350;
SELECT * FROM servico

-- Deletar todos os tecnicos sem chamado registrado
SELECT * FROM tecnico
WHERE id NOT IN (SELECT DISTINCT tecnico_id FROM chamado);
SELECT * FROM TECNICO
SELECT * FROM CHAMADO