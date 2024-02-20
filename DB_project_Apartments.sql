-----------------------------------------------
-----------------------------------------------
drop table servicii cascade constraints;
drop table cheltuieli cascade constraints;
drop table intretinere cascade constraints;
drop table locatari cascade constraints;
drop table apartamente cascade constraints;
drop table propietari cascade constraints;
-----------------------------------------------

----- cerinta 3 -----
-- Construirea bazei de date – tabele, legături între tabele și restricții de integritate.
-- operații LDD(CREATE, ALTER, DROP)(minim 8).

--- tab no 1 PROPRIETARI ---
CREATE TABLE PROPIETARI(
    prop_id NUMBER(5) PRIMARY KEY,
    nume VARCHAR2(30),
    prenume VARCHAR2(30),
    data_nastere DATE,
    cnp NUMBER(13) UNIQUE,
    telefon NUMBER(10),
    email VARCHAR2(50)
);


--- tab no 2 APARTAMENTE ---
--- no 2 APARTAMENTE ---
CREATE TABLE APARTAMENTE (
    ap_id NUMBER(4) PRIMARY KEY,
    tip_ap VARCHAR2(25),
    suprafata NUMBER(5,2), -- in m^2
    disponibilitate VARCHAR2(15) NOT NULL CHECK (disponibilitate IN ('unavailable', 'available')),
    pret NUMBER(8,2),  -- in euro
    prop_id_fk NUMBER(5),
    CONSTRAINT prop_id_fk FOREIGN KEY (prop_id_fk) REFERENCES PROPIETARI(prop_id)
);

---- CREARE SI ACTUALIZARE STRUCTURA TAB LOCATARI ----
--- tab no 3 LOCATARI ---
--- creare copie tabela dar fara inregistrari ---
CREATE TABLE LOCATARI AS
SELECT * FROM PROPIETARI WHERE 1 = 0;

ALTER TABLE LOCATARI
RENAME COLUMN prop_id TO loc_id;
ALTER TABLE LOCATARI
MODIFY loc_id NUMBER(6);

ALTER TABLE LOCATARI
DROP COLUMN data_nastere;

ALTER TABLE LOCATARI
ADD ap_id_fk NUMBER(4);
ALTER TABLE LOCATARI
ADD CONSTRAINT loc_ap_id_fk FOREIGN KEY (ap_id_fk) REFERENCES APARTAMENTE(ap_id);

ALTER TABLE LOCATARI
ADD CONSTRAINT cnp_unique UNIQUE (cnp);

/*
---- varianta de creare directa a tab LOCATARI ----
--- tab no 3 LOCATARI ---
CREATE TABLE LOCATARI(
    loc_id NUMBER(6) PRIMARY KEY,
    nume VARCHAR2(30),
    prenume VARCHAR2(30),
    cnp NUMBER(13) UNIQUE,
    telefon NUMBER(10),
    email VARCHAR2(50),
    ap_id_fk NUMBER(4),
    CONSTRAINT loc_ap_id_fk FOREIGN KEY (ap_id_fk) REFERENCES APARTAMENTE(ap_id)
);
*/

--- tab no 4 INTRETINERE ---
CREATE TABLE INTRETINERE(
    intr_id NUMBER(6) PRIMARY KEY,
    cost_apa NUMBER(5,2),
    cost_gaze NUMBER(5,2),
    cost_caldura NUMBER(5,2),
    data_intr DATE, -- data emitere
    status VARCHAR2(10) NOT NULL CHECK (status IN ('paid', 'unpaid')),
    ap_id_fk NUMBER(4),
    CONSTRAINT int_ap_id_fk FOREIGN KEY (ap_id_fk) REFERENCES APARTAMENTE(ap_id)
);


--- tab no 5 CHELTUIELI ---
CREATE TABLE CHELTUIELI(
    ch_id NUMBER(6) PRIMARY KEY,
    tip_ch VARCHAR2(50),
    cost_ch NUMBER(5,2),
    data_ch DATE, -- data emitere
    status VARCHAR2(10) NOT NULL CHECK (status IN ('paid', 'unpaid')),
    ap_id_fk_ch NUMBER(4),
    CONSTRAINT ch_ap_id_fk FOREIGN KEY (ap_id_fk_ch) REFERENCES APARTAMENTE(ap_id)
);


--- tab no 6 SERVICII ---
CREATE TABLE SERVICII(
    serv_id NUMBER(6) PRIMARY KEY,
    tip_serv VARCHAR2(50),
    cost_serv NUMBER(5,2),
    data_serv DATE, -- data emitere
    status VARCHAR2(10) NOT NULL CHECK (status IN ('paid', 'unpaid')),
    ap_id_fk_serv NUMBER(4),
    CONSTRAINT serv_ap_id_fk FOREIGN KEY (ap_id_fk_serv) REFERENCES APARTAMENTE(ap_id)
);

