-- As entidades selecionadas e realizadas pelo grupo são: 
-- 'T_MC_PRODUTO' e 'T_MC_FACTURACAO'. 
-- As entidades mostradas têm relação com a entidade de faturação e podem ser criadas com base nessa relação.

DROP TABLE t_mc_cliente CASCADE CONSTRAINTS;

DROP TABLE t_mc_produto CASCADE CONSTRAINTS;

DROP TABLE t_mc_facturacao CASCADE CONSTRAINTS;

DROP TABLE t_mc_prod_fact CASCADE CONSTRAINTS;

CREATE TABLE t_mc_cliente (
    cd_cliente          NUMBER(10) NOT NULL,
    nm_cliente          VARCHAR2(50) NOT NULL,
    nr_estrella_cliente NUMBER(5) NOT NULL,
    st_cliente          VARCHAR2(3) NOT NULL,
    nr_telefone         NUMBER(10),
    seccion_cliente     VARCHAR2(10) NOT NULL,
    senha_cliente_      VARCHAR2(10) NOT NULL
);

ALTER TABLE t_mc_cliente ADD CONSTRAINT t_mc_cliente_pk PRIMARY KEY ( cd_cliente );

CREATE TABLE t_mc_produto (
    id_prod       NUMBER(10) NOT NULL,
    ds_norm_prod  VARCHAR2(255) NOT NULL,
    ds_compl_prod VARCHAR2(1000) NOT NULL,
    cd_barra_prod VARCHAR2(13),
    pc_unit_prod  FLOAT(6) NOT NULL,
    sta_prod      VARCHAR2(10) NOT NULL
);

ALTER TABLE t_mc_produto
    ADD CONSTRAINT check_t_mc_produto_status CHECK ( sta_prod IN ( 'A', 'I' ) );

ALTER TABLE t_mc_produto ADD CONSTRAINT pk_t_mc_produto PRIMARY KEY ( id_prod );

ALTER TABLE t_mc_produto ADD CONSTRAINT un_t_mc_produto_ds_norm_prod UNIQUE ( ds_norm_prod );

CREATE SEQUENCE t_mc_produto_id_prod_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER t_mc_produto_id_prod_trg BEFORE
    INSERT ON t_mc_produto
    FOR EACH ROW
    WHEN ( new.id_prod IS NULL )
BEGIN
    :new.id_prod := t_mc_produto_id_prod_seq.nextval;
END;
/

CREATE TABLE t_mc_facturacao (
    cd_fact       NUMBER(10) NOT NULL,
    cd_cliente    NUMBER(10) NOT NULL,
    dt_fact       DATE NOT NULL,
    qt_prod       NUMBER(10) NOT NULL,
    pc_total_fact FLOAT(8) NOT NULL
);

ALTER TABLE t_mc_facturacao ADD CONSTRAINT pk_t_mc_facturacao PRIMARY KEY ( cd_fact );

ALTER TABLE t_mc_facturacao
    ADD CONSTRAINT fk_t_mc_facturacao_t_mc_clie FOREIGN KEY ( cd_cliente )
        REFERENCES t_mc_cliente ( cd_cliente );

CREATE SEQUENCE t_mc_facturacao_cd_fact_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER t_mc_facturacao_cd_fact_trg BEFORE
    INSERT ON t_mc_facturacao
    FOR EACH ROW
    WHEN ( new.cd_fact IS NULL )
BEGIN
    :new.cd_fact := t_mc_facturacao_cd_fact_seq.nextval;
END;
/

CREATE TABLE t_mc_prod_fact (
    cd_prod_fact NUMBER(10) NOT NULL,
    id_prod      NUMBER(10) NOT NULL,
    cd_fact      NUMBER(10) NOT NULL,
    qt_prod      NUMBER(10) NOT NULL
);

ALTER TABLE t_mc_prod_fact ADD CONSTRAINT t_mc_prod_fact_pk PRIMARY KEY ( cd_prod_fact );

ALTER TABLE t_mc_prod_fact
    ADD CONSTRAINT fk_t_mc_prod_fact_t_mc_fact FOREIGN KEY ( cd_fact )
        REFERENCES t_mc_facturacao ( cd_fact );

ALTER TABLE t_mc_prod_fact
    ADD CONSTRAINT fk_t_mc_prod_fact_t_mc_prod FOREIGN KEY ( id_prod )
        REFERENCES t_mc_produto ( id_prod );

