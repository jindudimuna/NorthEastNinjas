drop type payment_t FORCE;
drop type Payment_nt_type FORCE;
drop type Site_t FORCE;
drop type Site_nt_type FORCE;
drop type Client FORCE;
drop type SeccurityArrangement_t FORCE;
drop type SeccurityArr_nt_type FORCE;

drop table Client_tab CASCADE CONSTRAINTS;
drop table Site_tab CASCADE CONSTRAINTS;
drop table SeccurityArrangement_tab CASCADE CONSTRAINTS;
drop table Payment_tab CASCADE CONSTRAINTS;

CREATE Type Payment_t
/
CREATE Type Payment_nt_type as Table of REF Payment_t
/

CREATE Type Site_t
/
CREATE Type Site_nt_type as Table of REF Site_t
/
CREATE Type Client as Object (
    clientID CHAR (3),
    clientName CHAR (40),
    street CHAR (30),
    postcode CHAR (5),
    city CHAR (30),
    email VARCHAR (20),
    phoneNumber NUMBER (11),
    siteOwned Site_nt_type,
    PaysFor Payment_nt_type
)
/

CREATE type SeccurityArrangement_t
/
CREATE Type SeccurityArr_nt_type as Table of REF SeccurityArrangement_t
/
CREATE or REPLACE type Site_t as Object (
    siteID CHAR (3),
    siteName  CHAR (40),
    siteType CHAR (10), 
    street CHAR (30),
    ownedBy REF Client,
    arrangement SeccurityArr_nt_type
)

/

CREATE or REPLACE type SeccurityArrangement_t as Object (
    arrangementID CHAR (3),
    assignedTo REF Site_t,
    belongsTo REF Client,
    startDate DATE,
    endDate DATE,
    totalHours NUMBER,
    ratePerHour NUMBER (2),
    invoice REF Payment_t,
    arrangementStatus CHAR (20),
    shiftTypes CHAR (20)
)
/



CREATE OR REPLACE type Payment_t as Object (
    paymentID CHAR (3),
    paysFor REF SeccurityArrangement_t,
    payDate DATE,
    payAmount NUMBER (6),
    payTotal NUMBER (6),
    PaidBy REF Client
)

/

CREATE TABLE Client_tab of Client (
    primary key (clientID)
)
Nested Table siteOwned store as Client_sites_Tab,
Nested Table PaysFor store as Client_invoice_Tab
/

CREATE TABLE Site_tab of Site_t (
    primary key (siteID),
    foreign key (ownedBy) References Client_tab
)
Nested Table arrangement store as Site_arrang_Tab
/

CREATE Table  SeccurityArrangement_tab of SeccurityArrangement_t (
    primary key (arrangementID),
    foreign key (assignedTo) References Site_tab,
    foreign key (belongsTo) References Client_tab
)
/

CREATE Table Payment_tab of Payment_t (
    primary key (paymentID),
    foreign key (PaysFor) References SeccurityArrangement_tab,
    foreign key (PaidBy) References Client_tab
)
/

Alter table SeccurityArrangement_tab Add CONSTRAINT invoice_FK foreign key (invoice) References Payment_tab;


desc client_tab;
desc site_tab;
desc SeccurityArrangement_tab;
desc Payment_tab;


