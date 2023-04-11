-- DAY14. 실전문제1
SELECT M1.DAYY, OUTBOUND_DATE, MAX_QTY
   FROM (
          SELECT TO_CHAR(OUTBOUND_DATE, 'DY') AS DAYY,
                 MAX(SUM_QTY) AS MAX_QTY
           FROM( --+ ORDERED USE_NL(D) INDEX(D LO_OUT_D_IDXPK)
                 SELECT OUTBOUND_DATE, SUM(ORDER_QTY) AS SUM_QTY
                  FROM LO_OUT_M M JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
                 WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-9-30'
                 GROUP BY OUTBOUND_DATE
                 ORDER BY OUTBOUND_DATE
               )
          GROUP BY TO_CHAR(OUTBOUND_DATE, 'DY')
        ) M1 
   JOIN (
         SELECT OUTBOUND_DATE, SUM(ORDER_QTY) AS SUM_QTY
           FROM LO_OUT_M M JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
          WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-9-30'
          GROUP BY OUTBOUND_DATE
        ) M2 ON TO_CHAR(OUTBOUND_DATE,'DY') = M1.DAYY AND M1.MAX_QTY = M2.SUM_QTY
 ORDER BY TO_CHAR(OUTBOUND_DATE,'D');
 
 
 ------------------------
 SELECT DAYY, TO_DATE(SUBSTR(ORDER_QTY,11)) AS OUTBOUND_DATE, TO_NUMBER(SUBSTR(ORDER_QTY,1,10)) AS ORDER_QTY
   FROM (
         SELECT DAYY, MAX(SUM_QTY) AS ORDER_QTY
           FROM (
                  SELECT --+ ORDERED USE_NL(D) INDEX(D LO_OUT_D_IDXPK)
                         TO_CHAR(OUTBOUND_DATE,'DY') AS DAYY,
                         OUTBOUND_DATE, 
                         (LPAD(SUM(ORDER_QTY),10,0) || TO_CHAR(OUTBOUND_DATE,'YYYYMMDD')) AS SUM_QTY
                    FROM LO_OUT_M M JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
                   WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-9-30'
                   GROUP BY OUTBOUND_DATE
                )
         GROUP BY DAYY
         )
  ORDER BY TO_CHAR(OUTBOUND_DATE,'D');

 
-------------------------------
-- DAY14. 실전문제2
SELECT MAX(ORDER_QTY), MIN(ORDER_QTY), ROUND(AVG(ORDER_QTY))
  FROM (
        SELECT  --+ ORDERED USE_NL(D) INDEX(D LO_OUT_D_IDXPK)
                OUTBOUND_DATE,
                SUM(ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_M M JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
         WHERE OUTBOUND_DATE IN (
                                 SELECT *
                                   FROM (
                                         SELECT TO_DATE('2019-09-03') + NO-1 AS OUTBOUND_DATE
                                           FROM CS_NO
                                           WHERE NO <= 30
                                          ) M1
                                   WHERE EXISTS (SELECT 1
                                                   FROM LO_OUT_M S1
                                                  WHERE S1.OUTBOUND_DATE = M1.OUTBOUND_DATE
                                                 )
                                     AND ROWNUM <= 7
                                 )           
         GROUP BY OUTBOUND_DATE  
       );

 SELECT ITEM_CD, SUBSTR(VAL, 4, 8) AS MAX_DATE, SUBSTR(VAL, 1,3) AS MAX_BATCH 
   FROM (
         SELECT --+ ORDERED USE_NL(D) INDEX(D LO_OUT_D_IDXPK)
                 ITEM_CD, MAX(OUTBOUND_BATCH || OUTBOUND_DATE) AS VAL
            FROM LO_OUT_M M 
                 JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
           WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-19'
             AND ITEM_CD IN ('30500', '73510')
           GROUP BY ITEM_CD      
        ) ;
   
  SELECT ITEM_CD, TO_DATE(SUBSTR(VAL, 4, 8)) AS MAX_DATE, SUBSTR(VAL, 1,3) AS MAX_BATCH 
   FROM (             
          SELECT --+ ORDERED USE_NL(D) INDEX(D LO_OUT_D_IDXPK)
                 ITEM_CD, 
                 CASE MIN(OUTBOUND_BATCH) WHEN '001' 
                      THEN MIN(OUTBOUND_BATCH || OUTBOUND_DATE) 
                      ELSE MAX(OUTBOUND_BATCH || OUTBOUND_DATE) 
                 END AS VAL
            FROM LO_OUT_M M 
                 JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
           WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-19'
             AND ITEM_CD IN ('30500', '73510')
           GROUP BY ITEM_CD
        );
        
     
  SELECT ITEM_CD, 
         TO_DATE(SUBSTR(VAL, 4, 8)) AS MAX_DATE, 
         CASE WHEN VAL1 IS NOT NULL THEN VAL1 ELSE SUBSTR(VAL, 1,3) END AS MAX_BATCH 
   FROM (             
          SELECT --+ ORDERED USE_NL(D) INDEX(D LO_OUT_D_IDXPK)
                 ITEM_CD, 
                 MAX(CASE WHEN OUTBOUND_BATCH = '001' THEN OUTBOUND_BATCH ELSE NULL END) AS VAL1,
                 MAX(OUTBOUND_BATCH || OUTBOUND_DATE) AS VAL
            FROM LO_OUT_M M 
                 JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
           WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-19'
             AND ITEM_CD IN ('30500', '73510')
           GROUP BY ITEM_CD
        );
        
        
------------------------------
-- DAY14. 실전문제4
SELECT WEEK_OF_YEAR, ORDER_QTY,
       CASE WHEN ORDER_QTY >= 900000 THEN 'A'
            WHEN ORDER_QTY >= 800000 THEN 'B'
            WHEN ORDER_QTY >= 700000 THEN 'C'
            WHEN ORDER_QTY >= 600000 THEN 'D'
            ELSE 'F'
      END AS GRADE
  FROM(
       SELECT --+ ORDERED USE_NL(D) INDEX(D LO_OUT_D_IDXPK)
              TO_CHAR(OUTBOUND_DATE, 'IW') AS WEEK_OF_YEAR,
              SUM(ORDER_QTY)               AS ORDER_QTY
         FROM LO_OUT_M M 
              JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
        WHERE OUTBOUND_DATE BETWEEN '2019-01-31' AND '2019-12-31'
        GROUP BY TO_CHAR(OUTBOUND_DATE, 'IW')
        ORDER BY WEEK_OF_YEAR
  );
  
  -------------
  SELECT L1.*, TO_NUMBER(BAY_CD) + TO_NUMBER(LEV_CD) AS VAL1
    FROM V_LOC L1
   ORDER BY VAL1, LEV_CD;
   
    -------------
  SELECT L1.*, TO_NUMBER(BAY_CD) - TO_NUMBER(L1.LEV_CD) AS VAL1
    FROM V_LOC L1
   ORDER BY VAL1 DESC, LEV_CD;