----- ACTUALIZARE STRUCTURI TABELE ------
---- adaugare restrictii ca toate costurile sa fie suma pozitiva ----
ALTER TABLE INTRETINERE
ADD CONSTRAINT pozitiv_cost_apa CHECK (cost_apa >= 0);
    
ALTER TABLE INTRETINERE
ADD CONSTRAINT pozitiv_cost_gaze CHECK (cost_gaze >= 0);

ALTER TABLE INTRETINERE
ADD CONSTRAINT pozitiv_cost_caldura CHECK (cost_caldura >= 0);
describe INTRETINERE;

ALTER TABLE CHELTUIELI
ADD CONSTRAINT pozitiv_cost_ch CHECK(cost_ch >= 0);
describe CHELTUIELI;

ALTER TABLE SERVICII
ADD CONSTRAINT pozitiv_cost_serv CHECK(cost_serv >= 0);
describe SERVICII;

---- modificare precizie numar pt ca toate costurile sa fie number(7,2) ----
ALTER TABLE INTRETINERE MODIFY cost_apa number(7,2);
ALTER TABLE INTRETINERE MODIFY cost_gaze number(7,2);
ALTER TABLE INTRETINERE MODIFY cost_caldura number(7,2);
describe INTRETINERE;

ALTER TABLE CHELTUIELI MODIFY cost_ch number(7,2);
describe CHELTUIELI;

ALTER TABLE SERVICII MODIFY cost_serv number(7,2);
describe SERVICII;


---- adaugare unei coloane in tabela INTRETINERE ----
ALTER TABLE INTRETINERE ADD cost_lumina number(4,2);
describe INTRETINERE;

--- modificare unei coloane in tabela INTRETINERE ---
ALTER TABLE INTRETINERE 
MODIFY cost_lumina number(6,1);
describe INTRETINERE;

--- adaugare unei restrictii de integritate coloanei ---
ALTER TABLE INTRETINERE 
ADD CONSTRAINT poz_cost_lumina CHECK(cost_lumina >= 0);
describe INTRETINERE;

--- dezactivarea restrictiei de intergitatea a coloanei ---
ALTER TABLE INTRETINERE 
DISABLE CONSTRAINT poz_cost_lumina;
describe INTRETINERE;

--- stergerea restrictiei de intergitatea a coloanei ---
ALTER TABLE INTRETINERE 
DROP CONSTRAINT poz_cost_lumina;

--- stergerea unei coloane in tabela INTRETINERE ---
ALTER TABLE INTRETINERE 
DROP COLUMN cost_lumina;
describe INTRETINERE;


----------------------------------------------------------------------------------------------
select * from servicii;
select * from cheltuieli;
select * from intretinere;
select * from locatari;
select * from apartamente;
select * from propietari;
-----------------------------------------------

---------------------------------------------------------------------------------
----------------------------------------------------------------------------
---- cerinta 5 -- Adaugarea inregistrarilor in tablele (min 10/tab) ----