-- object relational database loading
-- client table
Insert into Client_tab values ('c1', 'Wayne Enterprise', '123 gordon st', 'GC14', 'Newcastle', 'alfred@wayneent.com', '1443255791',  Site_nt_type (), Payment_nt_type() );
Insert into Client_tab values ('c2', 'Initech inc', '7 Park Avenue', 'Ij3k', 'Sunderland', 'david@outlook.com', '1447985791',  Site_nt_type (), Payment_nt_type() );
Insert into Client_tab values ('c3', 'Lex Corp', '11 London Avenue', 'NA92', 'Newcastle', 'emily@lexcorp.com', '399020283',  Site_nt_type (), Payment_nt_type() );
Insert into Client_tab values ('c4', 'Daily Planet', '22 main street', 'MW21', 'Newcastle', 'lois@outlook.com', '1447985791',  Site_nt_type (), Payment_nt_type() );
Insert into Client_tab values ('c5', 'Star Labs', '8 park Avenue', 'NE22', 'Newcastle', 'bruce@starlabs.com', '1447916491',  Site_nt_type (), Payment_nt_type() );
Insert into Client_tab values ('c6', 'Yezzy', '16 Church Road', 'GH91', 'Newcastle', 'mike@yzy.com', '3947985791', Site_nt_type (), Payment_nt_type() );
Insert into Client_tab values ('c7', 'Donda', '17 Church Road', 'GH91', 'Newcastle', 'kim@donda.com', '1447985791',  Site_nt_type (), Payment_nt_type() );
Insert into Client_tab values ('c8', 'Sarah J', '17 Park Avenue', 'Ij3k', 'Newcastle', 'sarah@gmail.com', '133920791', Site_nt_type (), Payment_nt_type() );
Insert into Client_tab values ('c9', 'Owen Will', '2 Market Avenue', 'NQ22', 'Sunderland', 'david@outlook.com', '1447985791',  Site_nt_type (), Payment_nt_type() );
Insert into Client_tab values ('c10', 'Umbrella Corp', '22 jump Street', 'Aa12', 'Newcastle', 'will@jumpstr.com', '3352576128',  Site_nt_type (), Payment_nt_type() );

-- site table

insert into site_tab values ('S0',  'Yeezy Store', 'Business', '16 Church Road', (select REF (c) from Client_tab c where c.clientID = 'c6'), SeccurityArr_nt_type ());
insert into site_tab values ('S2',  'GOOD', 'Business', '30 Riverpark Road', (select REF (c) from Client_tab c where c.clientID = 'c6'), SeccurityArr_nt_type ());
insert into site_tab values ('S3',  'Star Lab HQ', 'Business', '22 CrossGrove', (select REF (c) from Client_tab c where c.clientID = 'c5'), SeccurityArr_nt_type ());
insert into site_tab values ('S4',  'Donda House', 'Business', '16 West drive', (select REF (c) from Client_tab c where c.clientID = 'c7'), SeccurityArr_nt_type ());
insert into site_tab values ('S5',  'Lex Corp HQ', 'Business', '22 Kent Road', (select REF (c) from Client_tab c where c.clientID = 'c3'), SeccurityArr_nt_type ());
insert into site_tab values ('S6',  'Umbrella Corp', 'Business', '55 Quayside', (select REF (c) from Client_tab c where c.clientID = 'c10'), SeccurityArr_nt_type ());
insert into site_tab values ('S7',  'Initech HQ', 'Business', '59 Quayside', (select REF (c) from Client_tab c where c.clientID = 'c2'), SeccurityArr_nt_type ());
insert into site_tab values ('S8',  'Daily Planet', 'Business', '22 tower Road', (select REF (c) from Client_tab c where c.clientID = 'c4'), SeccurityArr_nt_type ());
insert into site_tab values ('S9',  'Wayne Tech', 'Business', '73 Wayne Manor', (select REF (c) from Client_tab c where c.clientID = 'c1'), SeccurityArr_nt_type ());

