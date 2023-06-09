SELECT INVOICE_NO,
       OUT_TYPE_DIV,
       OUT_BOX_DIV,
       TO_NUMBER(SUBSTR(VAL, 12,10)) AS MAX_LINE_NO,
       TO_NUMBER(SUBSTR(VAL, 1,10)) AS MAX_ORDER_QTY
FROM(
     SELECT INVOICE_NO,
            OUT_TYPE_DIV,
            OUT_BOX_DIV
            ,(
              SELECT MAX(LPAD(ORDER_QTY,10,0)||'-'||LPAD(LINE_NO,10,'0'))
              FROM LO_OUT_D S1
              WHERE S1.INVOICE_NO = M1.INVOICE_NO
            ) AS VAL
     FROM LO_OUT_M M1
     WHERE OUTBOUND_DATE = '2019-06-03'
     AND OUTBOUND_NO BETWEEN 'D190603-897353' AND 'D190603-897360'
     )
     
     
SELECT INVOICE_NO
      ,OUT_TYPE_DIV
      ,OUT_BOX_DIV
      ,(
        SELECT 1
        FROM DUAL
       ) AS TEMP_VAL
      FROM LO_OUT_M M1
      WHERE OUTBOUND_DATE = '2019-06-03'
      AND OUTBOUND_NO  BETWEEN 'D190603-897353' AND 'D190603-897360';
      
--------------------------
SELECT  SYSDATE AS CUR_DATETIME
      , TRUNC(SYSDATE) AS CUR_DATE
      , SYSDATE + 1 AS TOMORROW
      , SUBSTR('ABCD1234', 1, 5) AS VAL1
      , SUBSTR(LPAD(34, 5, '0'),1,3) AS LEFT_PADDING1
      , SUBSTR(LPAD(34, 5, '0'),4,2) AS LEFT_PADDING2
FROM DUAL

-----------

SELECT  INVOICE_NO
      , OUT_TYPE_DIV
      , OUT_BOX_DIV
      , SUBSTR(OUT_TYPE_DIV, 2, 2) AS SUB_VAL
      , 1 AS VAL1
      , 'A' AS VAL2
      , OUT_TYPE_DIV || '-' || OUT_BOX_DIV AS AAA
      , LENGTH(INVOICE_NO) AS BBB
      , TO_CHAR(OUTBOUND_DATE, 'YYYY-MM') AS CCC
      , TO_CHAR(OUTBOUND_DATE, 'YYYYMM') AS DDD
      , TO_CHAR(OUTBOUND_DATE, 'YY-MM') AS EEE
      , TO_CHAR(OUTBOUND_DATE, 'MM-DD') AS FFF
      , TO_CHAR(OUTBOUND_DATE, 'WW') AS GGG    -- 몇 주차인지
      , TO_CHAR(OUTBOUND_DATE, 'Q') AS HHH -- 몇 분기인지
FROM LO_OUT_M M1
WHERE OUTBOUND_DATE = '2019-06-03'
AND OUTBOUND_NO  BETWEEN 'D190603-897353' AND 'D190603-897360';

-------------------
SELECT INVOICE_NO
      ,OUT_TYPE_DIV
      ,OUT_BOX_DIV
      ,(
        SELECT MAX(LPAD(ORDER_QTY, 3, '0') || '-' || LPAD(LINE_NO, 3, '0')) AS MAX_VAL
        FROM LO_OUT_D S1
        WHERE S1.INVOICE_NO = M1.INVOICE_NO
       ) AS VAL
      FROM LO_OUT_M M1
      WHERE OUTBOUND_DATE = '2019-06-03'
      AND OUTBOUND_NO  BETWEEN 'D190603-897353' AND 'D190603-897360';
      
      SELECT MAX(LPAD(ORDER_QTY, 3, '0') || LPAD(LINE_NO, 3, '0')) AS MAX_VAL
        FROM LO_OUT_D S1
        WHERE S1.INVOICE_NO = '346724738226'
        
        
