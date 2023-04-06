 -- DAY8. P10
 SELECT SYSDATE FROM DUAL;
 
 SELECT OUTBOUND_DATE
       ,EXTRACT(YEAR  FROM OUTBOUND_DATE) AS OUT_YEAR
       ,EXTRACT(MONTH FROM OUTBOUND_DATE) AS OUT_MONTH
       ,EXTRACT(DAY   FROM OUTBOUND_DATE) AS OUT_DATE
   FROM LO_OUT_M;
  
 SELECT SYSDATE            AS TODAY_DATETIME
       ,SYSDATE + 1        AS TOMORROW_DATETIME
       ,TRUNC(SYSDATE)     AS TODAY_DATE
       ,TRUNC(SYSDATE) + 1 AS TOMORROW_DATE
  FROM DUAL;
  
 -- DAY8. P11
 SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD')    AS DAY1
       ,TO_CHAR(SYSDATE, 'YYYY.MON.DAY')  AS DAY2
   FROM DUAL;
   
 SELECT TO_CHAR(123456789/1200, '$999,999,999.99') AS DOLLAR
       ,TO_CHAR(123456789,'L999,999,999') AS WON
   FROM DUAL;

 -- DAY8. P13
 SELECT PAY, BONUS, (PAY * 12 + BONUS) AS SALARY
   FROM (
         SELECT 1000 AS PAY, 100 AS BONUS FROM DUAL
         UNION ALL
         SELECT 1000 AS PAY, 0 AS BONUS FROM DUAL
         UNION ALL
         SELECT 1000 AS PAY, NULL AS BONUS FROM DUAL
        )
        
 
 SELECT PAY, BONUS, (PAY * 12 + NVL(BONUS,0)) AS SALARY
   FROM (
         SELECT 1000 AS PAY, 100 AS BONUS FROM DUAL
         UNION ALL
         SELECT 1000 AS PAY, 0 AS BONUS FROM DUAL
         UNION ALL
         SELECT 1000 AS PAY, NULL AS BONUS FROM DUAL
        );
        
 -- DAY8. P14       
 SELECT NVL(NULL, 'SKPANG') FROM DUAL WHERE 1 = 1;
 SELECT NVL(NULL, 'SKPANG') FROM DUAL WHERE 1 = 2; 
  -- 상단 NULL값이 있는 집합, 하단 공집합. 공집합은 나타나지 않음
 
 SELECT NVL(MAX(NULL), 'HELLO') AS VAL
   FROM DUAL
  WHERE 1 = 2;
  
 -- 집계함수를 사용하면 공집합이여도 집합이 생겨남
 SELECT MAX(NULL)
   FROM DUAL
  WHERE 1 = 2;
 
 SELECT NVL(MIN('Y'), 'N') AS EXIST_YN
   FROM LO_OUT_M
  WHERE OUTBOUND_DATE = '2015-06-03'
    AND ROWNUM = 1;
    
 SELECT MAX(ITEM_WEIGHT)                                AS MAX_WEIGHT
       ,MIN(ITEM_WIDTH)                                 AS MIN_WIDTH
       ,ROUND(AVG(ITEM_LENGTH), 2)                      AS AVG_LENGTH
       ,TO_CHAR(COUNT(*) , '999,999,999')               AS COUNT1
       ,TO_CHAR(COUNT(INSPECT_DATETIME), '999,999,999') AS COUNT2
   FROM LO_OUT_D;
   
 SELECT ITEM_CD AS ITEM_CD ,ITEM_NM AS ITEM_NM
       ,COUNT(*) AS CNT ,SUM(ORDER_QTY) AS SUM_QTY
       ,ROUND(AVG(ORDER_QTY), 2) AS AVG_QTY ,MAX(ORDER_QTY) AS MAX_QTY
       ,MIN(ORDER_QTY) AS MIN_QTY ,ROUND(STDDEV(ORDER_QTY), 2) AS STDDEV_QTY
  FROM LO_OUT_D
 GROUP BY ITEM_CD, ITEM_NM
HAVING MIN(ORDER_QTY) > 0
   AND MAX(ORDER_QTY) <= 50
ORDER BY ITEM_CD;  