-- security arrangement
-- make invoice null
insert into SeccurityArrangement_tab values ('A1', (select REF (s) from Site_tab s where s.siteID = 'S0'), (select REF (c) from Client_tab c where c.clientID = 'c6'), '01-JAN-2023', '21-JAN-2023', 200, 15, NULL, 'Confirmed', 'weekday' );
insert into SeccurityArrangement_tab values ('A2', (select REF (s) from Site_tab s where s.siteID = 'S3'), (select REF (c) from Client_tab c where c.clientID = 'c5'), '01-FEB-2023', '01-MAR-2023', 400, 15, NULL, 'Confirmed', 'weekday' );
insert into SeccurityArrangement_tab values ('A3', (select REF (s) from Site_tab s where s.siteID = 'S2'), (select REF (c) from Client_tab c where c.clientID = 'c6'), '01-FEB-2023', '21-MAR-2023', 600, 15, NULL, 'Confirmed', 'weekday and weekend' );
insert into SeccurityArrangement_tab values ('A4', (select REF (s) from Site_tab s where s.siteID = 'S9'), (select REF (c) from Client_tab c where c.clientID = 'c1'), '01-JAN-2023', '25-FEB-2023', 600, 30, NULL, 'Confirmed', 'weekend' );
insert into SeccurityArrangement_tab values ('A5', (select REF (s) from Site_tab s where s.siteID = 'S2'), (select REF (c) from Client_tab c where c.clientID = 'c9'), '02-MAR-2023', '22-APR-2023', 400, 30, NULL, 'Tentative', 'weekday' );
insert into SeccurityArrangement_tab values ('A6', (select REF (s) from Site_tab s where s.siteID = 'S6'), (select REF (c) from Client_tab c where c.clientID = 'c10'), '05-JAN-2023', '10-FEB-2023', 390, 25, NULL, 'Confirmed', 'weekday' );
insert into SeccurityArrangement_tab values ('A7', (select REF (s) from Site_tab s where s.siteID = 'S4'), (select REF (c) from Client_tab c where c.clientID = 'c7'), '02-MAR-2023', '10-MAY-2023', 700, 35, NULL, 'Confirmed', 'weekday and weekend' );
insert into SeccurityArrangement_tab values ('A8', (select REF (s) from Site_tab s where s.siteID = 'S5'), (select REF (c) from Client_tab c where c.clientID = 'c3'), '05-JAN-2023', '11-MAY-2023', 300, 15, NULL, 'Confirmed', 'weekday' );
insert into SeccurityArrangement_tab values ('A9', (select REF (s) from Site_tab s where s.siteID = 'S7'), (select REF (c) from Client_tab c where c.clientID = 'c10'), '11-JAN-2023', '21-MAY-2023', 400, 30, NULL, 'Confirmed', 'weekday and weekend' );

--payment table
--make paysfor null
insert into Payment_tab values ('P1', NULL, '01-DEC-2022', 2000, 3000, (select REF (c) from Client_tab c where c.clientID = 'c6' ));
insert into Payment_tab values ('P2', NULL,'11-JAN-2023', 3000, 6000, (select REF (c) from Client_tab c where c.clientID = 'c5' ));
insert into Payment_tab values ('P3', NULL,'11-JAN-2023', 4000, 9000, (select REF (c) from Client_tab c where c.clientID = 'c6' ));
insert into Payment_tab values ('P4', NULL, '08-DEC-2022', 18000, 18000, (select REF (c) from Client_tab c where c.clientID = 'c1' ));
insert into Payment_tab values ('P5', NULL, '11-MAR-2023', 8000, 12000, (select REF (c) from Client_tab c where c.clientID = 'c6' ));
insert into Payment_tab values ('P6', NULL, '08-DEC-2022', 3000, 9750, (select REF (c) from Client_tab c where c.clientID = 'c10' ));
insert into Payment_tab values ('P7', NULL, '01-DEC-2022', 18000, 24500, (select REF (c) from Client_tab c where c.clientID = 'c7' ));
insert into Payment_tab values ('P8', NULL, '08-DEC-2022', 4500, 4500, (select REF (c) from Client_tab c where c.clientID = 'c3' ));
insert into Payment_tab values ('P9', NULL, '08-JAN-2023', 4000, 12000, (select REF (c) from Client_tab c where c.clientID = 'c2' ));


--LInk payment to security arrangement.
update SeccurityArrangement_tab set invoice = (select REF (p) from Payment_tab p where p.paymentID = 'P1') where arrangementID ='A1';
update SeccurityArrangement_tab set invoice = (select REF (p) from Payment_tab p where p.paymentID = 'P2') where arrangementID ='A2';
update SeccurityArrangement_tab set invoice = (select REF (p) from Payment_tab p where p.paymentID = 'P3') where arrangementID ='A3';
update SeccurityArrangement_tab set invoice = (select REF (p) from Payment_tab p where p.paymentID = 'P4') where arrangementID ='A4';
update SeccurityArrangement_tab set invoice = (select REF (p) from Payment_tab p where p.paymentID = 'P5') where arrangementID ='A5';
update SeccurityArrangement_tab set invoice = (select REF (p) from Payment_tab p where p.paymentID = 'P6') where arrangementID ='A6';
update SeccurityArrangement_tab set invoice = (select REF (p) from Payment_tab p where p.paymentID = 'P7') where arrangementID ='A7';
update SeccurityArrangement_tab set invoice = (select REF (p) from Payment_tab p where p.paymentID = 'P8') where arrangementID ='A8';
update SeccurityArrangement_tab set invoice = (select REF (p) from Payment_tab p where p.paymentID = 'P9') where arrangementID ='A9';


