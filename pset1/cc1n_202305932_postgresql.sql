--Deleta banco de dados e usuario caso existam;
DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS gabriel;

--Cria usuario gabriel;
CREATE USER gabriel
WITH PASSWORD 'biel12345'
CREATEDB
CREATEROLE;

--Troca para o novo usuario gabriel;
SET ROLE gabriel;

--Criação do banco de dados uvv;
CREATE DATABASE uvv
OWNER gabriel
template template0
encoding UTF8
lc_collate "pt_BR.UTF-8"
lc_ctype "pt_BR.UTF-8"
allow_connections TRUE
;

--Usa o banco de dados uvv como usuario gabriel;
\c uvv;
SET ROLE gabriel;

--Cria o schema lojas;
CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION gabriel;

--Coloca o caminho para o schema;
ALTER USER gabriel SET search_path TO lojas,"$user",public;

--Cria tabela clientes e suas colunas;
CREATE TABLE lojas.clientes (
                             cliente_id NUMERIC(38)  NOT NULL,
                             email      VARCHAR(255) NOT NULL,
                             nome       VARCHAR(255) NOT NULL,
                             telefone1  VARCHAR(20),
                             telefone2  VARCHAR(20),
                             telefone3  VARCHAR(20),
                             --Cria chave primaria da tabela clientes;
                             CONSTRAINT clientes_id PRIMARY KEY (cliente_id)
                            );

--Adciona restrições às colunas da tabela clientes;
ALTER TABLE lojas.clientes ADD CONSTRAINT check_cliente_id_positivo CHECK (cliente_id > 0);
ALTER TABLE lojas.clientes ADD CONSTRAINT check_email_valido        CHECK (email LIKE '%___@___%.__%');


--Adciona comentarios às colunas da tabela clientes;
COMMENT ON TABLE  lojas.clientes            IS 'Tabela de registro de clientes';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Id de registro de clientes, chave primaria da tabela, recebe apenas numeros';
COMMENT ON COLUMN lojas.clientes.email      IS 'Email de cadastro dos clientes';
COMMENT ON COLUMN lojas.clientes.nome       IS 'Nome dos clientes';
COMMENT ON COLUMN lojas.clientes.telefone1  IS 'Telefone principal dos clientes';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'Telefone secundario dos clientes';
COMMENT ON COLUMN lojas.clientes.telefone3  IS 'Telefone terciario dos clientes';


--Cria tabela produtos e suas colunas;
CREATE TABLE lojas.produtos (
                             produto_id                NUMERIC(38)  NOT NULL,
                             nome                      VARCHAR(255) NOT NULL,
                             preco_unitario            NUMERIC(10,2),
                             detalhes                  BYTEA,
                             imagem                    BYTEA,
                             imagem_mime_type          VARCHAR(512),
                             imagem_arquivo            VARCHAR(512),
                             imagem_charset            VARCHAR(512),
                             imagem_ultima_atualizacao DATE,
                             --Cria chave primaria da tabela produtos;
                             CONSTRAINT produto_id PRIMARY KEY (produto_id)
                            );
--Adciona restrições às colunas da tabela produtos;
ALTER TABLE lojas.produtos ADD CONSTRAINT check_produto_id_positivo       CHECK (produto_id     > 0);
ALTER TABLE lojas.produtos ADD CONSTRAINT check_preco_unitario_positivo   CHECK (preco_unitario > 0);
ALTER TABLE lojas.produtos ADD CONSTRAINT check_imagem_ultima_atualizacao CHECK (imagem_ultima_atualizacao > '1900-01-01');

--Adciona comentarios às tabelas produtos;
COMMENT ON TABLE  lojas.produtos                           IS 'Tabela de registro dos produtos';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'Id dos produtos, chave primaria da tabela, recebe apenas números';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'Nome dos produtos';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'Preço unitário de cada produto';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'Detalhes de cada produto, recebe apenas BLOB';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'Imagem de cada produto';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'Recebe a identificação do tipo de arquivo da imagem dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'Recebe o arquivo da imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_charset            IS 'Recebe o charset referente a imagem dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Data da ultima atualizacao da imagem do produto, recebe apenas data';