-- DAY8. P17
 SELECT OUTBOUND_DATE
       ,TO_CHAR(OUTBOUND_DATE, 'DAY') AS DY
       ,INVOICE_NO
       ,ORDER_NM
   FROM A_OUT_M
  WHERE BRAND_CD = 1001;

 SELECT OUTBOUND_DATE
       ,TO_CHAR(OUTBOUND_DATE, 'DAY') AS DY
       ,INVOICE_NO
       ,CASE WHEN MOD(TO_NUMBER(SUBSTR(INVOICE_NO,2)), 2) = 0 
             THEN '짝'
             ELSE '홀'
        END AS EVENODD
       ,ORDER_NM
   FROM A_OUT_M
  WHERE BRAND_CD = 1001;

-- DAY8. P18
-- 문제 1
 SELECT BRAND_CD, COUNT(*)
   FROM A_OUT_M
  GROUP BY BRAND_CD
  ORDER BY BRAND_CD;
 
-- 문제2
 SELECT BRAND_CD
       ,TO_CHAR(OUTBOUND_DATE, 'DY') AS DAY
       ,COUNT(*)
   FROM A_OUT_M
  GROUP BY BRAND_CD
       ,TO_CHAR(OUTBOUND_DATE, 'DY') 
       ,TO_CHAR(OUTBOUND_DATE, 'D')
  ORDER BY BRAND_CD, TO_CHAR(OUTBOUND_DATE, 'D')

-- 문제3
 SELECT BRAND_CD
       ,CASE MOD(TO_NUMBER(SUBSTR(INVOICE_NO, 2)), 2)  
             WHEN 0 
             THEN '짝' 
             ELSE '홀' 
        END AS EVENODD
       ,COUNT(DISTINCT INVOICE_NO) AS INV_CNT
       ,SUM(ORDER_QTY)
   FROM A_OUT_D
  GROUP BY BRAND_CD
       ,MOD(TO_NUMBER(SUBSTR(INVOICE_NO, 2)), 2)
  ORDER BY BRAND_CD, EVENODD;
  
 SELECT BRAND_CD
       ,EVENODD
       ,COUNT(DISTINCT INVOICE_NO) AS INV_CNT
       ,SUM(ORDER_QTY) AS SUM_QTY 
   FROM ( 
         SELECT BRAND_CD
             ,INVOICE_NO
             ,CASE MOD(TO_NUMBER(SUBSTR(INVOICE_NO, 2)), 2)  
                   WHEN 0 
                   THEN '짝' 
                   ELSE '홀' 
              END AS EVENODD
             ,ORDER_QTY
         FROM A_OUT_D
        )
   GROUP BY BRAND_CD
           ,EVENODD
   ORDER BY BRAND_CD
   

-- DAY8. P19 실전문제1 
 SELECT INVOICE_NO
       ,OUTBOUND_DATE
       ,TO_CHAR(OUTBOUND_DATE,'DAY') AS DAYY
       ,OUTBOUND_NO     
   FROM LO_OUT_M
  WHERE INVOICE_NO IN ('346724706214', '346724793596', '346724869970')
  ORDER BY OUTBOUND_DATE, INVOICE_NO;

-- DAY8. P20 실전문제2
 SELECT NVL(TO_CHAR(SUM(ORDER_QTY)), 'EMPTY..') AS ORDER_QTY
   FROM LO_OUT_D
 WHERE INVOICE_NO = '346724706215';
 
 SELECT order_qty
--  NVL(TO_CHAR(SUM(ORDER_QTY)), 'EMPTY..') AS ORDER_QTY
   FROM LO_OUT_D
  WHERE INVOICE_NO IN ('346724706214', '346724793596', '346724869970');
  
  
-- DAY9
 SELECT OUT_TYPE_DIV 
       ,DECODE(SUBSTR(OUT_TYPE_DIV, 1, 2)
              ,'M1', '상온'
              ,'M2', '냉장', '기타') AS TEMP
   FROM LO_OUT_M
 ORDER BY TEMP  ;
  
  