-----------------------------------------------
---- 11 inregistrari PROPIETARI ---
INSERT INTO PROPIETARI VALUES (100, 'Demesco', 'Alexandra', TO_DATE('14-05-2003', 'DD-MM-YYYY'), 6030514420122, 0770487840, 'alexa.demesc@gmail.com'); -- 1 x penthouse
INSERT INTO PROPIETARI VALUES (101, 'Ionescu', 'Maria', TO_DATE('20-06-1975', 'DD-MM-YYYY'), 7506200123456, 0771123456, 'maria.ionescu@yahoo.com'); -- 2 x 2 cam
INSERT INTO PROPIETARI VALUES (102, 'Vasilescu', 'Andrei', TO_DATE('10-03-1990', 'DD-MM-YYYY'), 9000310123456, 0740987654, 'andrei.vasilescu@gmail.com'); -- 2 x 2 cam
INSERT INTO PROPIETARI VALUES (103, 'Georgescu', 'Ana', TO_DATE('05-12-1988', 'DD-MM-YYYY'), 8812050123456, 0721567890, 'ana.georgescu@yahoo.com'); -- 4 cam + 2 cam + garsoniera
INSERT INTO PROPIETARI VALUES (104, 'Popa', 'Alex', TO_DATE('18-09-1972', 'DD-MM-YYYY'), 7209180123456, 0734455667, 'alex.popa@yahoo.com'); -- 4 cam
INSERT INTO PROPIETARI VALUES (105, 'Popescu', 'Ion', TO_DATE('15-01-1980', 'DD-MM-YYYY'), 8001150123456, 0780998876, 'ion.popescu@gmail.com'); -- 2 cam + 1 garsoniera
INSERT INTO PROPIETARI VALUES (106, 'Dragomir', 'Elena', TO_DATE('25-04-1995', 'DD-MM-YYYY'), 9504250123456, 0790887766, 'elena.dragomir@gmail.com'); -- 1 x garsoniera
INSERT INTO PROPIETARI VALUES (107, 'Maciuc', 'Bartolomeu', TO_DATE('15-01-1980', 'DD-MM-YYYY'), 8001150155456, 0751122334, 'bart.maciuc@gmail.com'); -- 3 cam
INSERT INTO PROPIETARI VALUES (108, 'Dinescu', 'Marcel', TO_DATE('15-01-1980', 'DD-MM-YYYY'), 8001150128456, 0711122334, 'marc.dinescu@gmail.com'); -- 2 garsoniere
INSERT INTO PROPIETARI VALUES (109, 'Patrocle', 'Lizuca', TO_DATE('25-04-1995', 'DD-MM-YYYY'), 9504250127956, 0771657879, 'lizu.patrocle@gmail.com'); -- 2 x 3 cam + 1 garsoniera
INSERT INTO PROPIETARI VALUES (110, 'Dumitrescu', 'Gigel', TO_DATE('12-03-1998', 'DD-MM-YYYY'), 9803120123456, 0761122334, 'gigel.dumitrescu@gmail.com'); -- 1 penthouse

-----------------------------------------------
---- 55 inregistrari APARTAMENTE ---
select * from apartamente
order by ap_id asc;

select * from apartamente
where prop_id_fk is not null;

delete from apartamente
where ap_id >=40 and ap_id <=49;

TRUNCATE TABLE LOCATARI;
-- layout insert values (ap_id, tip_ap, suprafata, disponibilitate, pret, prop_id_fk) 

--- 7 garsoniere (ap_id 1->19) ---
INSERT INTO APARTAMENTE VALUES (1, 'garsoniera', 31.5, 'unavailable', 50000, 103);
INSERT INTO APARTAMENTE VALUES (2, 'garsoniera', 35.0, 'unavailable', 55000, 105);
INSERT INTO APARTAMENTE VALUES (3, 'garsoniera', 33.6, 'available', 52000, null);
INSERT INTO APARTAMENTE VALUES (4, 'garsoniera', 31.5, 'unavailable', 50000, 106);
INSERT INTO APARTAMENTE VALUES (5, 'garsoniera', 35.0, 'unavailable', 55000, 108);
INSERT INTO APARTAMENTE VALUES (6, 'garsoniera', 33.6, 'unavailable', 52000, 109);
INSERT INTO APARTAMENTE VALUES (7, 'garsoniera', 31.5, 'unavailable', 50000, 108);
INSERT INTO APARTAMENTE VALUES (8, 'garsoniera', 31.5, 'available', 50000, null);
INSERT INTO APARTAMENTE VALUES (9, 'garsoniera', 35.0, 'available', 55000, null);
INSERT INTO APARTAMENTE VALUES (10, 'garsoniera', 33.6, 'available', 52000, null);
INSERT INTO APARTAMENTE VALUES (11, 'garsoniera', 31.5, 'available', 50000, null);
INSERT INTO APARTAMENTE VALUES (12, 'garsoniera', 35.0, 'available', 55000, null);
INSERT INTO APARTAMENTE VALUES (13, 'garsoniera', 33.6, 'available', 52000, null);
INSERT INTO APARTAMENTE VALUES (14, 'garsoniera', 31.5, 'available', 50000, null);
INSERT INTO APARTAMENTE VALUES (15, 'garsoniera', 35.0, 'available', 55000, null);
INSERT INTO APARTAMENTE VALUES (16, 'garsoniera', 33.6, 'available', 52000, null);
INSERT INTO APARTAMENTE VALUES (17, 'garsoniera', 31.5, 'available', 50000, null);
INSERT INTO APARTAMENTE VALUES (18, 'garsoniera', 35.0, 'available', 55000, null);
INSERT INTO APARTAMENTE VALUES (19, 'garsoniera', 33.6, 'available', 52000, null);