--Cria tabela lojas e suas colunas;
CREATE TABLE lojas.lojas (
                          loja_id                 NUMERIC(38)  NOT NULL,
                          nome                    VARCHAR(255) NOT NULL,
                          endereco_web            VARCHAR(100),
                          endereco_fisico         VARCHAR(512),
                          latitude                NUMERIC,
                          longitude               NUMERIC,
                          logo                    BYTEA,
                          logo_mime_type          VARCHAR(512),
                          logo_arquivo            VARCHAR(512),
                          logo_charset            VARCHAR(512),
                          logo_ultima_atualizacao DATE,
                          --Cria chave primaria da tabela lojas;
                          CONSTRAINT loja_id PRIMARY KEY (loja_id)
                         );

--Adciona restrições às colunas da tabela lojas;
ALTER TABLE lojas.lojas ADD CONSTRAINT check_loja_id_positivo        CHECK (loja_id > 0);
ALTER TABLE lojas.lojas ADD CONSTRAINT check_endereco_web            CHECK (endereco_web LIKE '%.com%');
ALTER TABLE lojas.lojas ADD CONSTRAINT check_logo_ultima_atualizacao CHECK (logo_ultima_atualizacao > '1900-01-01');
ALTER TABLE lojas.lojas ADD CONSTRAINT check_endereco_web_ou_fisico  CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

--Adciona comentarios às colunas da tabela lojas;
COMMENT ON TABLE  lojas.lojas                         IS 'Tabela de registro de informações sobre lojas parceiras';
COMMENT ON COLUMN lojas.lojas.loja_id                 IS 'Id das lojas parceiras, chave primeira da tabela, recebe apenas números';
COMMENT ON COLUMN lojas.lojas.nome                    IS 'Nome das lojas parceiras';
COMMENT ON COLUMN lojas.lojas.endereco_web            IS 'Endereço para o site das lojas parceiras';
COMMENT ON COLUMN lojas.lojas.endereco_fisico         IS 'Endereço físico das lojas parceiras';
COMMENT ON COLUMN lojas.lojas.latitude                IS 'Coordenadas geograficas latitudinais das lojas parceiras';
COMMENT ON COLUMN lojas.lojas.longitude               IS 'Coordenadas geograficas longitudenais das lojas parceiras';
COMMENT ON COLUMN lojas.lojas.logo                    IS 'Logo das lojas parceiras, recebe apenas BLOB';
COMMENT ON COLUMN lojas.lojas.logo_mime_type          IS 'Recebe a identificação do tipo de arquivo da logo das lojas parceiras';
COMMENT ON COLUMN lojas.lojas.logo_arquivo            IS 'Recebe o logo das lojas parceiras';
COMMENT ON COLUMN lojas.lojas.logo_charset            IS 'Recebe o charset referente a logo das lojas parceiras';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Datas da ultima atualizacao das logos das lojas parceiras, recebe apenas data';

--Cria tabela envios e suas colunas;
CREATE TABLE lojas.envios (
                           envio_id         NUMERIC(38)  NOT NULL,
                           loja_id          NUMERIC(38)  NOT NULL,
                           cliente_id       NUMERIC(38)  NOT NULL,
                           endereco_entrega VARCHAR(512) NOT NULL,
                           status           VARCHAR(15)  NOT NULL,
                           --Cria chave primaria da tabela envios;
                           CONSTRAINT envio_id PRIMARY KEY (envio_id)
                          );