-- link security arrangement to payment.

update Payment_tab set paysFor = (select REF (a) from SeccurityArrangement_tab a where a.arrangementID = 'A1')  where paymentID = 'P1';
update Payment_tab set paysFor = (select REF (a) from SeccurityArrangement_tab a where a.arrangementID = 'A2')  where paymentID = 'P2';
update Payment_tab set paysFor = (select REF (a) from SeccurityArrangement_tab a where a.arrangementID = 'A3')  where paymentID = 'P3';
update Payment_tab set paysFor = (select REF (a) from SeccurityArrangement_tab a where a.arrangementID = 'A4')  where paymentID = 'P4';
update Payment_tab set paysFor = (select REF (a) from SeccurityArrangement_tab a where a.arrangementID = 'A5')  where paymentID = 'P5';
update Payment_tab set paysFor = (select REF (a) from SeccurityArrangement_tab a where a.arrangementID = 'A6')  where paymentID = 'P6';
update Payment_tab set paysFor = (select REF (a) from SeccurityArrangement_tab a where a.arrangementID = 'A7')  where paymentID = 'P7';
update Payment_tab set paysFor = (select REF (a) from SeccurityArrangement_tab a where a.arrangementID = 'A8')  where paymentID = 'P8';
update Payment_tab set paysFor = (select REF (a) from SeccurityArrangement_tab a where a.arrangementID = 'A9')  where paymentID = 'P9';


--nested tables for clients owning sites.
insert into table (select c.siteOwned from Client_tab c where c.clientID = 'c1') select REF (s) from site_tab s where s.siteID in ('S9');
insert into table (select c.siteOwned from Client_tab c where c.clientID = 'c2') select REF (s) from site_tab s where s.siteID in ('S7');
insert into table (select c.siteOwned from Client_tab c where c.clientID = 'c3') select REF (s) from site_tab s where s.siteID in ('S5');
insert into table (select c.siteOwned from Client_tab c where c.clientID = 'c4') select REF (s) from site_tab s where s.siteID in ('S8');
insert into table (select c.siteOwned from Client_tab c where c.clientID = 'c5') select REF (s) from site_tab s where s.siteID in ('S3');
insert into table (select c.siteOwned from Client_tab c where c.clientID = 'c6') select REF (s) from site_tab s where s.siteID in ('S0', 'S2');
insert into table (select c.siteOwned from Client_tab c where c.clientID = 'c7') select REF (s) from site_tab s where s.siteID in ('S4');
insert into table (select c.siteOwned from Client_tab c where c.clientID = 'c10') select REF (s) from site_tab s where s.siteID in ('S6');

-- nested tables for clients payments.

insert into table (select c.PaysFor from Client_tab c where c.clientID = 'c1' ) select REF (p) from Payment_tab p where p.paymentID in ('P4');
insert into table (select c.PaysFor from Client_tab c where c.clientID = 'c2' ) select REF (p) from Payment_tab p where p.paymentID in ('P9');
insert into table (select c.PaysFor from Client_tab c where c.clientID = 'c3' ) select REF (p) from Payment_tab p where p.paymentID in ('P8');
insert into table (select c.PaysFor from Client_tab c where c.clientID = 'c5' ) select REF (p) from Payment_tab p where p.paymentID in ('P2');
insert into table (select c.PaysFor from Client_tab c where c.clientID = 'c6' ) select REF (p) from Payment_tab p where p.paymentID in ('P1', 'P3', 'P5');
insert into table (select c.PaysFor from Client_tab c where c.clientID = 'c7' ) select REF (p) from Payment_tab p where p.paymentID in ('P7');
insert into table (select c.PaysFor from Client_tab c where c.clientID = 'c10' ) select REF (p) from Payment_tab p where p.paymentID in ('P6');

--nested tables for sexcurity arrangement in site table