-- DAY7 P8  [브랜드] & [상품]별 주문수량 합계를 표시하되, 상품명과 입수는 스칼라쿼리와 인라인뷰를 이용해 표시해 줘!
SELECT BRAND_CD
     , ITEM_CD
     , SUM(ORDER_QTY) AS SUM_ORDER_QTY
     , (
        SELECT ITEM_NM
        FROM A_ITEM S1
        WHERE S1.ITEM_CD = M1.ITEM_CD
        AND S1.BRAND_CD = M1.BRAND_CD
      ) AS ITEM_NM
     , (
        SELECT QTY_IN_BOX
        FROM A_ITEM S1
        WHERE S1.ITEM_CD = M1.ITEM_CD
        AND S1.BRAND_CD = M1.BRAND_CD
      ) AS QTY_IN_BOX
FROM A_OUT_D M1
GROUP BY BRAND_CD, ITEM_CD
ORDER BY BRAND_CD, ITEM_CD;
-----------------------------------

SELECT BRAND_CD
     , ITEM_CD
     , SUM_ORDER_QTY
     , SUBSTR(VAL, 8, 5) AS ITEM_NM
     , TO_NUMBER(SUBSTR(VAL, 1, 1)) AS QTY_IN_BOX
FROM (
      SELECT BRAND_CD
           , ITEM_CD
           , SUM(ORDER_QTY) AS SUM_ORDER_QTY
           ,( SELECT LPAD(QTY_IN_BOX, 1,'0')||'-'||LPAD(ITEM_NM,10,0)
              FROM A_ITEM S1
              WHERE S1.ITEM_CD = M1.ITEM_CD
              AND S1.BRAND_CD = M1.BRAND_CD
            ) AS VAL
     FROM A_OUT_D M1
     GROUP BY BRAND_CD, ITEM_CD
     ORDER BY BRAND_CD, ITEM_CD
     )

-----------------------
SELECT M1.BRAND_CD
     , M1.ITEM_CD
     , ITEM_NM
     , QTY_IN_BOX
     , SUM(ORDER_QTY) AS SUM_ORDER_QTY
  FROM A_OUT_D M1, A_ITEM S1
HAVING M1.ITEM_CD = S1.ITEM_CD 
   AND M1.BRAND_CD = S1.BRAND_CD
 GROUP BY M1.BRAND_CD
        , M1.ITEM_CD
        , ITEM_NM
        , QTY_IN_BOX
 ORDER BY M1.BRAND_CD, M1.ITEM_CD; 
-----------------------------------

SELECT M1.BRAND_CD
      ,M1.ITEM_CD
      ,C1.ITEM_NM
      ,C1.QTY_IN_BOX
      ,SUM(M1.ORDER_QTY)
FROM A_OUT_D M1
     JOIN A_ITEM C1 ON C1.BRAND_CD = M1.BRAND_CD
      AND C1.ITEM_CD = M1.ITEM_CD
GROUP BY M1.BRAND_CD, M1.ITEM_CD, C1.ITEM_NM, C1.QTY_IN_BOX
ORDER BY M1.BRAND_CD, M1.ITEM_CD;
--------------------------------

SELECT L1.BRAND_CD
      ,L1.ITEM_CD
      ,L1.SUM_QTY
      ,(
       SELECT S1.ITEM_NM
       FROM A_ITEM S1
       WHERE S1.BRAND_CD = L1.BRAND_CD
       AND S1.ITEM_CD = L1.ITEM_CD      
      )AS VAL1
     ,(
       SELECT S1.QTY_IN_BOX
       FROM A_ITEM S1
       WHERE S1.BRAND_CD = L1.BRAND_CD
       AND S1.ITEM_CD = L1.ITEM_CD
     ) AS VAL2
