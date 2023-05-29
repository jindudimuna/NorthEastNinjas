CREATE TABLE Employee ( 
employeeID CHAR(2),
employeeName CHAR(40) NOT NULL, 
employeeType CHAR (20) NOT NULL CONSTRAINT EMP_TYPE CHECK (employeeType IN ('fulltime', 'parttime')),
employeeEmail VARCHAR(20) NOT NULL UNIQUE,
street CHAR (30) NOT NULL,
postcode CHAR (5) NOT NULL,
city VARCHAR (15) NOT NULL,
CONSTRAINT PKEY_Employee Primary key(employeeID) 
);
desc Employee; 

CREATE TABLE Assignment(
assignmentID CHAR (2) NOT NULL,
 empNo CHAR(2) NOT NULL UNIQUE ,
 arrangementNo CHAR(4) NOT NULL UNIQUE,
 shiftNumber VARCHAR (2) NOT NULL CONSTRAINT SHIFT CHECK (shiftNumber IN ('1', '2')),
  CONSTRAINT PKEY_Assignment Primary Key(assignmentID),
  CONSTRAINT EMP_ASSIGNMENT FOREIGN KEY (empNo) REFERENCES Employee(employeeID),
  CONSTRAINT EMP_Arrangement FOREIGN KEY (arrangementNo) REFERENCES SecurityArrangement(arrangementID)
);
desc Assignment;



CREATE TABLE Client (
clientID CHAR (3) NOT NULL,
clientName CHAR(40) NOT NULL,
street CHAR (30) NOT NULL,
postcode CHAR (5) NOT NULL,
city VARCHAR (15) NOT NULL,
email VARCHAR (20) NOT NULL UNIQUE,
phoneNumber NUMBER (11) NOT NULL UNIQUE,
clientType CHAR (10) NOT NULL CONSTRAINT CLIENT_TYPE CHECK (clientType IN ( 'private', 'business')),
CONSTRAINT PKEY_CLIENT Primary key (clientID)
);
desc Client;

CREATE TABLE Site(
siteID CHAR(2) NOT NULL,
clientNo CHAR(3) NOT NULL ,
siteName CHAR(20) NOT NULL,
siteType CHAR(10) NOT NULL CONSTRAINT SITE_TYPE CHECK (siteType IN ( 'private', 'business')),
street CHAR (30) NOT NULL,
postcode CHAR (5) NOT NULL,
city VARCHAR (15) NOT NULL,
CONSTRAINT PKEY_Site Primary Key (siteID),
CONSTRAINT SITE_OWNER FOREIGN KEY (clientNo) REFERENCES Client(clientID)
);
desc Site;

CREATE TABLE SecurityArrangement (
arrangementID CHAR (4) NOT NULL,
siteNo CHAR (2) NOT NULL ,
startDate DATE DEFAULT SYSDATE NOT NULL,
endDate DATE NOT NULL,
totalHours NUMBER NOT NULL,
ratePerHour NUMBER (2) NOT NULL, 
arrangementStatus CHAR (20) DEFAULT 'tentative',
shiftTypes CHAR (20) NOT NULL CONSTRAINT ARRANGEMENT_TYPE CHECK (shiftTypes IN ('weekday', 'weekend', 'weekday and weekend')),
CONSTRAINT PKEY_SecurityArrangement Primary key (arrangementID),
CONSTRAINT SECURITY_SITE FOREIGN KEY (siteNo) REFERENCES Site(siteID) ,
CONSTRAINT DATE_DURATION CHECK (TO_DATE (startDate, 'DD-MON-YYYY') < TO_DATE (endDate, 'DD-MON-YYYY')) 
);
desc SecurityArrangement;



