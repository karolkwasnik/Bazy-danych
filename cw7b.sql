--FUNKCJA
CREATE OR REPLACE FUNCTION Fibonacci(n INT)
RETURNS VOID AS $$
DECLARE
	n1 INTEGER := 0;
	n2 INTEGER := 1;
	fib INTEGER := 0;
	i INTEGER := 1;
BEGIN
	IF n = 0 THEN
		RAISE NOTICE '%',0;
	ELSEIF n =1 THEN
		RAISE NOTICE '%', 1;
	ELSE
		LOOP 
			EXIT WHEN i = n; 
			fib := n1 + n2;
			n1 := n2;
			n2 := fib;
			i := i + 1;
		END LOOP;
		RAISE NOTICE '%',fib;
	END IF;
END;
$$  LANGUAGE plpgsql;


--PROCEDURA
CREATE OR REPLACE PROCEDURE Fib(n INT)
LANGUAGE plpgsql
AS $$
	BEGIN
	PERFORM Fibonacci(n);
END;$$

CALL Fib(0);