CREATE MATERIALIZED VIEW cust_of_the_yr_mv
PCTFREE 5
BUILD IMMEDIATE
REFRESH COMPLETE
ENABLE QUERY REWRITE
AS
SELECT cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, SUM(s.amount_sold) as Revenue
FROM DWU320.customers cu
JOIN DWU320.sales s ON s.cust_id = cu.cust_id
JOIN DWU320.times t ON t.time_id = s.time_id
GROUP BY cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year;





-- SELECT main.country_name, main.prod_category, main.prod_name, main.cust_first_name, main.cust_last_name, main.end_of_cal_year, main.Revenue
-- FROM (
--   SELECT c.country_name, p.prod_category, p.prod_name, sub.cust_first_name, sub.cust_last_name, sub.end_of_cal_year, sub.Revenue
--   FROM (
--     SELECT cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, SUM(s.amount_sold) AS Revenue
--     FROM DWU320.customers cu
--     JOIN DWU320.sales s ON s.cust_id = cu.cust_id
--     JOIN DWU320.times t ON t.time_id = s.time_id
--     GROUP BY cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year
--   ) sub
--   JOIN DWU320.customers cu ON cu.cust_first_name = sub.cust_first_name AND cu.cust_last_name = sub.cust_last_name
--   JOIN DWU320.sales s ON s.cust_id = cu.cust_id
--   JOIN DWU320.times t ON t.time_id = s.time_id
--   JOIN DWU320.products p ON p.prod_id = s.prod_id
--   JOIN DWU320.countries c ON c.country_id = cu.country_id
--   WHERE c.country_name = 'United Kingdom'
-- ) main;

-- CREATE MATERIALIZED VIEW cust_of_the_yr_mv
-- PCTFREE 5
-- BUILD IMMEDIATE
-- REFRESH COMPLETE
-- ENABLE QUERY REWRITE
-- AS
-- SELECT cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, SUM(s.amount_sold) as Revenue, c.country_name
-- FROM DWU320.customers cu
-- JOIN DWU320.sales s ON s.cust_id = cu.cust_id
-- JOIN DWU320.times t ON t.time_id = s.time_id
-- JOIN DWU320.countries c ON c.country_id = cu.country_id
-- GROUP BY cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, c.country_name;

-- -- subbbb quewrryy

-- alter session set query_rewrite_integrity = TRUSTED;
-- alter session set query_rewrite_enabled = TRUE;

-- set timing on

-- EXPLAIN PLAN FOR
-- SELECT cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, SUM(s.amount_sold) as Revenue, c.country_name
-- FROM DWU320.customers cu
-- JOIN DWU320.sales s ON s.cust_id = cu.cust_id
-- JOIN DWU320.times t ON t.time_id = s.time_id
-- JOIN DWU320.countries c ON c.country_id = cu.country_id
-- WHERE c.country_name  = 'United States' OR 'United Kingdom'
-- GROUP BY cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, c.country_name;


-- REM Now Let us Display the Output of the Explain Plan
-- set linesize 200
-- set pagesize 50
-- set markup html preformat on
-- select * from table(dbms_xplan.display());
-- set linesize 80





drop materialized view cust_of_the_yr_mv


-- 1st query
CREATE MATERIALIZED VIEW cust_of_the_yr_mv
PCTFREE 5
BUILD IMMEDIATE
REFRESH COMPLETE
ENABLE QUERY REWRITE
AS
SELECT cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, SUM(s.amount_sold) as Revenue, c.country_name
FROM DWU320.customers cu, DWU320.sales s, DWU320.countries c, DWU320.times t WHERE s.cust_id = cu.cust_id
AND t.time_id = s.time_id AND c.country_id = cu.country_id 
GROUP BY cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, c.country_name;

ALTER SESSION SET query_rewrite_integrity = TRUSTED;
ALTER SESSION SET query_rewrite_enabled = TRUE;

SET TIMING ON;

EXPLAIN PLAN FOR
SELECT cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, SUM(s.amount_sold) as Revenue, c.country_name
FROM DWU320.customers cu, DWU320.sales s,DWU320.countries c,  DWU320.times t WHERE s.cust_id = cu.cust_id
 AND t.time_id = s.time_id AND
 c.country_id = cu.country_id AND c.country_name = 'United Kingdom'
GROUP BY cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, c.country_name;