CREATE TABLE SiteVisit (
visitID CHAR (2) NOT NULL ,
siteNo CHAR (2) NOT NULL ,
managerNo CHAR(2) NOT NULL,
visitDate DATE NOT NULL,
comments CHAR (225) NULL,
CONSTRAINT PKEY_Visit Primary key (visitID),
CONSTRAINT SITE_NUM FOREIGN KEY (siteNo) REFERENCES Site(siteID),
CONSTRAINT MANAGER_NUM FOREIGN KEY (managerNo) REFERENCES Manager(managerID)
);
desc SiteVisit;

CREATE TABLE Manager (
managerID CHAR (2) NOT NULL,
empNo CHAR(2) NOT NULL UNIQUE ,
CONSTRAINT PKEY_MANAGER Primary key (managerID),
CONSTRAINT MANAGER FOREIGN KEY (empNo) REFERENCES Employee(employeeID)
);
desc Manager;


CREATE TABLE SecurityDuration (
durationID CHAR (2) NOT NULL ,
numberOfWeeks NUMBER (2) NOT NULL,
arrangementNo CHAR(4) NOT NULL UNIQUE ,
CONSTRAINT PKEY_DURATION Primary key (durationID),
CONSTRAINT DURATION_ARRANGEMENT FOREIGN KEY (arrangementNo) REFERENCES SecurityArrangement(arrangementID)
);
desc SecurityDuration;

-- ALTER TABLE SecurityDuration
-- MODIFY arrangementNo CHAR(4);

CREATE TABLE Payment (
paymentID CHAR (2) NOT NULL,
clientNo CHAR(4) NOT NULL,
paymentDate DATE NOT NULL,
paymentAmount NUMBER (6) NOT NULL,
paymentTotal NUMBER (6) NOT NULL,
CONSTRAINT PKEY_PAYMENT Primary key (paymentID),
CONSTRAINT PAYMENT_OWNER FOREIGN KEY (clientNo) REFERENCES Client(clientID)
); 
desc Payment;

CREATE TABLE Bill (
billID CHAR (4) NOT NULL,
arrangementNo CHAR(4) NOT NULL UNIQUE,
paymentNo CHAR (2) NOT NULL UNIQUE ,
CONSTRAINT PKEY_BILL Primary Key (billID),
CONSTRAINT ARRANGEMENT_BILL FOREIGN KEY (arrangementNo) REFERENCES SecurityArrangement(arrangementID),
CONSTRAINT PAYMENT FOREIGN KEY (paymentNo) REFERENCES Payment(paymentID)
);
desc Bill;




CREATE TABLE Availability(
availabilityID CHAR (4) NOT NULL,
empNo CHAR (2) NOT NULL,
startDate DATE NOT NULL,
endDate DATE NOT NULL,
CONSTRAINT AVAILABILITY_DURATION CHECK (TO_DATE (startDate, 'DD-MON-YYYY') < TO_DATE (endDate, 'DD-MON-YYYY')),
CONSTRAINT PKEY_AVAIL Primary key (availabilityID),
CONSTRAINT EMP FOREIGN KEY (empNo) REFERENCES Employee(employeeID)
);
desc Availability;

