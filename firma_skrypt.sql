-- Database: firma

CREATE DATABASE firma;

CREATE SCHEMA rozliczenia;

CREATE TABLE rozliczenia.pracownicy(
	id_pracownika INT NOT NULL PRIMARY KEY, 
	imie VARCHAR(60) NOT NULL, 
	nazwisko VARCHAR(60) NOT NULL,
	adres VARCHAR(60),
	telefon VARCHAR(15)
);

CREATE TABLE rozliczenia.godziny(
	id_godziny INT NOT NULL PRIMARY KEY, 
	data DATE,
	liczba_godzin INT NOT NULL,
	id_pracownika INT NOT NULL
);

CREATE TABLE rozliczenia.pensje(
	id_pensji INT NOT NULL PRIMARY KEY, 
	stanowisko VARCHAR(30),
	kwota INT NOT NULL,
	id_premii INT
);

CREATE TABLE rozliczenia.premie(
	id_premioi INT NOT NULL PRIMARY KEY, 
	rodzaj VARCHAR(30),
	kwota INT NOT NULL
);

ALTER TABLE rozliczenia.godziny ADD CONSTRAINT FK_id_pracownika FOREIGN KEY (id_pracownika)
    REFERENCES rozliczenia.pracownicy(id_pracownika);
	
ALTER TABLE rozliczenia.pensje ADD CONSTRAINT FK_id_premii FOREIGN KEY (id_premii)
    REFERENCES rozliczenia.premie(id_premii);

INSERT INTO rozliczenia.pracownicy (id_pracownika,imie,nazwisko,adres,telefon) 
VALUES (0,'Karol', 'Kwasnik', 'Krakow', '123456789'),
(1,'Jan','Kowalski','Warszawa','987654321'),
(2,'Marian','Adamczyk','Gdansk','912654321'),
(3,'Maciej','Witczak','Warszawa','123123321'),
(4,'Lucjan','Przybylski','Szczecin','12312321'),
(5,'Eugeniusz','Szymanski','Krakow','657654321'),
(6,'Krzysztof','Tomaszewski','Warszawa','9767554321'),
(7,'Filip','Sawicki','Pcim','912314321'),
(8,'Eryk','Jankowski','Warszawa','912654321'),
(9,'Kuba','Kubiak','Starachowice','123134321');

INSERT INTO rozliczenia.godziny (id_godziny,data,liczba_godzin,id_pracownika) 
VALUES (0,'21-01-2020', 14, 0),
(1,'22-01-2020',8,0),
(2,'22-01-2020',8,1),
(3,'23-01-2020',10,2),
(4,'22-01-2020',9,3),
(5,'25-01-2020',6,4),
(6,'24-01-2020',11,5),
(7,'27-01-2020',5,1),
(8,'27-01-2020',8,6),
(9,'27-01-2020',9,7);

INSERT INTO rozliczenia.premie (id_premii,rodzaj,kwota) 
VALUES (0,'Nadgodziny',200),
(1,'Frekwencja',400),
(2,'Wyniki',1000),
(3,'Pracownik_miesiaca',500),
(4,'Pracownik_roku',2000),
(5,'Aktywnosc',100),
(6,'Oszczednosc',300),
(7,'Jakosc',400),
(8,'Bezawaryjnosc',200),
(9,'Bezwypadkowosc',100);

INSERT INTO rozliczenia.pensje (id_pensji,stanowisko,kwota,id_premii) 
VALUES (0,'Magazynier',2000,5),
(1,'Sprzataczka',3000,2),
(2,'Dostawca',1000,1),
(3,'Menedzer',5000,8),
(4,'Kierownik',20000,NULL),
(5,'Kierowca',1000,NULL),
(6,'Magazynier',3500,7),
(7,'Inzynier',4000,5),
(8,'Ksiegowy',10000,NULL),
(9,'Ochroniarz',1000,6);

SELECT nazwisko, adres FROM rozliczenia.pracownicy;

SELECT data,DATE_PART('dow', data) AS dzien_tygodnia, DATE_PART('month',data) AS miesiac FROM rozliczenia.godziny;

ALTER TABLE rozliczenia.pensje RENAME COLUMN kwota TO kwota_brutto;
ALTER TABLE rozliczenia.pensje ADD kwota_netto FLOAT;
UPDATE rozliczenia.pensje SET kwota_netto=kwota_brutto*0.75;