--- 7 * 2-camere (ap_id 20->29) ---
INSERT INTO APARTAMENTE VALUES (20, '2-camere', 62.5, 'unavailable', 72000, 101);
INSERT INTO APARTAMENTE VALUES (21, '2-camere', 65.0, 'unavailable', 75000, 101);
INSERT INTO APARTAMENTE VALUES (22, '2-camere', 68.6, 'unavailable', 77000, 102);
INSERT INTO APARTAMENTE VALUES (23, '2-camere', 62.5, 'unavailable', 72000, 103);
INSERT INTO APARTAMENTE VALUES (24, '2-camere', 65.0, 'unavailable', 75000, 102);
INSERT INTO APARTAMENTE VALUES (25, '2-camere', 68.6, 'unavailable', 77000, 105);
INSERT INTO APARTAMENTE VALUES (26, '2-camere', 62.5, 'available', 72000, null);
INSERT INTO APARTAMENTE VALUES (27, '2-camere', 62.5, 'available', 72000, null);
INSERT INTO APARTAMENTE VALUES (28, '2-camere', 65.0, 'available', 75000, null);
INSERT INTO APARTAMENTE VALUES (29, '2-camere', 68.6, 'available', 77000, null);


--- 5 * 3-camere (ap_id 30->39) ---
INSERT INTO APARTAMENTE VALUES (30, '3-camere', 82.5, 'unavailable', 92000, 107);
INSERT INTO APARTAMENTE VALUES (31, '3-camere', 79.6, 'unavailable', 90000, 109);
INSERT INTO APARTAMENTE VALUES (32, '3-camere', 82.5, 'available', 92000, null);
INSERT INTO APARTAMENTE VALUES (33, '3-camere', 79.6, 'unavailable', 90000, 109);
INSERT INTO APARTAMENTE VALUES (34, '3-camere', 82.5, 'available', 92000, null);
INSERT INTO APARTAMENTE VALUES (35, '3-camere', 82.5, 'available', 92000, null);
INSERT INTO APARTAMENTE VALUES (36, '3-camere', 79.6, 'available', 90000, null);
INSERT INTO APARTAMENTE VALUES (37, '3-camere', 92.5, 'available', 92000, null);
INSERT INTO APARTAMENTE VALUES (38, '3-camere', 79.6, 'available', 90000, null);
INSERT INTO APARTAMENTE VALUES (39, '3-camere', 82.5, 'available', 92000, null);

--- 5 * 4-camere (ap_id 40->49) ---
INSERT INTO APARTAMENTE VALUES (40, '4-camere', 95.5, 'unavailable', 111000, 103);
INSERT INTO APARTAMENTE VALUES (41, '4-camere', 90.7, 'available', 109000, null);
INSERT INTO APARTAMENTE VALUES (42, '4-camere', 95.5, 'unavailable', 111000, 104);
INSERT INTO APARTAMENTE VALUES (43, '4-camere', 90.7, 'available', 109000, null);
INSERT INTO APARTAMENTE VALUES (44, '4-camere', 95.5, 'available', 111000, null);
INSERT INTO APARTAMENTE VALUES (45, '4-camere', 90.7, 'available', 109000, null);
INSERT INTO APARTAMENTE VALUES (46, '4-camere', 95.5, 'available', 111000, null);
INSERT INTO APARTAMENTE VALUES (47, '4-camere', 90.7, 'available', 109000, null);
INSERT INTO APARTAMENTE VALUES (48, '4-camere', 95.5, 'available', 111000, null);
INSERT INTO APARTAMENTE VALUES (49, '4-camere', 90.7, 'available', 109000, null);

--- 6 penthouse (ap_id 50->55) ---
INSERT INTO APARTAMENTE VALUES (50, 'penthouse', 185.2, 'unavailable', 355000, 100);
INSERT INTO APARTAMENTE VALUES (51, 'penthouse', 185.2, 'available', 355000, null);
INSERT INTO APARTAMENTE VALUES (52, 'penthouse', 185.2, 'unavailable', 355000, 110);
INSERT INTO APARTAMENTE VALUES (53, 'penthouse', 185.2, 'available', 355000, null);
INSERT INTO APARTAMENTE VALUES (54, 'penthouse', 185.2, 'available', 355000, null);
INSERT INTO APARTAMENTE VALUES (55, 'penthouse', 185.2, 'available', 355000, null);

-----------------------------------------------
---- 15 inregistrari LOCATARI ---
select * from locatari
order by loc_id asc;

delete from LOCATARI
where loc_id >= 100 and loc_id<=110;