-- insert data
INSERT INTO Employee (employeeID, employeeName, employeeType, employeeEmail, street, postcode, city)
VALUES 
('01', 'John Smith', 'fulltime', 'john.smith@abc.com', '123 Main St', '12345', 'Sunderland');
INSERT INTO Employee (employeeID, employeeName, employeeType, employeeEmail, street, postcode, city)
VALUES('02', 'Jane Doe', 'parttime', 'jane.doe@xyz.com', '456 Oak St', '67890', 'Newcastle');
INSERT INTO Employee (employeeID, employeeName, employeeType, employeeEmail, street, postcode, city)
VALUES('03', 'Mike Johnson', 'fulltime', 'mike.johnson@def.com', '789 Maple Ave', '54321', 'Newcastle');
INSERT INTO Employee (employeeID, employeeName, employeeType, employeeEmail, street, postcode, city)
VALUES('04', 'Lisa Lee', 'parttime', 'lisa.lee@ghi.com', '321 Elm St', '98765', 'Newcastle');
INSERT INTO Employee (employeeID, employeeName, employeeType, employeeEmail, street, postcode, city)
VALUES('05', 'David Kim', 'fulltime', 'david.kim@jkl.com', '555 Pine St', '45678', 'Newcastle');
INSERT INTO Employee (employeeID, employeeName, employeeType, employeeEmail, street, postcode, city)
VALUES('06', 'Sara Park', 'parttime', 'sara.park@mno.com', '777 Birch Blvd', '23456', 'Newcastle');
INSERT INTO Employee (employeeID, employeeName, employeeType, employeeEmail, street, postcode, city)
VALUES('07', 'James Lee', 'fulltime', 'james.lee@pqr.com', '888 Cherry Dr', '78901', 'Newcastle');
INSERT INTO Employee (employeeID, employeeName, employeeType, employeeEmail, street, postcode, city)
VALUES('08', 'Rachel Kim', 'parttime', 'rachel.kim@stu.com', '999 Oak Ave', '12345', 'Newcastle');
INSERT INTO Employee (employeeID, employeeName, employeeType, employeeEmail, street, postcode, city)
VALUES('09', 'Matt Johnson', 'fulltime', 'matt.johnson@vwx.com', '444 Maple Blvd', '67890', 'Newcastle');
INSERT INTO Employee (employeeID, employeeName, employeeType, employeeEmail, street, postcode, city)
VALUES('10', 'Emily Lee', 'parttime', 'emily.lee@yza.com', '222 Pine Ave', '54321', 'Newcastle');


-- Insert 3 employees as managers
INSERT INTO Manager (managerID, empNo)
SELECT 'M1', employeeID FROM Employee WHERE employeeName = 'John Smith';
INSERT INTO Manager (managerID, empNo)
SELECT 'M2', employeeID FROM Employee WHERE employeeName = 'Emily Lee';
INSERT INTO Manager (managerID, empNo)
SELECT 'M3', employeeID FROM Employee WHERE employeeName = 'David Kim';


INSERT INTO Client (clientID, clientName, street, postcode, city, email, phoneNumber, clientType) VALUES
('C1', 'Live', '23 Main St', 'AB1CD', 'Newcastle', 'john.smith@live.com', '01234567891', 'business');
INSERT INTO Client (clientID, clientName, street, postcode, city, email, phoneNumber, clientType) VALUES
('C2', 'Umbrella Corporation', '15 Church Rd', 'EF2GH', 'Gateshead', 'sara@umbrella.com', '02345678901', 'business');
INSERT INTO Client (clientID, clientName, street, postcode, city, email, phoneNumber, clientType) VALUES
('C4', 'Initech inc', '7 Park Avenue', 'IJ3KL', 'Sunderland', 'david@outlook.com', '03456789012', 'business');
INSERT INTO Client (clientID, clientName, street, postcode, city, email, phoneNumber, clientType) VALUES
('C11', 'Wayne Enterprises', '45 Market Square', 'MN4OP', 'Durham', 'jenny@wayne.co.uk', '04567890123', 'business');
INSERT INTO Client (clientID, clientName, street, postcode, city, email, phoneNumber, clientType) VALUES
('C5', 'Stark industries', '30 High Street', 'QR5ST', 'Edinburgh', 'thomas@stark.com', '05678901234', 'business');
INSERT INTO Client (clientID, clientName, street, postcode, city, email, phoneNumber, clientType) VALUES
('C6', 'Lex corp', '11 London Rd', 'UV6WX', 'Leeds', 'emily@lexcorp.com', '06789012345', 'business');
INSERT INTO Client (clientID, clientName, street, postcode, city, email, phoneNumber, clientType) VALUES
('C7', 'Daily Planet', '22 Main St', 'YZ7AB', 'Newcastle', 'andy@dailyplanet.com', '07890123456', 'business');
INSERT INTO Client (clientID, clientName, street, postcode, city, email, phoneNumber, clientType) VALUES
('C8', 'Jennifer Taylor', '8 Park Avenue', 'CD8EF', 'Cardiff', 'jennifer@business.com', '08901234567', 'private');
INSERT INTO Client (clientID, clientName, street, postcode, city, email, phoneNumber, clientType) VALUES
('C9', 'yeezy', '16 Church Rd', 'GH9IJ', 'Newcastle', 'mark@yeezy.com', '09012345678', 'business');
INSERT INTO Client (clientID, clientName, street, postcode, city, email, phoneNumber, clientType) VALUES
('C10', 'Sarah Johnson', '34 Market Square', 'KL1MN', 'Newcastle', 'sarah@outlook.com', '09123456789', 'private');