FROM (
      SELECT M1.BRAND_CD
            ,M1.ITEM_CD
            ,SUM(M1.ORDER_QTY) AS SUM_QTY
        FROM A_OUT_D M1
       GROUP BY M1.BRAND_CD, M1.ITEM_CD
       ORDER BY M1.BRAND_CD, M1.ITEM_CD
    ) L1;

-----------------------------------
--4) 박스입수와 상품명을 분리함
SELECT BRAND_CD, ITEM_CD, SUM_QTY, SUBSTR(VAL,4) AS ITEM_NM, TO_NUMBER(SUBSTR(VAL,1,3)) AS QTY_IN_BOX   
FROM ( -- 3)  박스입수와 상품명을 연결하여 하나의 컬럼으로 가져옴
      SELECT L1.BRAND_CD
            ,L1.ITEM_CD
            ,L1.SUM_QTY
            ,( --2) 상품명과 박스입수를 가져오는 스칼라쿼리
             SELECT LPAD(S1.QTY_IN_BOX, 3, '0') || S1.ITEM_NM
             FROM A_ITEM S1
             WHERE S1.BRAND_CD = L1.BRAND_CD
             AND S1.ITEM_CD = L1.ITEM_CD      
            )AS VAL
      FROM ( --1) 브랜드/상품별 주문수량 합계를 구함
            SELECT M1.BRAND_CD
                  ,M1.ITEM_CD
                  ,SUM(M1.ORDER_QTY) AS SUM_QTY
              FROM A_OUT_D M1
             GROUP BY M1.BRAND_CD, M1.ITEM_CD
             ORDER BY M1.BRAND_CD, M1.ITEM_CD
          ) L1
     );

---------------------------------------


SELECT BRAND_CD, ITEM_CD, ITEM_NM, SUM_QTY, QTY_IN_BOX
      , TRUNC(SUM_QTY/QTY_IN_BOX) AS BOX_CNT
      , MOD(SUM_QTY,QTY_IN_BOX) AS PCS_CNT
FROM (
      SELECT BRAND_CD, ITEM_CD, SUM_QTY, SUBSTR(VAL,4) AS ITEM_NM, TO_NUMBER(SUBSTR(VAL,1,3)) AS QTY_IN_BOX   
      FROM ( -- 3)  박스입수와 상품명을 연결하여 하나의 컬럼으로 가져옴
            SELECT L1.BRAND_CD
                  ,L1.ITEM_CD
                  ,L1.SUM_QTY
                  ,( --2) 상품명과 박스입수를 가져오는 스칼라쿼리
                   SELECT LPAD(S1.QTY_IN_BOX, 3, '0') || S1.ITEM_NM
                   FROM A_ITEM S1
                   WHERE S1.BRAND_CD = L1.BRAND_CD
                   AND S1.ITEM_CD = L1.ITEM_CD      
                  )AS VAL
            FROM ( --1) 브랜드/상품별 주문수량 합계를 구함
                  SELECT M1.BRAND_CD
                        ,M1.ITEM_CD
                        ,SUM(M1.ORDER_QTY) AS SUM_QTY
                    FROM A_OUT_D M1
                   GROUP BY M1.BRAND_CD, M1.ITEM_CD
                   ORDER BY M1.BRAND_CD, M1.ITEM_CD
                ) L1
           )
     )
ORDER BY BOX_CNT DESC;
     