--- 11 inreg locatari prin MERGE (optional) --- 
--- propietarii sunt locatari pt primul apartament la care sunt inregistrati ---
MERGE INTO LOCATARI L
USING (
    SELECT P.prop_id AS loc_id, P.nume, P.prenume, P.cnp, P.telefon, P.email, MIN(A.ap_id) AS ap_id_fk
    FROM PROPIETARI P
    LEFT JOIN APARTAMENTE A ON A.prop_id_fk = P.prop_id
    GROUP BY P.prop_id, P.nume, P.prenume, P.cnp, P.telefon, P.email
) R ON (L.loc_id = R.loc_id)
WHEN NOT MATCHED THEN
    INSERT (loc_id, nume, prenume, cnp, telefon, email, ap_id_fk)
    VALUES (R.loc_id, R.nume, R.prenume, R.cnp, R.telefon, R.email, R.ap_id_fk);
-------------------------------------

delete from LOCATARI
where loc_id >= 100 and loc_id<=110;

--- 11 inreg inserare manuala --
-- propietarii sunt locatari la ap_id inserate manual/cel mai spatios tip de apartament pe care il detin --
INSERT INTO LOCATARI VALUES (100, 'Demesco', 'Alexandra', 6030514420122, 0770487840, 'alexa.demesc@gmail.com', 50); -- penthouse
INSERT INTO LOCATARI VALUES (101, 'Ionescu', 'Maria', 7506200123456, 0771123456, 'maria.ionescu@yahoo.com', 20); -- 2-cam
INSERT INTO LOCATARI VALUES (102, 'Vasilescu', 'Andrei', 9000310123456, 0740987654, 'andrei.vasilescu@gmail.com', 22); -- 2-cam
INSERT INTO LOCATARI VALUES (103, 'Georgescu', 'Ana', 8812050123456, 0721567890, 'ana.georgescu@yahoo.com', 40); -- 4-cam
INSERT INTO LOCATARI VALUES (104, 'Popa', 'Alex', 7209180123456, 0734455667, 'alex.popa@yahoo.com', 42); -- 4-cam
INSERT INTO LOCATARI VALUES (105, 'Popescu', 'Ion', 8001150123456, 0780998876, 'ion.popescu@gmail.com', 25); -- 2-cam
INSERT INTO LOCATARI VALUES (106, 'Dragomir', 'Elena', 9504250123456, 0790887766, 'elena.dragomir@gmail.com', 4); -- arsoniera
INSERT INTO LOCATARI VALUES (107, 'Maciuc', 'Bartolomeu', 8001150155456, 0751122334, 'bart.maciuc@gmail.com', 30); -- 3-cam
INSERT INTO LOCATARI VALUES (108, 'Dinescu', 'Marcel', 8001150128456, 0711122334, 'marc.dinescu@gmail.com', 5); -- garsoniere
INSERT INTO LOCATARI VALUES (109, 'Patrocle', 'Lizuca', 9504250127956, 0771657879, 'lizu.patrocle@gmail.com', 31); -- 3-cam
INSERT INTO LOCATARI VALUES (110, 'Dumitrescu', 'Gigel', 9803120123456, 0761122334, 'gigel.dumitrescu@gmail.com', 52); -- penthouse

-- propietarii si locatar=> loc_id: 100->155
-- doar locatar=> loc_id: peste 155

--- 5 inreg locatari care nu sunt propietari ---
INSERT INTO LOCATARI VALUES (155, 'Dumitrescu', 'Marioara', 2970302236170, 0724567980, 'mari.dumitrescu@yahoo.com', 52);
INSERT INTO LOCATARI VALUES (156, 'Popa', 'Cristiana', 2710818234714, 0724477889, 'cris.popa@gmail.com', 42);
INSERT INTO LOCATARI VALUES (157, 'Dragovici', 'Vlad', 1990620235065, 0771659801, 'vald.dragovico@gmail.com', 6);
INSERT INTO LOCATARI VALUES (158, 'Moraru', 'Petru', 1851115235120, 0775973452, 'petru.moraru@yahoo.com', 23);
INSERT INTO LOCATARI VALUES (159, 'Vasilescu', 'Andreea', 2910405236472, 0754577984, 'andreea.vasilescu@gmail.com', 22);

select * from locatari
order by ap_id_fk asc;