INSERT INTO Site (siteID, clientNo, siteName, siteType, street, postcode, city)
VALUES('S1', 'C1', 'Live HQ', 'business', '23 Main St', 'AB1CD', 'Newcastle');
INSERT INTO Site (siteID, clientNo, siteName, siteType, street, postcode, city)
VALUES('S2', 'C11', 'Umbrella Labs', 'business', '15 Church Rd', 'EF2GH', 'Newcastle');
INSERT INTO Site (siteID, clientNo, siteName, siteType, street, postcode, city)
VALUES('S3', 'C6', 'Initech Office', 'business', '7 Park Avenue', 'IJ3KL', 'Newcastle');
INSERT INTO Site (siteID, clientNo, siteName, siteType, street, postcode, city)
VALUES('S4', 'C11', 'Wayne Tower', 'business', '45 Market Square', 'MN4OP', 'Newcastle');
INSERT INTO Site (siteID, clientNo, siteName, siteType, street, postcode, city)
VALUES('S5', 'C5', 'Stark Industries UK', 'business', '30 High Street', 'QR5ST', 'newcastle');
INSERT INTO Site (siteID, clientNo, siteName, siteType, street, postcode, city)
VALUES('S6', 'C6', 'LexCorp Building', 'business', '11 London Rd', 'UV6WX', 'Newcastle');
INSERT INTO Site (siteID, clientNo, siteName, siteType, street, postcode, city)
VALUES('S7', 'C6', 'Jennifer Taylor Home', 'private', '8 Park Avenue', 'CD8EF', 'Newcastle');
INSERT INTO Site (siteID, clientNo, siteName, siteType, street, postcode, city)
VALUES('S8', 'C9', 'Yeezy Store', 'business', '16 Church Rd', 'GH9IJ', 'Newcastle');
INSERT INTO Site (siteID, clientNo, siteName, siteType, street, postcode, city)
VALUES('S9', 'C11', 'Sarah Residence', 'private', '34 Market Square', 'KL1MN', 'Newcastle');
INSERT INTO Site (siteID, clientNo, siteName, siteType, street, postcode, city)
VALUES('S10', 'C1', 'Live Datacenter', 'business', '37 Queen St', 'AB2CD', 'Newcastle');

