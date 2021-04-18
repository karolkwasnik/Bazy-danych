--NIE ZAUWAŻYŁEM, ŻE TRZEBA NOWY SCHEMAT ZROBIĆ, WIĘC ZEDYTOWAŁEM STARY--

CREATE TABLE rozliczenia.wynagrodzenie(
	id_wynagrodzenia INT NOT NULL PRIMARY KEY, 
	data DATE,
	id_pracownika INT NOT NULL,
	id_godziny INT NOT NULL, 
	id_pensji INT NOT NULL,
	id_premii INT
)

ALTER TABLE rozliczenia.pensje DROP COLUMN id_premii;

ALTER TABLE rozliczenia.wynagrodzenie ADD FOREIGN KEY (id_pracownika)
    REFERENCES rozliczenia.pracownicy(id_pracownika);
	
ALTER TABLE rozliczenia.wynagrodzenie ADD FOREIGN KEY (id_godziny)
    REFERENCES rozliczenia.godziny(id_godziny);
	
ALTER TABLE rozliczenia.wynagrodzenie ADD FOREIGN KEY (id_pensji)
    REFERENCES rozliczenia.pensje(id_pensji);
	
ALTER TABLE rozliczenia.wynagrodzenie ADD FOREIGN KEY (id_premii)
    REFERENCES rozliczenia.premie(id_premii);
	
COMMENT ON TABLE rozliczenia.godziny IS 'Informacje o godzinach pracy';
COMMENT ON TABLE rozliczenia.pensje IS 'Informacje o pensjach pracownikow';
COMMENT ON TABLE rozliczenia.pracownicy IS 'Dane pracownikow';
COMMENT ON TABLE rozliczenia.premie IS 'Dane dotyczace premii';
COMMENT ON TABLE rozliczenia.wynagrodzenie IS 'Informacje o wynagrodzeniach';

INSERT INTO rozliczenia.wynagrodzenie (id_wynagrodzenia,data,id_pracownika,id_godziny,id_pensji,id_premii) 
VALUES 
(0,'21-01-2020', 0, 0, 0, 0),
(1,'22-02-2020', 1, 1, 1, 1),
(2,'23-03-2020', 2, 2, 2, NULL),
(3,'24-04-2020', 3, 3, 3, NULL),
(4,'25-05-2020', 4, 4, 4, 4),
(5,'26-06-2020', 5, 5, 5, 5),
(6,'27-07-2020', 6, 6, 6, 6),
(7,'28-08-2020', 7, 7, 7, NULL),
(8,'29-09-2020', 8, 8, 8, 8),
(9,'30-10-2020', 9, 9, 9, 9);

--a
SELECT id_pracownika,nazwisko FROM rozliczenia.pracownicy;

--b COALESCE returns the first argument that is not null
SELECT p.id_pracownika,kwota_netto,kwota AS premia,COALESCE(kwota_netto+kwota, kwota_netto, kwota) AS placa
FROM rozliczenia.pracownicy p 
JOIN ((rozliczenia.wynagrodzenie x LEFT JOIN rozliczenia.premie y ON x.id_premii=y.id_premii) w
JOIN rozliczenia.pensje p ON w.id_pensji = p.id_pensji) s
ON p.id_pracownika = s.id_pracownika WHERE COALESCE(kwota_netto+kwota, kwota_netto, kwota) >1000
ORDER BY p.id_pracownika ASC; 

--c
SELECT p.id_pracownika,kwota_netto,kwota AS premia,COALESCE(kwota_netto+kwota, kwota_netto, kwota) AS placa
FROM rozliczenia.pracownicy p 
JOIN ((rozliczenia.wynagrodzenie x LEFT JOIN rozliczenia.premie y ON x.id_premii=y.id_premii) w
JOIN rozliczenia.pensje p ON w.id_pensji = p.id_pensji) s
ON p.id_pracownika = s.id_pracownika 
WHERE kwota IS NULL AND COALESCE(kwota_netto+kwota, kwota_netto, kwota) >2000 ORDER BY p.id_pracownika ASC 

--d left() function is used to extract n number of characters specified in the argument from the left of a given string.
SELECT * FROM rozliczenia.pracownicy WHERE LEFT(imie,1) = 'J';

--e zamienilem litery zeby cokolwiek mi wyszukiwalo
SELECT * FROM rozliczenia.pracownicy 
WHERE (RIGHT(imie,1) = 'n') AND (pracownicy.nazwisko LIKE '%P%' OR  pracownicy.nazwisko LIKE '%p%');

