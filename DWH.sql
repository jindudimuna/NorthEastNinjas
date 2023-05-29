
CREATE INDEX country_region_bix
	ON DWU320.countries(country_region)
        NOLOGGING COMPUTE STATISTICS ;

CREATE BITMAP INDEX product_name_bix
	ON DWU320.products(prod_name)
        NOLOGGING COMPUTE STATISTICS ;

 CREATE BITMAP INDEX fiscal_year_bix
	ON DWU320.times(end_of_fis_year)
        NOLOGGING COMPUTE STATISTICS ;

COMMIT;

drop INDEX country_region_bix;
drop INDEX product_name_bix;
drop INDEX fiscal_year_bix;


-- SELECT c.country_region, p.prod_name, SUM(s.amount_sold) AS TOTALSALES, t.end_of_fis_year
-- FROM SH2.countries c, SH2.products p, SH2.sales s, SH2.times t, SH2.customers cu
-- WHERE s.prod_id = p.prod_id and s.cust_id = cu.cust_id and cu.country_id = c.country_id
-- GROUP BY c.country_region, p.prod_name, t.end_of_fis_year
-- ORDER BY TOTALSALES
-- FETCH FIRST 5 ROWS ONLY;

-- set timing on
-- EXPLAIN PLAN FOR
-- SELECT c.country_region, p.prod_name, SUM(s.amount_sold) AS TOTALSALES, t.end_of_fis_year
-- FROM DWU320.countries c, DWU320.products p, DWU320.sales s, DWU320.times t
-- WHERE p.prod_id = 5 AND s.time_id = t.time_id
-- GROUP BY c.country_region, p.prod_name, t.end_of_fis_year
-- ORDER BY TOTALSALES;

-- set linesize 200
-- set pagesize 50
-- set markup html preformat on
-- select * from table(dbms_xplan.display());
-- set linesize 80

-- spool off
DWU320@EEMIS/DWpassWd

-- set timing on
-- SELECT c.country_region, p.prod_name, t.end_of_fis_year
-- FROM SH2.countries c, SH2.products p, SH2.sales s, SH2.times t
-- WHERE s.prod_id = p.prod_id
-- FETCH FIRST 5 ROWS ONLY;


-- EXPLAIN PLAN FOR
-- SELECT c.country_region, p.prod_name, s.total_sales, t.end_of_fis_year
-- FROM (
--     SELECT s.prod_id, SUM(s.amount_sold) AS total_sales
--     FROM DWU320.sales s
--     WHERE s.prod_id = 5
--     GROUP BY s.prod_id
-- ) s
-- JOIN DWU320.products p ON p.prod_id = s.prod_id
-- JOIN DWU320.times t ON s.time_id = t.time_id
-- WHERE ROWNUM <= 5
-- ORDER BY s.total_sales;

-- set linesize 200
-- set pagesize 50
-- set markup html preformat on
-- select * from table(dbms_xplan.display());
-- set linesize 80

-- EXPLAIN PLAN FOR
-- SELECT c.country_region, p.prod_name, s.total_sales, t.end_of_fis_year
-- FROM (
--     SELECT s.prod_id, s.time_id, SUM(s.amount_sold) AS total_sales
--     FROM DWU320.sales s
--     WHERE s.prod_id = 5
--     GROUP BY s.prod_id, s.time_id
-- ) s
-- JOIN DWU320.products p ON p.prod_id = s.prod_id
-- JOIN DWU320.times t ON t.time_id = s.time_id
-- JOIN DWU320.countries c on c.country_region = 'Europe' 
-- WHERE ROWNUM <= 1
-- ORDER BY s.total_sales;

-- set linesize 200
-- set pagesize 50
-- set markup html preformat on
-- select * from table(dbms_xplan.display());
-- set linesize 80



-- SELECT c.country_region, p.prod_name, SUM(s.amount_sold) AS total_sales, t.end_of_fis_year
-- FROM DWU320.sales s
-- JOIN DWU320.products p ON p.prod_id = s.prod_id
-- JOIN DWU320.times t ON t.time_id = s.time_id
-- JOIN DWU320.countries c ON c.country_region = 'Europe'
-- ORDER BY total_sales DESC
-- ;

-- first one
EXPLAIN PLAN FOR
SELECT country_region, prod_name, total_sales, end_of_fis_year
FROM (
    SELECT c.country_region, p.prod_name, SUM(s.amount_sold) AS total_sales, t.end_of_fis_year
    FROM DWU320.sales s
    JOIN DWU320.products p ON p.prod_id = s.prod_id
    JOIN DWU320.times t ON t.time_id = s.time_id
    JOIN DWU320.countries c ON c.country_region = 'Europe'
    GROUP BY c.country_region, p.prod_name, t.end_of_fis_year
) sub
ORDER BY total_sales DESC
FETCH FIRST 20 ROWS ONLY;



set linesize 200
set pagesize 50
set markup html preformat on
select * from table(dbms_xplan.display());
set linesize 80


-- second one

EXPLAIN PLAN FOR
SELECT country_region, prod_name, avg_sales, fiscal_quarter_number
FROM (
    SELECT c.country_region, p.prod_name, AVG(s.quantity_sold) AS avg_sales, t.fiscal_quarter_number
    FROM DWU320.sales s
    JOIN DWU320.products p ON p.prod_id = s.prod_id
    JOIN DWU320.times t ON t.time_id = s.time_id AND t.fiscal_quarter_number = 2
    JOIN DWU320.countries c ON c.country_region = 'Europe'
    GROUP BY c.country_region, p.prod_name, t.fiscal_quarter_number
) sub
ORDER BY avg_sales DESC
FETCH FIRST 20 ROWS ONLY;



set linesize 200
set pagesize 50
set markup html preformat on
select * from table(dbms_xplan.display());
set linesize 80


-- SELECT country_region, prod_name, avg_sales, fiscal_quater
-- FROM (
--     SELECT c.country_region, p.prod_name, AVG(s.quantity_sold) AS avg_sales, t.fiscal_quarter_number as fiscal_quater
--     FROM DWU320.sales s
--     JOIN DWU320.products p ON p.prod_id = s.prod_id
--     JOIN DWU320.times t ON t.time_id = s.time_id
--     JOIN DWU320.countries c ON c.country_region = 'Europe'
--     WHERE t.fiscal_quarter_number = 2
--     GROUP BY c.country_region, p.prod_name, t.fiscal_quarter_number
-- ) sub
-- ORDER BY avg_sales DESC
-- FETCH FIRST 20 ROWS ONLY;