INSERT INTO SecurityArrangement (arrangementID, siteNo, startDate, endDate, totalHours, ratePerHour, arrangementStatus, shiftTypes) VALUES 
('SA1', 'S1', '01-JAN-2023', '21-JAN-2023', '200', 15, 'confirmed', 'weekday');
INSERT INTO SecurityArrangement (arrangementID, siteNo, startDate, endDate, totalHours, ratePerHour, arrangementStatus, shiftTypes) VALUES 
('SA2', 'S1', '1-FEB-2023', '01-MAR-2023', '400', 15, 'confirmed', 'weekday');
INSERT INTO SecurityArrangement (arrangementID, siteNo, startDate, endDate, totalHours, ratePerHour, arrangementStatus, shiftTypes) VALUES 
('SA3', 'S2', '02-JAN-2023', '01-FEB-2023', '400', 15, 'confirmed', 'weekday');
INSERT INTO SecurityArrangement (arrangementID, siteNo, startDate, endDate, totalHours, ratePerHour, arrangementStatus, shiftTypes) VALUES 
('SA4', 'S2', '02-FEB-2023', '1-MAR-2023', '700', 15, 'tentative', 'weekend');
INSERT INTO SecurityArrangement (arrangementID, siteNo, startDate, endDate, totalHours, ratePerHour, arrangementStatus, shiftTypes) VALUES 
('SA5', 'S2', '02-MAR-2023', '10-MAY-2023', '600', 20, 'confirmed', 'weekday and weekend');
INSERT INTO SecurityArrangement (arrangementID, siteNo, startDate, endDate, totalHours, ratePerHour, arrangementStatus, shiftTypes) VALUES 
('SA6', 'S3', '05-JAN-2023', '10-FEB-2023', '390', 25, 'tentative', 'weekday');
INSERT INTO SecurityArrangement (arrangementID, siteNo, startDate, endDate, totalHours, ratePerHour, arrangementStatus, shiftTypes) VALUES 
('SA7', 'S3', '11-FEB-2023', '10-MAR-2023', '600', 30, 'confirmed', 'weekend');
INSERT INTO SecurityArrangement (arrangementID, siteNo, startDate, endDate, totalHours, ratePerHour, arrangementStatus, shiftTypes) VALUES 
('SA8', 'S4', '01-JAN-2023', '25-FEB-2023', '600', 30, 'confirmed', 'weekend');
INSERT INTO SecurityArrangement (arrangementID, siteNo, startDate, endDate, totalHours, ratePerHour, arrangementStatus, shiftTypes) VALUES 
('SA9', 'S4', '01-MAR-2023', '31-APR-2023', '600', 30, 'confirmed', 'weekend');
INSERT INTO SecurityArrangement (arrangementID, siteNo, startDate, endDate, totalHours, ratePerHour, arrangementStatus, shiftTypes) VALUES 
('SA10', 'S8', '11-JAN-2023', '01-MAR-2023', '700', 30, 'confirmed', 'weekend');

INSERT INTO Bill (billID, arrangementNo, paymentNo) VALUES ('01', 'SA1', '01');
INSERT INTO Bill (billID, arrangementNo, paymentNo) VALUES ('02', 'SA2', '02');
INSERT INTO Bill (billID, arrangementNo, paymentNo) VALUES ('03', 'SA3', '03');
INSERT INTO Bill (billID, arrangementNo, paymentNo) VALUES ('04', 'SA5', '05');
INSERT INTO Bill (billID, arrangementNo, paymentNo) VALUES ('05', 'SA7', '06');
INSERT INTO Bill (billID, arrangementNo, paymentNo) VALUES ('06', 'SA8', '07');
INSERT INTO Bill (billID, arrangementNo, paymentNo) VALUES ('07', 'SA9', '08');
INSERT INTO Bill (billID, arrangementNo, paymentNo) VALUES ('08', 'SA10', '09');


INSERT INTO Payment (paymentID, clientNo, paymentDate, paymentAmount, paymentTotal)
VALUES ('01', 'C1', '12-MAR-2023', 20000, 45000);

INSERT INTO Payment (paymentID, clientNo, paymentDate, paymentAmount, paymentTotal)
VALUES ('02', 'C11', TO_DATE('2022-02-01', 'YYYY-MM-DD'), 2000, 6000);

INSERT INTO Payment (paymentID, clientNo, paymentDate, paymentAmount, paymentTotal)
VALUES ('03', 'C6', TO_DATE('2022-03-01', 'YYYY-MM-DD'), 7000, 18000);

INSERT INTO Payment (paymentID, clientNo, paymentDate, paymentAmount, paymentTotal)
VALUES ('04', 'C11', TO_DATE('2022-04-01', 'YYYY-MM-DD'), 10000, 18000);

