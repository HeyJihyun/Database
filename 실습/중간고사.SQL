
-- 하이테크 김지현
-- 중간고사 문제1. 월별 집계 구하기
SELECT TO_CHAR(OUTBOUND_DATE, 'YYYY-MM') AS OUT_DATE, 
       COUNT(INVOICE_NO)                 AS INV_CNT, 
       SUM(SET_QTY)                      AS SET_QTY
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-06-01' AND '2019-08-31'
 GROUP BY TO_CHAR(OUTBOUND_DATE, 'YYYY-MM')
 ORDER BY OUT_DATE;
 
-- 중간고사 문제2. 상황에 따른 정렬하기
SELECT OUT_TYPE_DIV, SUM(ORDER_QTY) AS SUM_QTY
  FROM LO_OUT_M M1 
       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
 WHERE OUTBOUND_DATE = '2019-09-03'
 GROUP BY OUT_TYPE_DIV
HAVING SUM(ORDER_QTY) >= 5000
 ORDER BY CASE WHEN OUT_TYPE_DIV LIKE 'M1%' THEN SUM_QTY END,
          CASE WHEN OUT_TYPE_DIV LIKE 'M2%' THEN SUM_QTY END DESC;
          
-- 중간고사 문제3. 상황에 따른 정렬하기
SELECT CASE WHEN ROWNUM <= 10 THEN TO_CHAR(OUT_DATE,'YYYY-MM-DD') ELSE 'ETC' END AS OUT_DATE,
       CASE WHEN ROWNUM <= 10 THEN ITE_CD                         ELSE ' '  END AS_ITE_CD,
       CASE WHEN ROWNUM <= 10 THEN ITEM_NM                        ELSE ' '  END AS ITEM_NM,
       SUM(SUM_QTY)                                                              AS SUM_QTY
  FROM (
        SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
               OUTBOUND_DATE AS OUT_DATE, 
               ITEM_CD       AS ITE_CD, 
               ITEM_NM, 
               SUM(ORDER_QTY) AS SUM_QTY
          FROM LO_OUT_M M1 
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO   =   M1.INVOICE_NO
         WHERE OUTBOUND_DATE BETWEEN '2019-06-01' AND '2019-06-30'
           AND ITEM_NM       LIKE    '%참치%'
         GROUP BY OUTBOUND_DATE, 
                  ITEM_CD, 
                  ITEM_NM
         ORDER BY SUM_QTY DESC
       )
  GROUP BY CASE WHEN ROWNUM <= 10 THEN TO_CHAR(OUT_DATE,'YYYY-MM-DD') ELSE 'ETC' END,
           CASE WHEN ROWNUM <= 10 THEN ITE_CD ELSE ' ' END,
           CASE WHEN ROWNUM <= 10 THEN ITEM_NM ELSE ' ' END
  ORDER BY CASE WHEN OUT_DATE != 'ETC' THEN 1 ELSE 2 END, 
           SUM_QTY DESC;
          
-- 중간고사 문제4. 구구단 결과 구하기

SELECT DAN || '단'                          AS DAUNSU, 
       DAN || 'x' || NO || '=' || DAN * NO  AS CONTENTS
  FROM (
        SELECT NO
          FROM CS_NO
         WHERE NO BETWEEN 1 AND 9
        ),(
        SELECT NO AS DAN
          FROM CS_NO
         WHERE NO BETWEEN 2 AND 9
      )
ORDER BY DAN,NO;

SELECT M2.NO || '단'                                   AS DAUNSU, 
       M2.NO || 'x' || M1.NO || '=' || M2.NO * M1.NO  AS CONTENTS
  FROM CS_NO M1, CS_NO M2
 WHERE M1.NO <= 9 AND M2.NO BETWEEN 2 AND 9;