REM Now Let us Display the Output of the Explain Plan
set linesize 200
set pagesize 50
set markup html preformat on
select * from table(dbms_xplan.display());
set linesize 80




ALTER SESSION SET query_rewrite_integrity = TRUSTED;
ALTER SESSION SET query_rewrite_enabled = FALSE;

SET TIMING ON;

EXPLAIN PLAN FOR
SELECT cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, SUM(s.amount_sold) as Revenue, c.country_name
FROM SH2.customers cu, SH2.sales s,SH2.countries c,  SH2.times t WHERE s.cust_id = cu.cust_id
 AND t.time_id = s.time_id AND
 c.country_id = cu.country_id AND c.country_name = 'United Kingdom'
GROUP BY cu.cust_first_name, cu.cust_last_name, t.end_of_cal_year, c.country_name;

REM Now Let us Display the Output of the Explain Plan
set linesize 200
set pagesize 50
set markup html preformat on
select * from table(dbms_xplan.display());
set linesize 80


drop materialized view regional_sales_mv
-- 2nd query


CREATE MATERIALIZED VIEW regional_sales_mv
PCTFREE 5
BUILD IMMEDIATE
REFRESH FORCE
ENABLE QUERY REWRITE
AS
SELECT
    c.COUNTRY_REGION, p.PROD_CATEGORY, t.CALENDAR_YEAR, SUM(s.AMOUNT_SOLD) AS TOTAL_AMOUNT_SOLD, COUNT(DISTINCT s.CUST_ID) AS UNIQUE_CUSTOMERS
FROM DWU320.countries c, DWU320.customers cu, DWU320.sales s, DWU320.products p, DWU320.times t
WHERE
    c.COUNTRY_ID = cu.COUNTRY_ID AND cu.CUST_ID = s.CUST_ID AND s.PROD_ID = p.PROD_ID AND s.TIME_ID = t.TIME_ID
GROUP BY
    c.COUNTRY_REGION, p.PROD_CATEGORY, t.CALENDAR_YEAR;


ALTER SESSION SET query_rewrite_integrity = TRUSTED;
ALTER SESSION SET query_rewrite_enabled = TRUE;

SET TIMING ON;

EXPLAIN PLAN FOR
SELECT
    c.COUNTRY_REGION, p.PROD_CATEGORY, t.CALENDAR_YEAR, SUM(s.AMOUNT_SOLD) AS TOTAL_AMOUNT_SOLD, 
    COUNT(DISTINCT s.CUST_ID) AS UNIQUE_CUSTOMERS
FROM DWU320.countries c, DWU320.customers cu, DWU320.sales s, DWU320.products p, DWU320.times t
WHERE
    c.COUNTRY_ID = cu.COUNTRY_ID AND cu.CUST_ID = s.CUST_ID AND s.PROD_ID = p.PROD_ID
     AND s.TIME_ID = t.TIME_ID AND c.COUNTRY_REGION = 'Europe'
GROUP BY
c.COUNTRY_REGION, p.PROD_CATEGORY, t.CALENDAR_YEAR;

REM Now Let us Display the Output of the Explain Plan
set linesize 200
set pagesize 50
set markup html preformat on
select * from table(dbms_xplan.display());
set linesize 80




ALTER SESSION SET query_rewrite_integrity = TRUSTED;
ALTER SESSION SET query_rewrite_enabled = TRUE;

SET TIMING ON;

EXPLAIN PLAN FOR
SELECT
    c.COUNTRY_REGION, p.PROD_CATEGORY, t.CALENDAR_YEAR, SUM(s.AMOUNT_SOLD) AS TOTAL_AMOUNT_SOLD, 
    COUNT(DISTINCT s.CUST_ID) AS UNIQUE_CUSTOMERS
FROM SH2.countries c, SH2.customers cu, SH2.sales s, SH2.products p, SH2.times t
WHERE
    c.COUNTRY_ID = cu.COUNTRY_ID AND cu.CUST_ID = s.CUST_ID AND s.PROD_ID = p.PROD_ID 
    AND s.TIME_ID = t.TIME_ID AND c.COUNTRY_REGION = 'Europe'
GROUP BY
c.COUNTRY_REGION, p.PROD_CATEGORY, t.CALENDAR_YEAR;

REM Now Let us Display the Output of the Explain Plan
set linesize 200
set pagesize 50
set markup html preformat on
select * from table(dbms_xplan.display());
set linesize 80
