INSERT INTO Payment (paymentID, clientNo, paymentDate, paymentAmount, paymentTotal)
VALUES ('05', 'C6', TO_DATE('2022-08-01', 'YYYY-MM-DD'), 10000, 20000);

INSERT INTO Payment (paymentID, clientNo, paymentDate, paymentAmount, paymentTotal)
VALUES ('06', 'C9', TO_DATE('2022-04-01', 'YYYY-MM-DD'), 15000, 21000);

INSERT INTO Payment (paymentID, clientNo, paymentDate, paymentAmount, paymentTotal)
VALUES ('07', 'C9', TO_DATE('2022-04-02', 'YYYY-MM-DD'), 5000, 21000);

INSERT INTO Payment (paymentID, clientNo, paymentDate, paymentAmount, paymentTotal)
VALUES ('08', 'C11', TO_DATE('2022-04-02', 'YYYY-MM-DD'), 25000, 45000);


INSERT INTO SecurityDuration (durationID, numberOfWeeks, arrangementNo) VALUES 
('01', 4, 'SA1');
INSERT INTO SecurityDuration (durationID, numberOfWeeks, arrangementNo) VALUES 
('02', 4, 'SA2');
INSERT INTO SecurityDuration (durationID, numberOfWeeks, arrangementNo) VALUES 
('03', 6, 'SA3');
INSERT INTO SecurityDuration (durationID, numberOfWeeks, arrangementNo) VALUES 
('04', 5, 'SA4');
INSERT INTO SecurityDuration (durationID, numberOfWeeks, arrangementNo) VALUES 
('05', 5, 'SA5');
INSERT INTO SecurityDuration (durationID, numberOfWeeks, arrangementNo) VALUES 
('06', 6, 'SA6');
INSERT INTO SecurityDuration (durationID, numberOfWeeks, arrangementNo) VALUES 
('07', 6, 'SA7');
INSERT INTO SecurityDuration (durationID, numberOfWeeks, arrangementNo) VALUES 
('08', 7, 'SA8');
INSERT INTO SecurityDuration (durationID, numberOfWeeks, arrangementNo) VALUES 
('09', 4, 'SA9');
INSERT INTO SecurityDuration (durationID, numberOfWeeks, arrangementNo) VALUES 
('10', 8, 'SA10');


INSERT INTO Availability (availabilityID, empNo, startDate, endDate) VALUES
('AV1', '01', '01-JAN-2023', '25-FEB-2023');
INSERT INTO Availability (availabilityID, empNo, startDate, endDate) VALUES
('AV2', '02', '01-JAN-2023', '08-FEB-2023');
INSERT INTO Availability (availabilityID, empNo, startDate, endDate) VALUES
('AV3', '03', '01-JAN-2023', '24-FEB-2023');
INSERT INTO Availability (availabilityID, empNo, startDate, endDate) VALUES
('AV4', '04', '01-JAN-2023', '07-FEB-2023');
INSERT INTO Availability (availabilityID, empNo, startDate, endDate) VALUES
('AV5', '05', '01-JAN-2023', '04-FEB-2023');
INSERT INTO Availability (availabilityID, empNo, startDate, endDate) VALUES
('AV6', '06', '01-JAN-2023', '20-FEB-2023');
INSERT INTO Availability (availabilityID, empNo, startDate, endDate) VALUES
('AV7', '07', '01-JAN-2023', '27-FEB-2023');
INSERT INTO Availability (availabilityID, empNo, startDate, endDate) VALUES
('AV8', '08', '01-JAN-2023', '07-FEB-2023');
INSERT INTO Availability (availabilityID, empNo, startDate, endDate) VALUES
('AV9', '09', '01-JAN-2023', '26-FEB-2023');
INSERT INTO Availability (availabilityID, empNo, startDate, endDate) VALUES
('AV10', '10', '01-JAN-2023', '23-FEB-2023');

INSERT INTO Assignment (assignmentID, empNo, arrangementNo, shiftNumber)
VALUES ('01', '03', 'SA1', '1');