----------------------------------------------------------------------------
---- 19 inregistrari INTRETINERE pt cele 19 apartamente 'unavaible' ---
--- intretinere pe luna octombrie cu emitere facturare pe  28/11/2023 ---
INSERT INTO INTRETINERE VALUES (1, 3.00, 1.00, 7.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 1);
INSERT INTO INTRETINERE VALUES (2, 3.00, 1.00, 7.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'unpaid', 2);
INSERT INTO INTRETINERE VALUES (3, 76.00, 45.00, 136.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 4);
INSERT INTO INTRETINERE VALUES (4, 75.00, 45.00, 135.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 5);
INSERT INTO INTRETINERE VALUES (5, 80.00, 45.00, 140.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 6);
INSERT INTO INTRETINERE VALUES (6, 3.00, 1.00, 7.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'unpaid', 7);
INSERT INTO INTRETINERE VALUES (7, 85.00, 45.00, 270.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 20);
INSERT INTO INTRETINERE VALUES (8, 4.00, 2.00, 8.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'unpaid', 21);
INSERT INTO INTRETINERE VALUES (9, 95.00, 50.00, 275.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 22);
INSERT INTO INTRETINERE VALUES (10, 85.00, 45.00, 270.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 23;
INSERT INTO INTRETINERE VALUES (11, 4.00, 2.00, 8.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 24);
INSERT INTO INTRETINERE VALUES (12, 80.00, 45.00, 280.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'unpaid', 25);
INSERT INTO INTRETINERE VALUES (13, 85.00, 50.00, 380.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 30);
INSERT INTO INTRETINERE VALUES (14, 90.00, 50.00, 390.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'unpaid', 31);
INSERT INTO INTRETINERE VALUES (15, 5.00, 2.00, 10.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 33);
INSERT INTO INTRETINERE VALUES (16, 95.00, 50.00, 400.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 40);
INSERT INTO INTRETINERE VALUES (17, 100.00, 50.00, 560.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 42);
INSERT INTO INTRETINERE VALUES (18, 120.00, 60.00, 890.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 50);
INSERT INTO INTRETINERE VALUES (19, 125.00, 60.00, 960.00, TO_DATE('28-11-2023', 'DD-MM-YYYY'), 'paid', 52);

select * from intretinere
order by intr_id asc;

----------------------------------------------------------------------------
---- 10 inregistrari CHELTUIELI ---
-- 10 înregistrări unice pentru tabelul CHELTUIELI în luna noiembrie 2023
---- tipuri servicii: 
------ Intretinere lifturi
------ Energie electrica pt spatiile comune
------ Gestionarea deseurilor
------ Curatenia si intretinerea zonelor comune
------ Intretinere instalatii comune
INSERT INTO CHELTUIELI VALUES (1, 'Intretinere lifturi', 25.00, TO_DATE('01-11-2023', 'DD-MM-YYYY'), 'paid', 50);
INSERT INTO CHELTUIELI VALUES (2, 'Curatenia si intretinerea zonelor comune', 18.00, TO_DATE('02-11-2023', 'DD-MM-YYYY'), 'unpaid', 52);
INSERT INTO CHELTUIELI VALUES (3, 'Energie electrica pt spatiile comune', 30.00, TO_DATE('03-11-2023', 'DD-MM-YYYY'), 'paid', 20);
INSERT INTO CHELTUIELI VALUES (4, 'Gestionarea deseurilor', 12.00, TO_DATE('04-11-2023', 'DD-MM-YYYY'), 'unpaid', 22);
INSERT INTO CHELTUIELI VALUES (5, 'Intretinere instalatii comune', 40.00, TO_DATE('05-11-2023', 'DD-MM-YYYY'), 'paid', 31);
INSERT INTO CHELTUIELI VALUES (6, 'Curatenia si intretinerea zonelor comune', 18.00, TO_DATE('06-11-2023', 'DD-MM-YYYY'), 'unpaid', 20);
INSERT INTO CHELTUIELI VALUES (7, 'Energie electrica pt spatiile comune', 15.00, TO_DATE('07-11-2023', 'DD-MM-YYYY'), 'paid', 6);
INSERT INTO CHELTUIELI VALUES (8, 'Gestionarea deseurilor', 90.00, TO_DATE('08-11-2023', 'DD-MM-YYYY'), 'paid', 52);
INSERT INTO CHELTUIELI VALUES (9, 'Intretinere instalatii comune', 28.00, TO_DATE('09-11-2023', 'DD-MM-YYYY'), 'unpaid', 40);
INSERT INTO CHELTUIELI VALUES (10, 'Intretinere lifturi', 20.00, TO_DATE('10-11-2023', 'DD-MM-YYYY'), 'paid', 42);

select * from cheltuieli
order by ch_id asc;

----------------------------------------------------------------------------
---- 10 inregistrari SERVICII ---
-- 10 înregistrări unice pentru tabelul SERVICII în luna noiembrie 2023
---- tipuri servicii: 
------ Servicii de curatenie profesionala
------ Reparatii instalatii individuale
------ Abonament sala fitness
------ Servicii de securitate
INSERT INTO SERVICII VALUES (1, 'Servicii de curatenie profesionala', 300.00, TO_DATE('11-11-2023', 'DD-MM-YYYY'), 'paid', 50);
INSERT INTO SERVICII VALUES (2, 'Reparații instalatii individuale', 200.00, TO_DATE('12-11-2023', 'DD-MM-YYYY'), 'unpaid', 52);
INSERT INTO SERVICII VALUES (3, 'Servicii de securitate', 350.00, TO_DATE('13-11-2023', 'DD-MM-YYYY'), 'paid', 20);
INSERT INTO SERVICII VALUES (4, 'Servicii de securitate', 150.00, TO_DATE('14-11-2023', 'DD-MM-YYYY'), 'unpaid', 22);
INSERT INTO SERVICII VALUES (5, 'Reparații instalatii individuale', 450.00, TO_DATE('15-11-2023', 'DD-MM-YYYY'), 'unpaid', 22);
INSERT INTO SERVICII VALUES (6, 'Servicii de securitate', 220.00, TO_DATE('16-11-2023', 'DD-MM-YYYY'), 'paid', 42);
INSERT INTO SERVICII VALUES (7, 'Abonament sala fitness', 180.00, TO_DATE('17-11-2023', 'DD-MM-YYYY'), 'unpaid', 4);
INSERT INTO SERVICII VALUES (8, 'Servicii de securitate', 100.00, TO_DATE('18-11-2023', 'DD-MM-YYYY'), 'paid', 52);
INSERT INTO SERVICII VALUES (9, 'Servicii de curatenie profesionala', 320.00, TO_DATE('19-11-2023', 'DD-MM-YYYY'), 'paid', 40);
INSERT INTO SERVICII VALUES (10, 'Abonament sala fitness', 250.00, TO_DATE('20-11-2023', 'DD-MM-YYYY'), 'unpaid', 52);

select * from servicii
order by serv_id asc;

------------------------------------------------------------------------------
----------------------------------------------------------------------------
----- cerinta 6 -- Actualizarea datelor cu LMD (INSERT, UPDATE, DELETE) -----

---- actualizare nume tip serviciu si pretul acestuia in tabela SERVICII ----
UPDATE SERVICII
SET tip_serv = 'Abonament sala fitness', cost_serv = 120.00
WHERE serv_id = 5;

SELECT serv_id, tip_serv, cost_serv from SERVICII
WHERE serv_id = 5;


---- adaugarea, updatarea, si stergerea unui locatar ----
INSERT INTO LOCATARI (loc_id, nume, prenume, cnp, telefon, email, ap_id_fk)
VALUES (160, 'Petru', 'Cornelia', 1234567890123, 0734567890, 'cornelia.petru@gmail.com', 7);

UPDATE LOCATARI
SET prenume = 'Larisa'
WHERE loc_id = 160;

SELECT * from LOCATARI WHERE loc_id = 160;

--- se actualizeaza doar daca apartamentul este cumparat/unavaible ---
UPDATE LOCATARI
SET telefon = 0778234765, ap_id_fk = 2
WHERE loc_id = 160
AND ap_id_fk IN (SELECT ap_id FROM APARTAMENTE WHERE disponibilitate = 'unavailable');

DELETE FROM LOCATARI WHERE loc_id = 160;


-------------------------------------------------------------------------------
----------------------------------------------------------------------------
---- cerinta 7 -- Stergerea si recuperarea unei tabele ---
CREATE TABLE CHELTUIELI_COPIE AS
SELECT * FROM CHELTUIELI;

DROP TABLE CHELTUIELI_COPIE CASCADE CONSTRAINTS;
FLASHBACK TABLE CHELTUIELI_COPIE TO BEFORE DROP;

--- stergere copie definitiv:
PURGE TABLE CHELTUIELI_COPIE;


---------------------------------------------------------------------------------
----------------------------------------------------------------------------
--- cerinta 8 -- INTEROGARI ----

--- Jonctiune interna ce arata numarul de locatari in fiecare apartament care este ocupat/'unavaible' ----
SELECT A.ap_id, A.tip_ap, COUNT(L.loc_id) AS nr_locatari
FROM APARTAMENTE A
JOIN LOCATARI L ON A.ap_id = L.ap_id_fk
WHERE A.disponibilitate LIKE 'unavailable'
GROUP BY A.ap_id, A.tip_ap
ORDER BY A.ap_id asc;


--- Subcerere pentru totalul cost intretinere aferent fiecarui apartament 'unavaible' ---
SELECT A.ap_id, SUM(I.cost_apa + I.cost_gaze + I.cost_caldura) AS total_cost
FROM APARTAMENTE A
JOIN INTRETINERE I ON A.ap_id = I.ap_id_fk
WHERE A.disponibilitate = 'unavailable'
GROUP BY A.ap_id
ORDER BY A.ap_id asc;


--- Afisare ce fel de pret are fiecare apartament care este 'avaible' luand 75000 ca pret mediu ---
SELECT ap_id, tip_ap, pret,
       DECODE(SIGN(pret - 75000), 1, 'Pret mare', 0, 'Pret mediu', -1, 'Pret mic') AS evaluare_pret
FROM APARTAMENTE
WHERE prop_id_fk is null
ORDER BY ap_id DESC;


--- Jonctiune interna pentru afisarea apartamentelor care nu au platit intretinerea pana la SYSDATE(la zi) ---
SELECT a.ap_id, a.tip_ap, a.pret
FROM APARTAMENTE a
INNER JOIN INTRETINERE i ON a.ap_id = i.ap_id_fk
WHERE i.data_intr <= SYSDATE
AND i.status = 'unpaid';


--- Jonctiune externa si cu MINUS pentru a afisa propietarii si apartamentele in care nu locuieste nimeni desi ele 
--- sunt ocupate/'unavaible', iar pe anul anterior au avut intretinerea platita/status 'paid'
SELECT a.ap_id, a.tip_ap, p.nume, p.prenume, p.prop_id
FROM APARTAMENTE a
JOIN PROPIETARI p ON a.prop_id_fk = p.prop_id
WHERE a.disponibilitate = 'unavailable'
AND a.ap_id NOT IN (
    SELECT ap_id_fk FROM LOCATARI
    WHERE ap_id_fk IS NOT NULL
)
MINUS
SELECT a.ap_id, a.tip_ap, p.nume, p.prenume, p.prop_id
FROM APARTAMENTE a
JOIN PROPIETARI p ON a.prop_id_fk = p.prop_id
WHERE a.ap_id IN (
    SELECT ap_id_fk FROM INTRETINERE
    WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_intr) <= 1
    AND status = 'paid'
);