insert into table (select s.arrangement from Site_tab s where s.siteID = 'S0') select REF (a) from SeccurityArrangement_tab a where a.arrangementID in ('A1');
insert into table (select s.arrangement from Site_tab s where s.siteID = 'S2') select REF (a) from SeccurityArrangement_tab a where a.arrangementID in ('A3');
insert into table (select s.arrangement from Site_tab s where s.siteID = 'S3') select REF (a) from SeccurityArrangement_tab a where a.arrangementID in ('A2');
insert into table (select s.arrangement from Site_tab s where s.siteID = 'S4') select REF (a) from SeccurityArrangement_tab a where a.arrangementID in ('A7');
insert into table (select s.arrangement from Site_tab s where s.siteID = 'S5') select REF (a) from SeccurityArrangement_tab a where a.arrangementID in ('A8');
insert into table (select s.arrangement from Site_tab s where s.siteID = 'S6') select REF (a) from SeccurityArrangement_tab a where a.arrangementID in ('A6');
insert into table (select s.arrangement from Site_tab s where s.siteID = 'S7') select REF (a) from SeccurityArrangement_tab a where a.arrangementID in ('A9');
insert into table (select s.arrangement from Site_tab s where s.siteID = 'S9') select REF (a) from SeccurityArrangement_tab a where a.arrangementID in ('A4');

/
commit;
-- 1Query
DECLARE
  CURSOR client_cursor IS
    SELECT sa.arrangementID, DEREF(sa.assignedTo) as location, DEREF(sa.belongsTo) as owner, 
    sa.startDate, sa.endDate, 
    sa.totalHours, sa.ratePerHour,
     sa.arrangementStatus,
     sa.shiftTypes
    FROM SeccurityArrangement_tab sa
    WHERE sa.startDate >= TO_DATE('01-JAN-2023', 'DD-MON-YYYY') AND sa.startDate <= TO_DATE('31-MAR-2023', 'DD-MON-YYYY');

  v_site site_tab%ROWTYPE;  
  v_owner Client_tab%ROWTYPE;


BEGIN

  FOR details IN client_cursor LOOP
  v_site := details.location;
  v_owner := details.owner;

 DBMS_OUTPUT.PUT_LINE('Site Name: ' || v_site.siteName);
 DBMS_OUTPUT.PUT_LINE('Site Owner: ' || v_owner.clientName);
 DBMS_OUTPUT.PUT_LINE('Start Date: ' || details.startDate);
 DBMS_OUTPUT.PUT_LINE('End Date: ' || details.endDate);
 DBMS_OUTPUT.PUT_LINE('Total Hours: ' || details.totalHours);
 DBMS_OUTPUT.PUT_LINE('rate/hr (pounds): ' || details.ratePerHour);
 DBMS_OUTPUT.PUT_LINE('Status: ' || details.arrangementStatus);
 DBMS_OUTPUT.PUT_LINE('Shift Types: ' || details.shiftTypes);
 DBMS_OUTPUT.PUT_LINE('--------------------------');
  END LOOP;
  
END;
/

--  DECLARE
--    CURSOR payment_cursor IS
--     SELECT SUM(pa.payAmount) as payTotal, DEREF(pa.PaidBy).clientName as clientname
--     FROM Payment_tab pa, Client_tab
--     WHERE DEREF(pa.PaidBy).clientID = Client_tab.clientID
--     GROUP BY Client_tab.clientID, DEREF(pa.PaidBy).clientName
--     ORDER BY payTotal DESC;
 
--     BEGIN
--         FOR payments IN payment_cursor LOOP
        
   
--   DBMS_OUTPUT.PUT_LINE('Client Name: ' || payments.clientname);
--   DBMS_OUTPUT.PUT_LINE('Amount Paid: ' ||payments.payTotal);


-- END LOOP;
-- END;

-- /




-- SELECT SUM(pa.column_value.payAmount) as payTotal from client_tab ct, table(ct.paysFor) pa;


-- DECLARE
 


--  SELECT c.clientID, c.clientName, (SELECT SUM(p.column_value.payAmount) FROM TABLE(c.paysFor)) as totalPayments p FROM Client_tab c;



--  DECLARE
--   CURSOR c_clients IS
--     SELECT c.clientID,
--            c.clientName,
--            (SELECT SUM(pa.payAmount) FROM TABLE(c.paysFor)) AS totalPayments
--     FROM client_tab c;
    
--   v_clientID client.clientID%ROWTYPE;
--   v_clientName client.clientName%ROWTYPE;
--   v_totalPayments client.totalPayments%ROWTYPE;
-- BEGIN
--   FOR client_rec IN c_clients LOOP
--     v_clientID := client_rec.clientID;
--     v_clientName := client_rec.clientName;
--     v_totalPayments := client_rec.totalPayments;
    