--Adciona restrições às colunas da tabela envios;
ALTER TABLE lojas.envios ADD CONSTRAINT check_envio_id_positivo   CHECK (envio_id   > 0);
ALTER TABLE lojas.envios ADD CONSTRAINT check_loja_id_positivo    CHECK (loja_id    > 0);
ALTER TABLE lojas.envios ADD CONSTRAINT check_cliente_id_positivo CHECK (cliente_id > 0);
ALTER TABLE lojas.envios ADD CONSTRAINT check_status_envios       CHECK (status IN('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

--Adciona comentarios às colunas da tabela envios;
COMMENT ON TABLE  lojas.envios                  IS 'Tabela de registro de envios';
COMMENT ON COLUMN lojas.envios.envio_id         IS 'Id dos envios, chave primaria da tabela, recebe apenas numeros';
COMMENT ON COLUMN lojas.envios.loja_id          IS 'Id das lojas parceiras, chave estrangeira, recebe apenas números';
COMMENT ON COLUMN lojas.envios.cliente_id       IS 'Id de registro de clientes, chave estrangeira, recebe apenas numeros';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Registro de endereço para entrega dos pedidos';
COMMENT ON COLUMN lojas.envios.status           IS 'Status atual do envio dos pedidos';

--Cria a tabela pedidos e suas colunas;
CREATE TABLE lojas.pedidos (
                            pedido_id  NUMERIC(38) NOT NULL,
                            data_hora  TIMESTAMP   NOT NULL,
                            cliente_id NUMERIC(38) NOT NULL,
                            status     VARCHAR(15) NOT NULL,
                            loja_id    NUMERIC(38) NOT NULL,
                            --Cria chave primaria da tabela pedidos;
                            CONSTRAINT pedido_id PRIMARY KEY (pedido_id)
                           );

--Adciona restrições às colunas da tabela pedidos;
ALTER TABLE lojas.pedidos ADD CONSTRAINT check_pedido_id_positivo  CHECK (pedido_id  > 0);
ALTER TABLE lojas.pedidos ADD CONSTRAINT check_cliente_id_positivo CHECK (cliente_id > 0);
ALTER TABLE lojas.pedidos ADD CONSTRAINT check_loja_id_positivo    CHECK (loja_id    > 0);
ALTER TABLE lojas.pedidos ADD CONSTRAINT check_data_hora           CHECK (data_hora > '1900-01-01 00:00:00');
ALTER TABLE lojas.pedidos ADD CONSTRAINT check_status_pedidos      CHECK (status IN('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOSLADO', 'ENVIADO'));

--Adciona comentarios às colunas da tabela pedidos;
COMMENT ON TABLE  lojas.pedidos            IS 'Tabela de registro dos pedidos';
COMMENT ON COLUMN lojas.pedidos.pedido_id  IS 'Id dos pedidos, chave primaria da tabela, recebe apenas numeros';
COMMENT ON COLUMN lojas.pedidos.data_hora  IS 'Data e hora da realizacao do pedido, utiliza apenas TIMESTAMP';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'Id de registro de clientes, chave estrangeira, recebe apenas numeros';
COMMENT ON COLUMN lojas.pedidos.status     IS 'Status atual do pedido';
COMMENT ON COLUMN lojas.pedidos.loja_id    IS 'Id das lojas parceiras, chave estrangeira, recebe apenas números';

--Cria tabela pedidos_itens e suas colunas;
CREATE TABLE lojas.pedidos_itens (
                                  pedido_id       NUMERIC(38)   NOT NULL,
                                  produto_id      NUMERIC(38)   NOT NULL,
                                  numero_da_linha NUMERIC(38)   NOT NULL,
                                  preco_unitario  NUMERIC(10,2) NOT NULL,
                                  quantidade      NUMERIC(38)   NOT NULL,
                                  envio_id        NUMERIC(38),
                                  --Cria chave primaria da tabela pedidos_itens;
                                  CONSTRAINT pedido_id_produto_id PRIMARY KEY (pedido_id, produto_id)
                                 );
                                
--Adciona restrições às colunas da tabela pedidos_itens;
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT check_pedido_id_positivo       CHECK (pedido_id       > 0);
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT check_produtos_id_positivo     CHECK (produto_id      > 0);
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT check_numero_da_linha_positivo CHECK (numero_da_linha > 0);
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT check_preco_unitario_positivo  CHECK (preco_unitario  > 0);
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT check_quantidade_positivo      CHECK (quantidade      > 0);
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envio_id_positivo              CHECK (envio_id        > 0);

--Adciona comentarios às colunas da tabela pedidos_itens;
COMMENT ON TABLE  lojas.pedidos_itens                 IS 'Tabela de registro dos itens dos pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id       IS 'Id dos pedidos, chave primaria da tabela e estrangeira, recebe apenas numeros';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id      IS 'Id dos produtos, chave primaria da tabela e estrangeira, recebe apenas números';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Numero de itens dos pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario  IS 'Preco unitario de cada produto';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade      IS 'Quantidade de itens dos pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id        IS 'Id dos envios, chave estrangeira, recebe apenas numeros';

--Cria tabela estoques e suas colunas;
CREATE TABLE lojas.estoques (
                             estoque_id NUMERIC(38) NOT NULL,
                             loja_id    NUMERIC(38) NOT NULL,
                             produto_id NUMERIC(38) NOT NULL,
                             quantidade NUMERIC(38) NOT NULL,
                             --Cria chave primaria da tabela estoques;
                             CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
                             );
--Adciona restrições às colunas da tabela estoques;
ALTER TABLE lojas.estoques ADD CONSTRAINT check_estoque_id_positivo CHECK (estoque_id > 0);
ALTER TABLE lojas.estoques ADD CONSTRAINT check_loja_id_positivo    CHECK (loja_id    > 0);
ALTER TABLE lojas.estoques ADD CONSTRAINT check_produto_id_positivo CHECK (produto_id > 0);
ALTER TABLE lojas.estoques ADD CONSTRAINT check_quantidade_positivo CHECK (quantidade > 0);

--Adciona comentarios às colunas da tabela estoques;
COMMENT ON TABLE  lojas.estoques            IS 'Tabela de registro do estoque';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'Id do estoque, chave primaria da tabela, recebe apenas numeros';
COMMENT ON COLUMN lojas.estoques.loja_id    IS 'Id das lojas parceiras, chave estrangeira, recebe apenas números';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'Id dos produtos, chave estrangeira, recebe apenas números';

--Cria relacionamento entre a tabela pedidos e a tabela clientes, por meio da chave estrangeira cliente_id;
ALTER TABLE    lojas.pedidos
ADD CONSTRAINT pedidos_clientes_fk
FOREIGN KEY    (cliente_id)
REFERENCES     lojas.clientes (cliente_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT DEFERRABLE;

--Cria relacionamento entre a tabela envios e a tabela clientes, por meio da chave estrangeira cliente_id;
ALTER TABLE    lojas.envios
ADD CONSTRAINT envios_clientes_fk
FOREIGN KEY    (cliente_id)
REFERENCES     lojas.clientes (cliente_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT DEFERRABLE;

--Cria relacionamento entre a tabela estoques e a tabela produtos, por meio da chave estrangeira produto_id;
ALTER TABLE    lojas.estoques
ADD CONSTRAINT estoques_produtos_fk
FOREIGN KEY    (produto_id)
REFERENCES     lojas.produtos (produto_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT DEFERRABLE;

--Cria relacionamento entre a tabela pedidos_itens e a tabela produtos, por meio da chave estrangeira produto_id;
ALTER TABLE    lojas.pedidos_itens
ADD CONSTRAINT pedidos_itens_produtos_fk
FOREIGN KEY    (produto_id)
REFERENCES     lojas.produtos (produto_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT DEFERRABLE;

--Cria relacionamento entre a tabela estoques e a tabela lojas, por meio da chave estrangeira loja_id;
ALTER TABLE    lojas.estoques
ADD CONSTRAINT estoques_lojas_fk
FOREIGN KEY    (loja_id)
REFERENCES     lojas.lojas (loja_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT DEFERRABLE;

--Cria relacionamento entre as tabelas pedidos e a tabela lojas, por meio da chave estrangeira loja_id;
ALTER TABLE    lojas.pedidos 
ADD CONSTRAINT pedidos_lojas_fk
FOREIGN KEY    (loja_id)
REFERENCES     lojas.lojas (loja_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT DEFERRABLE;

--Cria relacionamento entre as tabelas envios e a tabela lojas, por meio da chave estrangeira loja_id;
ALTER TABLE    lojas.envios 
ADD CONSTRAINT envios_lojas_fk
FOREIGN KEY    (loja_id)
REFERENCES     lojas.lojas (loja_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT DEFERRABLE;

--Cria relacionamento entre as tabelas pedidos_itens e a tabela envios, por meio da chave estrangeira envio_id;
ALTER TABLE    lojas.pedidos_itens 
ADD CONSTRAINT pedidos_itens_envios_fk
FOREIGN KEY    (envio_id)
REFERENCES     lojas.envios (envio_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT DEFERRABLE;

--Cria relacionamento entre as tabelas pedidos_itens e a tabela pedidos, por meio da chave estrangeira pedido_id;
ALTER TABLE    lojas.pedidos_itens
ADD CONSTRAINT pedidos_itens_pedidos_fk
FOREIGN KEY    (pedido_id)
REFERENCES     lojas.pedidos (pedido_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT DEFERRABLE;