--- CASE si NVL pentru determinarea toatulul costurilor cheltuielilor si serviciilor pt fiecare apartament ---
SELECT A.ap_id, A.tip_ap,
NVL(SUM(CASE 
    WHEN C.cost_ch IS NOT NULL THEN C.cost_ch 
    ELSE 0 
    END), 0) AS total_cheltuieli,
    NVL(SUM(CASE 
        WHEN S.cost_serv IS NOT NULL THEN S.cost_serv 
        ELSE 0 
        END), 0) AS total_servicii
FROM APARTAMENTE A
LEFT JOIN CHELTUIELI C ON A.ap_id = C.ap_id_fk_ch
LEFT JOIN SERVICII S ON A.ap_id = S.ap_id_fk_serv
GROUP BY A.ap_id, A.tip_ap;

--------------------------------------------------------------------------------
----------------------------------------------------------------------------
--- cerinta 9 -- Indecși, Vederi, Secvențe, Sinonime

--- INDECSI ---
SELECT * FROM APARTAMENTE
WHERE suprafata < 60 AND tip_ap IN ('garsoniera', '2-camere');
CREATE INDEX index_ap_mici ON APARTAMENTE(suprafata, tip_ap);

SELECT * FROM APARTAMENTE
WHERE pret BETWEEN 90000 AND 200000;
CREATE INDEX index_ap_scumpe ON APARTAMENTE(pret);