--     DBMS_OUTPUT.PUT_LINE('Client ID: ' || v_clientID);
--     DBMS_OUTPUT.PUT_LINE('Client Name: ' || v_clientName);
--     DBMS_OUTPUT.PUT_LINE('Total Payments: ' || v_totalPayments);
--     DBMS_OUTPUT.PUT_LINE('------------------------');
--   END LOOP;
-- END;
-- /




--2nd final champion

DECLARE
   CURSOR payment_cursor IS
SELECT DISTINCT
  a.payTotal, a.clientname
FROM
  (
    SELECT SUM(pa.payAmount) AS payTotal, DEREF(pa.PaidBy).clientName AS clientname
    FROM Payment_tab pa, Client_tab c
    WHERE DEREF(pa.PaidBy).clientID = c.clientID
    GROUP BY DEREF(pa.PaidBy).clientName
  ) a,
  (
    SELECT pa.payAmount, DEREF(pa.PaidBy).clientName AS clientname
    FROM Payment_tab pa, Client_tab c, SeccurityArrangement_tab sc
    WHERE DEREF(sc.invoice).paymentID = pa.paymentID AND DEREF(pa.PaidBy).clientID = c.clientID
  ) b
WHERE
  a.clientname = b.clientname
ORDER BY a.payTotal DESC;

