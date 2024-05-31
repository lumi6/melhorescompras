-- A)

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_sac IS
        SELECT
            sac.nr_sac,
            sac.dt_abertura_sac,
            sac.hr_abertura_sac,
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
            mc_cliente cli ON sac.nr_cliente = cli.nr_cliente;
BEGIN
    FOR sac_info IN c_sac LOOP
        DBMS_OUTPUT.PUT_LINE('Número do SAC: ' || sac_info.nr_sac);
        DBMS_OUTPUT.PUT_LINE('Data de Abertura: ' || sac_info.dt_abertura_sac);
        DBMS_OUTPUT.PUT_LINE('Hora de Abertura: ' || sac_info.hr_abertura_sac);
        DBMS_OUTPUT.PUT_LINE('Tipo do SAC: ' || sac_info.tp_sac);
        DBMS_OUTPUT.PUT_LINE('Código do Produto: ' || sac_info.cd_produto);
        DBMS_OUTPUT.PUT_LINE('Nome do Produto: ' || sac_info.ds_produto);
        DBMS_OUTPUT.PUT_LINE('Valor Unitário: ' || sac_info.vl_unitario);
        DBMS_OUTPUT.PUT_LINE('Percentual do Lucro: ' || sac_info.vl_perc_lucro);
        DBMS_OUTPUT.PUT_LINE('Número do Cliente: ' || sac_info.nr_cliente);
        DBMS_OUTPUT.PUT_LINE('Nome do Cliente: ' || sac_info.nm_cliente);
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    END LOOP;
END;
/