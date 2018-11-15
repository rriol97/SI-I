DROP FUNCTION IF EXISTS gettopmonths(integer,integer);

CREATE OR REPLACE FUNCTION getTopMonths(prodbound int4,totamountbound int4)
RETURNS TABLE(year integer, month integer, amount numeric, numProducts numeric) AS $$
BEGIN
	 RETURN QUERY 
		SELECT cast(date_part('year',orderdate) AS integer) AS year, 
		       cast(date_part('month',orderdate) AS integer) AS month,
		       sum(price*quantity) AS amount,
		       sum(quantity) AS numProducts
		FROM orders NATURAL JOIN orderdetail
		GROUP BY year, month
		HAVING sum(price*quantity) > totamountbound OR sum(quantity) > prodBound;
END; $$ 
LANGUAGE plpgsql;

SELECT * 
FROM getTopMonths(19000,320000);
