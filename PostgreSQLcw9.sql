CREATE SCHEMA geo;

CREATE TABLE geo.GeoEon (
id_eon INTEGER PRIMARY KEY,
nazwa_eon varchar(30)
);

CREATE TABLE geo.GeoEra (
id_era INTEGER PRIMARY KEY,
id_eon INTEGER,
nazwa_era varchar(30)
);

CREATE TABLE geo.GeoOkres (
id_okres INTEGER PRIMARY KEY,
id_era INTEGER,
nazwa_okres varchar(30)
);

CREATE TABLE geo.GeoEpoka (
id_epoka INTEGER PRIMARY KEY,
id_okres INTEGER,
nazwa_epoka varchar(30)
);

CREATE TABLE geo.GeoPietro (
id_pietro INTEGER PRIMARY KEY,
id_epoka INTEGER,
nazwa_pietro varchar(30)
);

ALTER TABLE geo.GeoEra ADD FOREIGN KEY (id_eon)
    REFERENCES geo.GeoEon(id_eon);

ALTER TABLE geo.GeoOkres ADD FOREIGN KEY (id_era)
    REFERENCES geo.GeoEra(id_era);

ALTER TABLE geo.GeoEpoka ADD FOREIGN KEY (id_okres)
    REFERENCES geo.GeoOkres(id_okres);

ALTER TABLE geo.GeoPietro ADD FOREIGN KEY (id_epoka)
    REFERENCES geo.GeoEpoka(id_epoka);

INSERT INTO geo.GeoEon VALUES
(1, 'Fanerozoik');

INSERT INTO geo.GeoEra VALUES
(1, 1, 'Kenozoik'),
(2, 1, 'Mezozoik'),
(3, 1, 'Paleozoik');

INSERT INTO geo.GeoOkres VALUES
(1, 1, 'Czwartorzęd'),
(2, 1, 'Neogen'),
(3, 1, 'Paleogen'),
(4, 2, 'Kreda'),
(5, 2, 'Jura'),
(6, 2, 'Trias'),
(7, 3, 'Perm'),
(8, 3, 'Karbon'),
(9, 3, 'Dewon');

INSERT INTO geo.GeoEpoka VALUES
(1, 1, 'Holocen'),
(2, 1, 'Plejstocen'),
(3, 2, 'Pliocen'),
(4, 2, 'Miocen'),
(5, 3, 'Oligocen'),
(6, 3, 'Eocen'),
(7, 3, 'Paleocen'),
(8, 4, 'Póżna kreda'),
(9, 4, 'Wczesna kreda'),
(10, 5, 'Jura późna'),
(11, 5, 'Jura środkowa'),
(12, 5, 'Jura wczesna'),
(13, 6, 'Późny trias'),
(14, 6, 'Środkowy trias'),
(15, 6, 'Wczesny trias'),
(16, 7, 'Póżny perm'),
(17, 7, 'Wczesny perm'),
(18, 8, 'Późny karbon'),
(19, 8, 'Wczesny karbon'),
(20, 9, 'Późny dewon'),
(21, 9, 'Środkowy dewon'),
(22, 9, 'Wczesny dewon');