BEGIN
  FOR payments IN payment_cursor LOOP
    DBMS_OUTPUT.PUT_LINE('Client Name: ' || SUBSTR(payments.clientname, 1, 200));
    DBMS_OUTPUT.PUT_LINE('Total Revenue: ' || TO_CHAR(payments.payTotal));
    DBMS_OUTPUT.PUT_LINE('----------');
    
    FOR sites IN (
      SELECT DISTINCT a.site, a.Address, b.payAmount
      FROM (
        SELECT DISTINCT s.column_value.siteName AS site, s.column_value.street AS Address
        FROM Payment_tab pa, Client_tab c, TABLE(c.siteOwned) s
        WHERE DEREF(pa.PaidBy).clientID = c.clientID
          AND DEREF(pa.PaidBy).clientName = payments.clientname
      ) a,
      (
        SELECT DISTINCT DEREF(sc.assignedTo).siteName AS site, pa.payAmount
        FROM Payment_tab pa, Client_tab c, SeccurityArrangement_tab sc
        WHERE DEREF(sc.invoice).paymentID = pa.paymentID
          AND DEREF(pa.PaidBy).clientID = c.clientID
          AND DEREF(pa.PaidBy).clientName = payments.clientname
      ) b
      WHERE a.site = b.site
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Site: ' || sites.site);
      DBMS_OUTPUT.PUT_LINE('Address: ' || sites.Address);
      DBMS_OUTPUT.PUT_LINE('Paid deposit: ' || sites.payAmount);
      DBMS_OUTPUT.PUT_LINE('----------');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('==============================');
  END LOOP;
END;
/











--  SELECT SUM(pa.payAmount) as payTotal, DEREF(pa.PaidBy).clientName as clientname
--  FROM Payment_tab pa, Client_tab GROUP BY Client_tab.clientID, DEREF(pa.PaidBy).clientName     
--  ORDER BY payTotal DESC;
--  DECLARE
--    CURSOR payment_cursor IS

--      SELECT SUM(pa.payAmount) as payTotal, DEREF(pa.PaidBy).clientName as clientname, s.column_value.siteName as site, s.column_value.street as Address
--     FROM Payment_tab pa, Client_tab c, table(c.siteOwned) s
--     WHERE DEREF(pa.PaidBy).clientID = c.clientID
--      GROUP BY DEREF(pa.PaidBy).clientName, s.column_value.siteName, s.column_value.street
--     ORDER BY payTotal DESC;

--  BEGIN
--         FOR payments IN payment_cursor LOOP
        
   
--   DBMS_OUTPUT.PUT_LINE('Client Name: ' || payments.clientname);
--   DBMS_OUTPUT.PUT_LINE('Amount Paid: ' ||payments.payTotal );
--   DBMS_OUTPUT.PUT_LINE('Site: ' ||payments.site ||payments.Address);


-- END LOOP;
-- END;

-- /

-- SELECT payAmount, DEREF(pa.PaidBy).clientName as clientname, DEREF(sc.assignedTo).siteName AS site 
-- from Payment_tab pa, Client_tab c, SeccurityArrangement_tab sc
-- WHERE DEREF(sc.invoice).paymentID = pa.paymentID AND DEREF(pa.PaidBy).clientID = c.clientID ;

-- -- SELECT payAmount, DEREF(pa.PaidBy).clientName as clientname from Payment_tab pa, Client_tab c
-- -- WHERE DEREF(pa.PaidBy).clientID = c.clientID;


--     -- WHERE DEREF(pa.PaidBy) IS NULL OR DEREF(pa.PaidBy) = REF (c)
--     -- GROUP BY DEREF(pa.PaidBy).clientName
--     -- ORDER BY payTotal DESC;



-- SELECT SUM(pa.payAmount) AS payTotal, DEREF(pa.PaidBy).clientName AS clientname, c.siteName AS site
-- FROM Payment_tab pa, Client_tab c, TABLE(c.siteOwned.siteName); 
-- WHERE DEREF(pa.PaidBy) IS NOT NULL
-- GROUP BY DEREF(pa.PaidBy).clientName, s.siteName
-- ORDER BY payTotal DESC;


-- SELECT SUM(pa.payAmount) AS payTotal, DEREF(pa.PaidBy).clientName AS clientname, DEREF(s.ownedBy).siteName AS site
-- FROM Payment_tab pa, Client_tab c, TABLE(pa.Paidby.siteOwned) s
-- WHERE DEREF(pa.PaidBy) IS NOT NULL
-- GROUP BY DEREF(pa.PaidBy).clientName, DEREF(s.ownedBy).siteName
-- ORDER BY payTotal DESC;


--     https://prod.liveshare.vsengsaas.visualstudio.com/join?FD35D336CBC86B5B14976EE2DB82C7BC9775

--     ORA-20000: ORU-10028: line length overflow, limit of 32767 bytes per line
-- ORA-06512: at "SYS.DBMS_OUTPUT", line 32
-- ORA-06512: at "SYS.DBMS_OUTPUT", line 91
-- ORA-06512: at "SYS.DBMS_OUTPUT", line 112
-- ORA-06512: at line 27
-- ORA-06512: at line 27

DECLARE
   CURSOR payment_cursor IS
      SELECT
        a.clientname,
        a.payTotal,
        s.column_value.siteName AS site,
        s.column_value.street AS Address,
        b.payAmount
      FROM
        (
          SELECT
            DEREF(pa.PaidBy).clientName AS clientname,
            SUM(pa.payAmount) AS payTotal,
            c.siteOwned AS sites
          FROM
            Payment_tab pa,
            Client_tab c
          WHERE DEREF(pa.PaidBy).clientID = c.clientID
          GROUP BY DEREF(pa.PaidBy).clientName, c.siteOwned
        ) a,
        (
          SELECT
            pa.payAmount,
            DEREF(pa.PaidBy).clientName AS clientname,
            DEREF(sc.assignedTo).siteName AS site
          FROM
            Payment_tab pa,
            Client_tab c,
            SeccurityArrangement_tab sc
          WHERE
            DEREF(sc.invoice).paymentID = pa.paymentID
            AND DEREF(pa.PaidBy).clientID = c.clientID
        ) b,
        TABLE(a.sites) s
      WHERE
        a.clientname = b.clientname
        AND a.siteName = b.site
      ORDER BY
        a.clientname, a.site;
   current_client VARCHAR2(100) := NULL;
BEGIN
   FOR payments IN payment_cursor LOOP
      IF payments.clientname != current_client THEN
         IF current_client IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('----------------');
         END IF;
         DBMS_OUTPUT.PUT_LINE('Client Name: ' || payments.clientname);
         current_client := payments.clientname;
      END IF;
      DBMS_OUTPUT.PUT_LINE('Total Revenue: ' || payments.payTotal);
      DBMS_OUTPUT.PUT_LINE('Site: ' ||payments.site);
      DBMS_OUTPUT.PUT_LINE(' Address: ' || payments.Address);     
       DBMS_OUTPUT.PUT_LINE('Pay Amount: ' || payments.payAmount);
   END LOOP;
END;
/
