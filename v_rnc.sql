  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWU"."V_RNC" ("CD_EMPRESA", "NRO_RNC", "DT_RNC", "DIA_RNC", "MES_RNC", "ANO_RNC", "TRI_RNC", "ANOMES_RNC", "SEMANA_RNC", "EMITENTE", "AREA_EMITENTE", "CD_PRODUTO", "CD_VERSAO", "ID_PEDIDO", "CD_CLIENTE", "IT_PEDIDO", "NR_OP", "NR_NOTA", "NR_SERIE_NOTA", "CCUSTO_NAOCONFORME", "DESC_RNC", "CD_RECURSO", "CD_MOTIVO", "DESC_ACAO", "CD_ETAPA", "CD_TIPO", "CD_AVAL", "CD_ACAO_CORRETIVA", "ACAO_EFICAZ", "SITUACAO", "USUARIO", "TURNO", "QTDE_APARA", "ACAO_CORRETIVA", "QT_RNC_META", "TIPO_DADOS", "ORD", "CD_TURNO", "CD_CLIENTE_RED", "CD_CLIENTE_FILIAL", "CD_REPRESENTANTE", "CD_CLASSE", "CD_GRUPO", "CD_SUBGRUPO", "CD_FAMILIA") AS 
  
  select  isornc.empresa                                                                                                                    AS CD_EMPRESA,
          isornc.codigo                                                                                                                     AS NRO_RNC,
          to_char(isornc.data_rnc, 'DD/MM/YYYY')                                                                                            AS DT_RNC,
          to_char(isornc.data_rnc,'DD')                                                                                                     AS DIA_RNC,
          to_char(isornc.data_rnc,'MM')                                                                                                     AS MES_RNC,
          to_char(isornc.data_rnc,'YYYY')                                                                                                   AS ANO_RNC,
          to_char(isornc.data_rnc,'Q')                                                                                                      AS TRI_RNC,
          to_char(isornc.data_rnc,'YYYYMM')                                                                                                 AS ANOMES_RNC,
          to_char(isornc.data_rnc,'W')                                                                                                      AS SEMANA_RNC,
          isornc.emitente                                                                                                                   AS EMITENTE,
          isornc.area_emitente                                                                                                              AS AREA_EMITENTE,
          isornc.EMPRESA||'-'||isornc.produto                                                                                                                    AS CD_PRODUTO,
          isornc.versao                                                                                                                     AS CD_VERSAO,
          isornc.pedido                                                                                                                     AS ID_PEDIDO,
          (select max(cadcorr.codigo_matriz)
            from admin.cadcorr, admin.venpedido
          where cadcorr.codigo = venpedido.cliente
            and venpedido.empresa = isornc.empresa
            and venpedido.pedido = isornc.pedido)                                                                                         AS CD_CLIENTE,
          
          isornc.item_pedido                                                                                                                AS IT_PEDIDO,
          isornc.op                                                                                                                         AS NR_OP,
          isornc.nota                                                                                                                       AS NR_NOTA,
          isornc.serie_nota                                                                                                                 AS NR_SERIE_NOTA,
          isornc.setor_naoconforme                                                                                                          AS CCUSTO_NAOCONFORME,
          isornc.descricao                                                                                                                  AS DESC_RNC,
          isornc.recurso                                                                                                                    AS CD_RECURSO,
          isornc.motivo                                                                                                                     AS CD_MOTIVO,
          isornc.acao_imediata                                                                                                              AS DESC_ACAO,
          isornc.etapa                                                                                                                      AS CD_ETAPA,
          TRIM(isornc.tipo)                                                                                                                 AS CD_TIPO,
          isornc.avaliacao                                                                                                                  AS CD_AVAL,
          isornc.acao_corretiva                                                                                                             AS CD_ACAO_CORRETIVA,
          isornc.acao_eficaz                                                                                                                AS ACAO_EFICAZ,
          isornc.situacao                                                                                                                   AS SITUACAO,
          
          (select nvl(max(isorncdefeito.colaborador),0)
            from admin.isorncdefeito
          where empresa = isornc.empresa
            and rnc = isornc.codigo)                                                                                                      AS USUARIO,
          
          (select nvl(max(isorncdefeito.turno),'0')
            from admin.isorncdefeito
          where empresa = isornc.empresa
            and rnc = isornc.codigo)                                                                                                       AS TURNO,                                                                                             
          
          (select nvl(SUM(isorncdefeito.QUANTIDADE),'0')
            from admin.isorncdefeito
          where empresa = isornc.empresa
            and rnc = isornc.codigo)  AS QTDE_APARA,
          
          (select nvl(max(isorncdefeito.acao_corretiva),'0')
            from admin.isorncdefeito
          where empresa = isornc.empresa
            and rnc = isornc.codigo)  AS ACAO_CORRETIVA,
             0                                                                                                                              AS QT_RNC_META,
             'REAL'                                                                                                                         AS TIPO_DADOS,
             isornc.empresa                                                                                                                 AS ORD,
          
          (select nvl(max(isorncdefeito.turno),'0')
            from admin.isorncdefeito
          where empresa = isornc.empresa
            and rnc = isornc.codigo)                                                                                                       AS CD_TURNO,
          
          (select max(cadcorr.codigo_matriz)
            from admin.cadcorr, admin.venpedido
          where cadcorr.codigo = venpedido.cliente
            and venpedido.empresa = isornc.empresa
            and venpedido.pedido = isornc.pedido)                                                                                         AS CD_CLIENTE_RED,
          
          (select max(venpedido.cliente)
            from admin.venpedido
          where venpedido.empresa = isornc.empresa
            and venpedido.pedido = isornc.pedido)                                                                                         AS CD_CLIENTE_FILIAL,
          
          (select '1-'||max(venpedido.vendedor)
            from admin.venpedido
          where venpedido.empresa = isornc.empresa
            and venpedido.pedido = isornc.pedido)                                                                                         AS CD_REPRESENTANTE,      
           ITEM.EMPRESA||'-'||TRIM(ITEM.CLASSE_PRODUTO)                                                                                                            AS CD_CLASSE,
           TRIM(ITEM.EMPRESA||'-'||ITEM.GRUPO)                                                                                                         AS CD_GRUPO, 
           TRIM(ITEM.EMPRESA||'-'||ITEM.GRUPO||'-'||ITEM.SUBGRUPO)                                                                                     AS CD_SUBGRUPO,
           TRIM(ITEM.EMPRESA||'-'||ITEM.FAMILIA)                                                                                                       AS CD_FAMILIA

   from admin.isornc 
   
   INNER JOIN ADMIN.ESTITEM ITEM 
    ON ITEM.EMPRESA(+) = isornc.EMPRESA AND ITEM.CODIGO(+) = isornc.PRODUTO
   /*LEFT JOIN VM_CAD_RNC_META MET
        ON  ANO_META  = to_char(isornc.data_rnc,'YYYY')
        AND MES_META = to_char(isornc.data_rnc,'MM')
        AND CCUSTO_NAOCONFORME = isornc.setor_naoconforme*/

    where isornc.empresa = 1
      and to_char(isornc.data_rnc,'YYYY') in ('2018', '2019', '2020', '2021', '2022', '2023')
      and isornc.codigo = '60944'

      UNION ALL

      select 
         0                                                                                                                                 AS CD_EMPRESA,
         0                                                                                                                                 AS NRO_RNC,
         '01/'||MES_META||'/'||ANO_META                                                                                                    AS DT_RNC,
         '01'                                                                                                                              AS DIA_RNC,
         MES_META                                                                                                                          AS MES_RNC,
         ANO_META                                                                                                                          AS ANO_RNC,
         NULL                                                                                                                              AS TRI_RNC,
         ANO_META||MES_META                                                                                                                AS ANOMES_RNC,
         NULL                                                                                                                              AS SEMANA_RNC,
         0                                                                                                                                 AS EMITENTE,
         NULL                                                                                                                              AS AREA_EMITENTE,
         NULL                                                                                                                              AS CD_PRODUTO,
         NULL                                                                                                                              AS CD_VERSAO,
         0                                                                                                                                 AS ID_PEDIDO,
         0                                                                                                                                 AS CD_CLIENTE,
         0                                                                                                                                 AS IT_PEDIDO,
         0                                                                                                                                 AS NR_OP,
         0                                                                                                                                 AS NR_NOTA,
         NULL                                                                                                                              AS NR_SERIE_NOTA,
         CCUSTO_NAOCONFORME                                                                                                                AS CCUSTO_NAOCONFORME,
         NULL                                                                                                                              AS DESC_RNC,
         0                                                                                                                                 AS CD_RECURSO,
         0                                                                                                                                 AS CD_MOTIVO,
         NULL                                                                                                                              AS DESC_ACAO,
         0                                                                                                                                 AS CD_ETAPA,
         CD_TIPO                                                                                                                                 AS CD_TIPO,
         0                                                                                                                                 AS CD_AVAL,
         NULL                                                                                                                              AS CD_ACAO_CORRETIVA,
         NULL                                                                                                                              AS ACAO_EFICAZ,
         NULL                                                                                                                              AS SITUACAO,
         0                                                                                                                                 AS USUARIO,
         NULL                                                                                                                              AS TURNO,
         0                                                                                                                                 AS QTDE_APARA,
         NULL                                                                                                                              AS ACAO_CORRETIVA,
         QT_RNC_META,
        'META'                                                                                                                             AS TIPO_DADOS,
        0                                                                                                                                  AS ORD,
        NULL                                                                                                                               AS CD_TURNO,
        0                                                                                                                                  AS CD_CLIENTE_RED,
        NULL                                                                                                                               AS CD_CLIENTE_FILIAL,
        NULL                                                                                                                               AS CD_REPRESENTANTE,      
        NULL                                                                                                                               AS CD_CLASSE,
        NULL                                                                                                                               AS CD_GRUPO, 
        NULL                                                                                                                               AS CD_SUBGRUPO,
        NULL                                                                                                                               AS CD_FAMILIA      

   from VM_CAD_RNC_META;