--f
SELECT imie,nazwisko,liczba_godzin -160 AS nadgodziny 
FROM rozliczenia.godziny g JOIN rozliczenia.pracownicy p 
ON g.id_pracownika = p.id_pracownika WHERE liczba_godzin > 160

--g
SELECT imie,nazwisko,kwota_netto
FROM rozliczenia.pracownicy p JOIN 
(rozliczenia.wynagrodzenie w JOIN rozliczenia.pensje p ON w.id_pensji = p.id_pensji) s
ON p.id_pracownika = s.id_pracownika WHERE kwota_netto BETWEEN 1500 AND 3000;

--h 
SELECT imie,nazwisko,liczba_godzin -160 AS nadgodziny, kwota AS premia
FROM rozliczenia.godziny g 
JOIN (SELECT s.id_pracownika,imie,nazwisko,kwota FROM rozliczenia.pracownicy s  
	  JOIN (rozliczenia.wynagrodzenie x LEFT JOIN rozliczenia.premie y ON x.id_premii=y.id_premii) w
	  ON s.id_pracownika=w.id_pracownika) p
ON g.id_pracownika = p.id_pracownika WHERE liczba_godzin > 160 AND kwota IS NULL;

--i
SELECT kwota_netto,imie,nazwisko
FROM rozliczenia.pracownicy p JOIN 
(rozliczenia.wynagrodzenie w JOIN rozliczenia.pensje p ON w.id_pensji = p.id_pensji) s
ON p.id_pracownika = s.id_pracownika ORDER BY kwota_netto ASC;

--j
SELECT p.id_pracownika,kwota_netto,kwota AS premia
FROM rozliczenia.pracownicy p JOIN 
((rozliczenia.wynagrodzenie x LEFT JOIN rozliczenia.premie y ON x.id_premii=y.id_premii) w
JOIN rozliczenia.pensje p ON w.id_pensji = p.id_pensji) s
ON p.id_pracownika = s.id_pracownika ORDER BY kwota_netto DESC, kwota DESC

--k COUNT(*) returns the number of rows returned by a  SELECT statement, including NULL and duplicates.
SELECT stanowisko, COUNT(*) FROM rozliczenia.pensje GROUP BY stanowisko;

--l nie wiem jak to skrocic
SELECT stanowisko,MIN(COALESCE(kwota_netto+kwota,kwota_netto,kwota)),AVG(COALESCE(kwota_netto+kwota,kwota_netto,kwota)),MAX(COALESCE(kwota_netto+kwota,kwota_netto,kwota))
FROM  ((rozliczenia.wynagrodzenie x LEFT JOIN rozliczenia.premie y ON x.id_premii=y.id_premii) w
JOIN rozliczenia.pensje p ON w.id_pensji = p.id_pensji) s WHERE stanowisko = 'Magazynier' GROUP BY stanowisko;

--m
SELECT SUM(COALESCE(kwota_netto+kwota,kwota_netto,kwota)) AS suma_wynagrodzen
FROM  ((rozliczenia.wynagrodzenie x LEFT JOIN rozliczenia.premie y ON x.id_premii=y.id_premii) w
JOIN rozliczenia.pensje p ON w.id_pensji = p.id_pensji) s;

--n
SELECT stanowisko,SUM(COALESCE(kwota_netto+kwota,kwota_netto,kwota)) AS suma_wynagrodzen
FROM  ((rozliczenia.wynagrodzenie x LEFT JOIN rozliczenia.premie y ON x.id_premii=y.id_premii) w
JOIN rozliczenia.pensje p ON w.id_pensji = p.id_pensji) s GROUP BY stanowisko;

--o
SELECT stanowisko,COUNT(*)
FROM  ((rozliczenia.wynagrodzenie x LEFT JOIN rozliczenia.premie y ON x.id_premii=y.id_premii) w
JOIN rozliczenia.pensje p ON w.id_pensji = p.id_pensji) s WHERE kwota IS NOT NULL GROUP BY stanowisko;

--p DELETE usuwa wiersze pojedynczo i rejestruje wpis w dzienniku transakcji dla każdego usuniętego wiersza. TRUNCATE usuwa dane poprzez cofnięcie przydziału Data Pages
--nie moge usunac bo narusza to foreign key w tabeli godziny
DELETE FROM rozliczenia.pracownicy USING rozliczenia.pensje WHERE kwota_netto < 1200






