-- DAY9. P5 <<3>>
 SELECT CASE SUBSTR(OUT_TYPE_DIV, 1, 2)
             WHEN 'M1' THEN '상온'
             WHEN 'M2' THEN '냉장'
             ELSE '기타'
         END AS TEMP
        ,COUNT(*) AS CNT
   FROM LO_OUT_M
 WHERE OUTBOUND_DATE = '2019-06-03'
 GROUP BY CASE SUBSTR(OUT_TYPE_DIV, 1, 2)
             WHEN 'M1' THEN '상온'
             WHEN 'M2' THEN '냉장'
             ELSE '기타'
         END
 ORDER BY COUNT(*) DESC;
 
  SELECT CASE WHEN OUT_TYPE_DIV LIKE '%M1' THEN '상온'
             WHEN OUT_TYPE_DIV LIKE '%M2' THEN '냉장'
             ELSE '기타'
         END AS TEMP
        ,COUNT(*) AS CNT
   FROM LO_OUT_M
 WHERE OUTBOUND_DATE = '2019-06-03'
 GROUP BY CASE WHEN OUT_TYPE_DIV LIKE '%M1' THEN '상온'
             WHEN OUT_TYPE_DIV LIKE '%M2' THEN '냉장'
             ELSE '기타'
         END
 ORDER BY COUNT(*) DESC;
 

 SELECT DECODE(SUBSTR(OUT_TYPE_DIV, 1, 2), 'M1', '상온', 'M2', '냉장', '기타') AS TEMP
       ,COUNT(*) AS CNT
   FROM LO_OUT_M
 WHERE OUTBOUND_DATE = '2019-06-03'
 GROUP BY DECODE(SUBSTR(OUT_TYPE_DIV, 1, 2), 'M1', '상온', 'M2', '냉장', '기타')
 ORDER BY COUNT(*) DESC;

-- DAY9. P7 <<5>>
 SELECT OUTBOUND_DATE
       ,SET_QTY
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '01' THEN SET_QTY END AS M01
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '02' THEN SET_QTY END AS M02
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '03' THEN SET_QTY END AS M03
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '04' THEN SET_QTY END AS M04
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '05' THEN SET_QTY END AS M05
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '06' THEN SET_QTY END AS M06
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '07' THEN SET_QTY END AS M07
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '08' THEN SET_QTY END AS M08
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '09' THEN SET_QTY END AS M09
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '10' THEN SET_QTY END AS M10
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '11' THEN SET_QTY END AS M11
       ,CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '12' THEN SET_QTY END AS M12
FROM LO_OUT_M
WHERE OUTBOUND_DATE BETWEEN '20190101' AND '20191231';

SELECT OUTBOUND_DATE
      ,TO_CHAR(OUTBOUND_DATE, 'MM')
FROM LO_OUT_M
WHERE OUTBOUND_DATE BETWEEN '20190101' AND '20191231';

-- DAY9. P8
-- 문제1

  SELECT OUTBOUND_DATE
       ,INVOICE_NO
       ,TO_CHAR(OUTBOUND_DATE, 'DAY') AS DY
       ,CASE WHEN MOD(TO_NUMBER(SUBSTR(INVOICE_NO,2)), 2) = 0 
             THEN '짝'
             ELSE '홀'
        END AS EVENODD
       ,ORDER_NM
       ,OUT_TYPE_DIV
       ,CASE SUBSTR(OUT_TYPE_DIV, 1, 2)
             WHEN 'M1' THEN '상온'
             WHEN 'M2' THEN '냉장'
             ELSE '기타'
         END AS TEMP
   FROM A_OUT_M;
   
-- 문제2
 SELECT BRAND_CD
       ,INVOICE_NO
       ,LINE_NO
       ,ITEM_CD
       ,ORDER_QTY
       ,CASE 
         WHEN ORDER_QTY IN (1,2) THEN '하' 
         WHEN ORDER_QTY BETWEEN 3 AND 4 THEN '중' 
         WHEN ORDER_QTY >= 5 THEN '상'
        END AS GRADE
   FROM A_OUT_D
 ORDER BY GRADE;
 
-- DAY9.P9
-- 문제1
 SELECT BRAND_CD
       ,COUNT(*)
       ,DECODE(SUBSTR(OUT_TYPE_DIV, 1, 2), 'M1', '상온', 'M2', '냉장', '기타') AS TEMP
   FROM A_OUT_M
  GROUP BY BRAND_CD, DECODE(SUBSTR(OUT_TYPE_DIV, 1, 2), 'M1', '상온', 'M2', '냉장', '기타')
  ORDER BY BRAND_CD, TEMP;
 
-- 문제2
 SELECT BRAND_CD
--        ,INVOICE_NO
--        ,SUM_QTY
       ,CASE 
         WHEN SUM_QTY IN (1,2) THEN '하' 
         WHEN SUM_QTY BETWEEN 3 AND 4 THEN '중' 
         WHEN SUM_QTY >= 5 THEN '상'
        END AS GRADE
       ,COUNT(1) AS CNT
  FROM(
       SELECT BRAND_CD
            ,INVOICE_NO 
            ,SUM(ORDER_QTY) AS SUM_QTY
        FROM A_OUT_D
       GROUP BY BRAND_CD, INVOICE_NO
      )
  GROUP BY BRAND_CD
