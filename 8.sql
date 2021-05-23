--PDO statement (anonymous block) doesn't support
--parameters
--returning result.

--Stackoverflow zasugerowal ze to bedzie najprostszy sposob na zrobienie tego w postgresie
DO $$
DECLARE 
	stawka FLOAT;
BEGIN
SELECT AVG(rate) INTO stawka FROM humanresources.employeepayhistory;
raise notice 'Srednia stawka to: %',stawka;

CREATE TEMPORARY TABLE IF NOT EXISTS tmp AS
SELECT firstname,lastname,rate FROM person.person p 
	JOIN humanresources.employeepayhistory e 
		ON p.businessentityid = e.businessentityid 
	WHERE rate < stawka;
END
$$;
SELECT * FROM tmp;

--2
CREATE OR REPLACE FUNCTION datazamowienia(n int)
RETURNS TIMESTAMP AS 
$$
BEGIN
	RETURN orderdate FROM sales.salesorderheader WHERE sales.salesorderheader.salesorderid = n;
END;
$$ LANGUAGE plpgsql;

SELECT datazamowienia(43661);

--3 
CREATE OR REPLACE PROCEDURE produkt(tmp varchar(40))
LANGUAGE plpgsql
AS $$
DECLARE
	produkt record;
BEGIN
		SELECT p.productid,productnumber,SUM(quantity) AS dostepność 
		INTO produkt
			FROM production.product p JOIN production.productinventory i 
				ON p.productid = i.productid 
			WHERE name = tmp GROUP BY p.productid;
			
		RAISE NOTICE 'ID: % NUMBER: % AVAILABILITY: %', 
produkt.productid, produkt.productnumber, produkt.dostepność;
END;$$

CALL produkt('Blade');

--4
CREATE OR REPLACE FUNCTION numerkarty(n int)
RETURNS varchar(25) AS 
$$
BEGIN
	RETURN cardnumber 
		FROM sales.salesorderheader h JOIN sales.creditcard c 
			ON h.creditcardid = c.creditcardid
		WHERE salesorderid = n;
		
END;
$$ LANGUAGE plpgsql;

SELECT numerkarty(43667);

--5
CREATE OR REPLACE PROCEDURE dzielenie(num1 float,num2 float)
LANGUAGE plpgsql
AS $$
DECLARE
 res float;
BEGIN
	IF num2 = 0 THEN 
		raise notice 'Niewłaściwie zdefiniowałeś dane wejściowe';
	ELSEIF num1 < num2 THEN
		raise notice 'Niewłaściwie zdefiniowałeś dane wejściowe';
	ELSE 
		res = num1/num2;
		raise notice 'Wynik dzielenia: %',res;
	END IF;
END;$$

CALL dzielenie(7,5.2);

--6
CREATE OR REPLACE PROCEDURE stanowisko(tmp varchar(15))
LANGUAGE plpgsql
AS $$
DECLARE
 	osoba record;
BEGIN
		SELECT jobtitle,vacationhours/8 AS vacationdays,
		sickleavehours/8 AS sickleavedays
		INTO osoba
			FROM humanresources.employee 
				WHERE nationalidnumber = tmp;

	RAISE NOTICE 'JobTitle: % SickDays: % VacationDays: %', 
	osoba.jobtitle,osoba.sickleavedays,osoba.vacationdays;
END;$$
CALL stanowisko('abcd');

--7
CREATE OR REPLACE PROCEDURE waluty(
	kwota float,
	waluta1 character(3),
	waluta2 character(3),
	czas timestamp)
LANGUAGE plpgsql
AS $$
DECLARE 
	kurs numeric;
	tmp character(3);
BEGIN
	IF(waluta1 != 'USD') THEN
		tmp = waluta1;
	ELSE
		tmp = waluta2;
	END IF;
	
	IF(waluta1 != 'USD' AND waluta2 != 'USD') THEN
		raise notice 'Jedna z walut musi być dolarem!';
	ELSE
		SELECT averagerate INTO kurs
			FROM sales.currencyrate c
				WHERE c.tocurrencycode = tmp AND c.currencyratedate = czas;
			
		IF(waluta1 = 'USD') THEN
			raise notice 'kurs: %[%] %[%] --> %[%]',kurs,czas,kwota,'USD',kwota*kurs,waluta2;
		ELSE
			raise notice 'kurs: %[%] %[%] -> %[%]',1/kurs,czas,kwota,waluta1,kwota/kurs,'USD';
		END IF;
	END IF;
END;$$
			
CALL waluty(50,'USD','USD','2011-05-31 00:00:00');
CALL waluty(50,'EUR','CNY','2011-05-31 00:00:00');
CALL waluty(50,'USD','EUR','2011-05-31 00:00:00');
CALL waluty(50,'EUR','USD','2011-05-31 00:00:00');