----------위의 결과에 인라인뷰를 적용하여 박스수가 가장 많은 TOP3만 표시해 줘!
SELECT *
FROM (SELECT BRAND_CD, ITEM_CD, ITEM_NM, SUM_QTY, QTY_IN_BOX
      , TRUNC(SUM_QTY/QTY_IN_BOX) AS BOX_CNT
      , MOD(SUM_QTY,QTY_IN_BOX) AS PCS_CNT
      FROM (
            SELECT BRAND_CD, ITEM_CD, SUM_QTY, SUBSTR(VAL,4) AS ITEM_NM, TO_NUMBER(SUBSTR(VAL,1,3)) AS QTY_IN_BOX   
            FROM ( -- 3)  박스입수와 상품명을 연결하여 하나의 컬럼으로 가져옴
                  SELECT L1.BRAND_CD
                        ,L1.ITEM_CD
                        ,L1.SUM_QTY
                        ,( --2) 상품명과 박스입수를 가져오는 스칼라쿼리
                         SELECT LPAD(S1.QTY_IN_BOX, 3, '0') || S1.ITEM_NM
                         FROM A_ITEM S1
                         WHERE S1.BRAND_CD = L1.BRAND_CD
                         AND S1.ITEM_CD = L1.ITEM_CD      
                        )AS VAL
                  FROM ( --1) 브랜드/상품별 주문수량 합계를 구함
                        SELECT M1.BRAND_CD
                              ,M1.ITEM_CD
                              ,SUM(M1.ORDER_QTY) AS SUM_QTY
                          FROM A_OUT_D M1
                         GROUP BY M1.BRAND_CD, M1.ITEM_CD
                         ORDER BY M1.BRAND_CD, M1.ITEM_CD
                      ) L1
                 )
           )
     ORDER BY BOX_CNT DESC
     )
WHERE ROWNUM <= 3;

--------------DAY7 P9

SELECT ITEM_CD
     , (
        SELECT ITEM_NM
          FROM CM_ITEM S1
         WHERE S1.ITEM_CD = M1.ITEM_CD
       ) AS ITEM_NM
     , SUM(ORDER_QTY)
  FROM LO_OUT_D M1
 WHERE INVOICE_NO BETWEEN 346724706262 AND 346724706762
 GROUP BY ITEM_CD
 ORDER BY ITEM_CD;
 
--------------------

SELECT ITEM_CD
     , (
        SELECT ITEM_NM
          FROM CM_ITEM S1
         WHERE S1.ITEM_CD = M1.ITEM_CD
       ) AS ITEM_NM
     , ORDER_QTY
FROM (
       SELECT ITEM_CD, SUM(ORDER_QTY) AS ORDER_QTY
         FROM LO_OUT_D M1
        WHERE INVOICE_NO BETWEEN 346724706262 AND 346724706762
        GROUP BY ITEM_CD
        ORDER BY ITEM_CD
     ) M1
 
                


------------------------DAY 7 P10
SELECT ROWNUM
     , ITEM_CD
     , QTY_IN_BOX
     , ORDER_QTY
     , TRUNC(ORDER_QTY/QTY_IN_BOX) AS BOX_CNT
     , MOD(ORDER_QTY,QTY_IN_BOX) AS PCS_CNT
     , CEIL(ORDER_QTY/QTY_IN_BOX) AS BOX_CNT_TOT
  FROM (
        SELECT ITEM_CD
             , QTY_IN_BOX
             , SUM(ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_D
         WHERE INVOICE_NO BETWEEN 346724706262 AND 346724706762
         GROUP BY ITEM_CD, QTY_IN_BOX
         ORDER BY ORDER_QTY DESC
        ) L1
 WHERE ROWNUM <= 5;

SELECT ITEM_CD, QTY_IN_BOX, ORDER_QTY
      ,TRUNC(ORDER_QTY / QTY_IN_BOX)   AS BOX_CNT
      ,MOD(ORDER_QTY, QTY_IN_BOX)      AS PCS_CNT
      ,CEIL(ORDER_QTY / QTY_IN_BOX)    AS BOX_CNT_TOT
  FROM (
         SELECT ITEM_CD, QTY_IN_BOX, SUM(ORDEr_QTY) AS ORDER_QTY
           FROM LO_OUT_D
          WHERE INVOICE_NO BETWEEN 346724706262 AND 346724706762
          GROUP BY ITEM_CD, QTY_IN_BOX
          ORDER BY ORDER_QTY DESC
       )
  WHERE ROWNUM <= 5;