--          , INVOICE_NO
--          , SUM_QTY
         , CASE 
            WHEN SUM_QTY IN (1,2) THEN '하' 
            WHEN SUM_QTY BETWEEN 3 AND 4 THEN '중' 
            WHEN SUM_QTY >= 5 THEN '상'
           END
  ORDER BY BRAND_CD ;
  
-- 문제3
 SELECT CASE WHEN ROWNUM <=2 THEN ROWNUM           ELSE  0    END AS RNK
       ,CASE WHEN ROWNUM <=2 THEN ITEM_CD          ELSE 'ETC' END AS ITEM_CD
       ,SUM(SUM_QTY) AS SUM_QTY
   FROM (
         SELECT ITEM_CD, SUM(ORDER_QTY) AS SUM_QTY
           FROM A_OUT_D
          GROUP BY ITEM_CD
          ORDER BY SUM_QTY DESC
        )
 GROUP BY CASE WHEN ROWNUM <=2 THEN ROWNUM         ELSE 0     END
         ,CASE WHEN ROWNUM <=2 THEN ITEM_CD        ELSE 'ETC' END 
 ORDER BY CASE WHEN RNK !=  0 THEN 1 END, RNK;
 
-- DAY9.P10
-- 문제1
  SELECT BRAND_CD
       ,INVOICE_NO
       ,LINE_NO
       ,ITEM_CD
       ,ORDER_QTY
       ,CASE 
         WHEN ORDER_QTY IN (1,2) THEN '하' 
         WHEN ORDER_QTY BETWEEN 3 AND 4 THEN '중' 
         WHEN ORDER_QTY >= 5 THEN '상'
        END AS GRADE
   FROM A_OUT_D
  WHERE BRAND_CD = '1001'
 ORDER BY CASE WHEN ITEM_CD = 'C' THEN 1 ELSE 2 END, ITEM_CD, ORDER_QTY DESC;

-- DAY9.P11 실전문제 1
 SELECT OUTBOUND_DATE 
       ,COUNT(1) AS INOIVCE_CNT
       ,COUNT(M1_DIV) AS M1_CNT
       ,COUNT(M2_DIV) AS M2_CNT
   FROM (
         SELECT OUTBOUND_DATE
               ,CASE WHEN OUT_TYPE_DIV LIKE 'M1%' THEN OUT_TYPE_DIV ELSE NULL END AS M1_DIV
               ,CASE WHEN OUT_TYPE_DIV LIKE 'M2%' THEN OUT_TYPE_DIV ELSE NULL END AS M2_DIV
           FROM LO_OUT_M
          WHERE OUTBOUND_DATE BETWEEN TO_DATE(TO_CHAR(:TODAY, 'YYYYMM') || '01', 'YYYY-MM-DD') AND :TODAY
            AND OUT_BOX_DIV LIKE (CASE :COND
                                  WHEN 0 THEN '%'
                                  WHEN 1 THEN 'D%'
                                  WHEN 2 THEN 'F%'
                                  ELSE ''
                                  END
                                  )
     )
  GROUP BY OUTBOUND_DATE
       
 -- DAY9.P11 실전문제 1
 SELECT OUTBOUND_DATE 
       ,COUNT(1) AS INOIVCE_CNT
       ,COUNT(CASE WHEN OUT_TYPE_DIV LIKE 'M1%' THEN 1 END) AS M1_CNT
       ,COUNT(CASE WHEN OUT_TYPE_DIV LIKE 'M2%' THEN 1 END) AS M2_CNT      
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN TO_DATE(TO_CHAR(:TODAY, 'YYYYMM') || '01', 'YYYY-MM-DD') AND :TODAY
   AND OUT_BOX_DIV LIKE (CASE :COND
       WHEN 0 THEN '%'
       WHEN 1 THEN 'D%'
       WHEN 2 THEN 'F%'
       ELSE ''
       END
       )  
 GROUP BY OUTBOUND_DATE  
 ORDER BY OUTBOUND_DATE  
                    
 -- DAY9. P12 실전문제 2 
 SELECT ITEM_BAR_CD
       ,COUNT(DISTINCT ITEM_CD) AS ITEM_CNT
   FROM LO_OUT_D
  GROUP BY ITEM_BAR_CD
 HAVING COUNT(DISTINCT(ITEM_CD)) > 1 
  ORDER BY CASE WHEN ITEM_BAR_CD IS NOT NULL THEN 1 ELSE 2 END, ITEM_CNT DESC; 


 























