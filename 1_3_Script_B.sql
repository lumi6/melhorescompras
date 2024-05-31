DECLARE
-- Declare variables for storing values from the cursor
  v_sg_estado mc_estado.sg_estado%TYPE;
  v_nm_estado mc_estado.nm_estado%TYPE;
  v_tp_sac mc_sgv_ocorrencia_sac.ds_tipo_classificacao_sac%TYPE;
  v_cd_produto mc_produto.cd_produto%TYPE;
  v_ds_produto mc_produto.ds_produto%TYPE;
  v_vl_unitario_produto NUMBER;
  v_vl_perc_lucro NUMBER;
  v_nr_cliente mc_cliente.nr_cliente%TYPE;
  v_nm_cliente mc_cliente.nm_cliente%TYPE;
  v_vl_unitario_lucro_produto NUMBER(10,2);
  v_vl_perc_icms_estado NUMBER(10,2);
  v_vl_icms_produto NUMBER(10,2);

  -- Cursor to process each row
  CURSOR cur_datos_sac IS
    SELECT
      e.sg_estado,
      e.nm_estado,
      sac.tp_sac,
      prod.cd_produto,
      prod.ds_produto,
      prod.vl_unitario,
      prod.vl_perc_lucro,
      cli.nr_cliente,
      cli.nm_cliente
    FROM
      mc_sgv_sac sac
    INNER JOIN
      mc_produto prod ON sac.cd_produto = prod.cd_produto
    INNER JOIN
      mc_cliente cli ON sac.nr_cliente = cli.nr_cliente
    INNER JOIN
      mc_end_cli endc ON cli.nr_cliente = endc.nr_cliente
    INNER JOIN
      mc_logradouro logr ON endc.cd_logradouro_cli = logr.cd_logradouro
    INNER JOIN
      mc_bairro b ON logr.cd_bairro = b.cd_bairro
    INNER JOIN
      mc_cidade c ON b.cd_cidade = c.cd_cidade
    INNER JOIN
      mc_estado e ON c.sg_estado = e.sg_estado;



  v_contador INTEGER := 0;

BEGIN
  OPEN cur_datos_sac;

  LOOP
    FETCH cur_datos_sac INTO v_sg_estado, v_nm_estado, v_tp_sac, v_cd_produto, v_ds_produto, v_vl_unitario_produto, v_vl_perc_lucro, v_nr_cliente, v_nm_cliente;
 CASE v_tp_sac
      WHEN 'S' THEN v_tp_sac := 'Sugestão';
      WHEN 'D' THEN v_tp_sac := 'Dúvida';
      WHEN 'E' THEN v_tp_sac := 'Elogio';
      ELSE v_tp_sac := 'Classificação Inválida';
    END CASE;
    -- Salir del bucle si no hay más filas o si se alcanza el límite
    EXIT WHEN cur_datos_sac%NOTFOUND OR v_contador >= 10;
-- Calculate vl_unitario_lucro_produto
    v_vl_unitario_lucro_produto := (v_vl_perc_lucro / 100) * v_vl_unitario_produto;
-- Get customer's state ICMS percentage
    v_vl_perc_icms_estado := fun_mc_gera_aliquota_media_icms_estado(v_sg_estado);
 -- Calculate vl_icms_produto
    v_vl_icms_produto := (v_vl_perc_icms_estado / 100) * v_vl_unitario_produto;
    
    INSERT INTO MC_SGV_OCORRENCIA_SAC (
      nr_ocorrencia_sac, -- Número de ocorrência (asumiendo 323)
      ds_tipo_classificacao_sac,
      cd_produto,
      ds_produto,
      vl_unitario_produto,
      vl_perc_lucro,
      vl_unitario_lucro_produto,
      sg_estado,
      nm_estado,
      nr_cliente,
      nm_cliente,
      vl_icms_produto
      )
      values(
        126,
        v_tp_sac,
        v_cd_produto,
        v_ds_produto,
        v_vl_unitario_produto,
        v_vl_perc_lucro,
        v_vl_unitario_lucro_produto,
        v_sg_estado,
        v_nm_estado,
        v_nr_cliente,
        v_nm_cliente,
        v_vl_icms_produto
      );
    -- Incrementar el contador de filas
    v_contador := v_contador + 1;


    
  END LOOP;

  CLOSE cur_datos_sac;
END;