select * from user_indexes
where table_name = 'APARTAMENTE';


--- VEDERI ---
--- afisare apartamentele cu cheltuieli sau servicii neplătite
CREATE VIEW view_unpaid_costs AS
SELECT 
    a.ap_id,
    a.tip_ap,
    NVL(SUM(CASE WHEN c.status = 'unpaid' THEN c.cost_ch ELSE 0 END), 0) AS total_ch_neplatite,
    NVL(SUM(CASE WHEN s.status = 'unpaid' THEN s.cost_serv ELSE 0 END), 0) AS total_serv_neplatite
FROM APARTAMENTE a
LEFT JOIN CHELTUIELI c ON a.ap_id = c.ap_id_fk_ch
LEFT JOIN SERVICII s ON a.ap_id = s.ap_id_fk_serv
WHERE c.status = 'unpaid' OR s.status = 'unpaid'
GROUP BY a.ap_id, a.tip_ap;

select * from user_views;

--- SECVENTE ---
CREATE SEQUENCE s_apart
  START WITH 100 
  INCREMENT BY 10
  MAXVALUE 260;  

INSERT INTO APARTAMENTE VALUES (s_apart.nextval, '&TIP_AP', 31.5, 'unavailable', 50000, 103);

select * from APARTAMENTE where ap_id>=100;
select * from user_sequences;

delete from apartamente where ap_id>=100;
drop sequence s_apart;


--- SINONIME ---

create synonym CH for CHELTUIELI;
create synonym L for LOCATARI;
select * from user_synonyms;