INSERT INTO Assignment (assignmentID, empNo, arrangementNo, shiftNumber)
VALUES ('02', '02', 'SA2', '2');

INSERT INTO Assignment (assignmentID, empNo, arrangementNo, shiftNumber)
VALUES ('03', '07', 'SA3', '1');

INSERT INTO Assignment (assignmentID, empNo, arrangementNo, shiftNumber)
VALUES ('05', '08', 'SA5', '2');

INSERT INTO Assignment (assignmentID, empNo, arrangementNo, shiftNumber)
VALUES ('06', '06', 'SA6', '2');

INSERT INTO Assignment (assignmentID, empNo, arrangementNo, shiftNumber)
VALUES ('07', '04', 'SA7', '2');


INSERT INTO SiteVisit (visitID, siteNo, managerNo, visitDate, comments)
VALUES ('01', 'S1', 'M3', '10-JAN-2023', 'Site was clean and secure.');

INSERT INTO SiteVisit (visitID, siteNo, managerNo, visitDate, comments)
VALUES ('02', 'S2', 'M1', '22-JAN-2023', 'Site had some maintenance issues.');

INSERT INTO SiteVisit (visitID, siteNo, managerNo, visitDate, comments)
VALUES ('03', 'S3', 'M2', '15-JAN-2023', 'Site was well-staffed and organized.');

INSERT INTO SiteVisit (visitID, siteNo, managerNo, visitDate, comments)
VALUES ('04', 'S1', 'M1', '10-FEB-2023', 'Site had some safety concerns.');

INSERT INTO SiteVisit (visitID, siteNo, managerNo, visitDate, comments)
VALUES ('05', 'S2', 'M3', '01-FEB-2023', 'Site was running smoothly.');


SELECT * FROM EMPLOYEE;
SELECT * FROM MANAGER;
SELECT * FROM SITEVISIT;
SELECT * FROM CLIENT;
SELECT * FROM SITE;
SELECT * FROM SECURITYARRANGEMENT;
SELECT * FROM ASSIGNMENT;
SELECT * FROM SECURITYDURATION;
SELECT * FROM BILL;
SELECT * FROM PAYMENT;
SELECT * FROM AVAILABILITY;
-- CLIENTS AND SITES AND SECURITRY ASSIGNMENTS FOR JANUARY.

SELECT c.clientName, s.siteName, sa.startDate, sa.endDate, c.clientType
FROM Client c
INNER JOIN Site s ON c.clientID = s.clientNo
INNER JOIN SecurityArrangement sa ON s.siteID = sa.siteNo
WHERE sa.startDate >= TO_DATE('01-JAN-2023', 'DD-MON-YYYY') AND sa.endDate <= TO_DATE('30-MAR-2023', 'DD-MON-YYYY');


SELECT c.clientID, c.clientName, c.street, c.postcode, c.city, SUM(p.paymentAmount) AS paymentTotal
FROM Client c
JOIN Payment p ON c.clientID = p.clientNo
GROUP BY c.clientID, c.clientName, c.street, c.postcode, c.city
ORDER BY paymentTotal DESC
FETCH FIRST 1 ROW ONLY;



π c.clientName, s.siteName, sa.startDate, sa.endDate, c.clientType (
σ sa.startDate ≥ TO_DATE('01-JAN-2023', 'DD-MON-YYYY') ∧ sa.endDate ≤ TO_DATE('30-MAR-2023', 'DD-MON-YYYY') (
C ⨝ S (C.clientID = S.clientNo) ⨝ SA (S.siteID = SA.siteNo)
)
)


π c.clientID, c.clientName, c.street, c.postcode, c.city, SUM(p.paymentAmount) AS paymentTotal (
    Client c ⨝ p.clientNo = c.clientID Payment
  ) 
⊳ paymentTotal DESC
↓
ρ top1 (σ rownum = 1 (⊕))