INSERT INTO geo.GeoPietro VALUES
(1,1,'megalaj'),
(2,1,'northgrip'),
(3,1,'grenland'),
(4,2,'późny[b]'),
(5,2,'chiban'),
(6,2,'kalabr'),
(7,2,'gelas'),
(8,3,'piacent'),
(9,3,'zankl'),
(10,4,'messyn'),
(11,4,'torton'),
(12,4,'serrawal'),
(13,4,'lang'),
(14,4,'burdygał'),
(15,4,'akwitan'),
(16,5,'szat'),
(17,5,'rupel'),
(18,6,'priabon'),
(19,6,'barton'),
(20,6,'lutet'),
(21,6,'iprez'),
(22,7,'tanet'),
(23,7,'zeland'),
(24,7,'dan'),
(25,8,'mastrycht'),
(26,8,'kampan'),
(27,8,'santon'),
(28,8,'koniak'),
(29,8,'turon'),
(30,8,'cenoman'),
(31,9,'alb'),
(32,9,'apt'),
(33,9,'barrem'),
(34,9,'hoteryw'),
(35,9,'walanżyn'),
(36,9,'berrias'),
(37,10,'tyton'),
(38,10,'kimeryd'),
(39,10,'oksford'),
(40,11,'kelowej'),
(41,11,'baton'),
(42,11,'bajos'),
(43,11,'aalen'),
(44,12,'toark'),
(45,12,'pliensbach'),
(46,12,'synemur'),
(47,12,'hettang'),
(48,13,'retyk'),
(49,13,'noryk'),
(50,13,'karnik'),
(51,14,'ladyn'),
(52,14,'anizyk'),
(53,15,'olenek'),
(54,15,'ind'),
(55,16,'czangsing'),
(56,16,'wucziaping'),
(57,16,'kapitan'),
(58,16,'word'),
(59,16,'road'),
(60,17,'kungur'),
(61,17,'artinsk'),
(62,17,'sakmar'),
(63,17,'assel'),
(64,18,'gżel'),
(65,18,'kasimow'),
(66,18,'moskow'),
(67,18,'baszkir'),
(68,19,'serpuchow'),
(69,19,'wizen'),
(70,19,'turnej'),
(71,20,'famen'),
(72,20,'fran'),
(73,21,'żywet'),
(74,21,'eifel'),
(75,22,'ems'),
(76,22,'prag'),
(77,22,'lochkow');

CREATE TABLE geo.GeoTabela AS 
(SELECT * FROM geo.GeoPietro 
 NATURAL JOIN geo.GeoEpoka NATURAL JOIN geo.GeoOkres NATURAL JOIN geo.GeoEra NATURAL JOIN geo.GeoEon );

CREATE TABLE geo.Dziesiec
(
cyfra int,
bit int
);

INSERT INTO geo.Dziesiec VALUES 
(0, 1), 
(1, 1), 
(2, 1), 
(3, 1), 
(4, 1), 
(5, 1), 
(6, 1), 
(7, 1), 
(8, 1), 
(9, 1);

CREATE TABLE geo.Milion
(
liczba int,
cyfra int,
bit int
);

INSERT INTO  geo.Milion SELECT a1.cyfra +10* a2.cyfra +100*a3.cyfra + 1000*a4.cyfra + 10000*a5.cyfra + 100000*a6.cyfra AS liczba , a1.cyfra AS cyfra, a1.bit AS bit 
FROM geo.Dziesiec a1, geo.Dziesiec a2, geo.Dziesiec a3, geo.Dziesiec a4, geo.Dziesiec a5, geo.Dziesiec a6 ;

--1 ZL
SELECT COUNT(*) FROM geo.Milion INNER JOIN geo.GeoTabela ON (mod(geo.Milion.liczba,68)=(geo.GeoTabela.id_pietro));

--2 ZL
SELECT COUNT(*) FROM geo.Milion INNER JOIN geo.GeoPietro  
ON (mod(geo.Milion.liczba,68)=geo.GeoPietro.id_pietro) NATURAL JOIN geo.GeoEpoka 
NATURAL JOIN geo.GeoOkres NATURAL JOIN geo.GeoEra NATURAL JOIN geo.GeoEon;

--3 ZL
SELECT COUNT(*) FROM geo.Milion WHERE mod(geo.Milion.liczba,68)= (SELECT id_pietro FROM geo.GeoTabela   WHERE mod(geo.Milion.liczba,68)=(id_pietro));

--4 ZL
SELECT COUNT(*) FROM geo.Milion
WHERE mod(geo.Milion.liczba,68) IN (SELECT geo.GeoPietro.id_pietro FROM geo.GeoPietro
NATURAL JOIN geo.GeoEpoka NATURAL JOIN geo.GeoOkres NATURAL JOIN geo.GeoEra NATURAL JOIN geo.GeoEon);

--INDEKSY
CREATE INDEX idx_eon ON geo.GeoEon (id_eon);
CREATE INDEX idx_era ON geo.GeoEra (id_era);
CREATE INDEX idx_okres ON geo.GeoOkres (id_okres);
CREATE INDEX idx_epoka ON geo.GeoEpoka (id_epoka);
CREATE INDEX idx_pietro ON geo.GeoPietro (id_pietro);
CREATE INDEX idx_milion ON geo.milion (liczba);
CREATE INDEX idx_dziesiec ON geo.dziesiec (cyfra);







