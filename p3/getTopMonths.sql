DROP FUNCTION IF EXISTS gettopmonths(integer,integer);

CREATE OR REPLACE FUNCTION getTopMonths(prodbound int4,totamountbound int4)
RETURNS TABLE(year integer, month integer, amount numeric, numProducts numeric) AS $$
BEGIN
	RETURN QUERY 
		SELECT cast(date_part('year',orderdate) as integer) as year, 
		       cast(date_part('month',orderdate) as integer) as month,
		       sum(totalamount) as amount,
		       sum(quantity) as numProducts
		FROM orders NATURAL JOIN orderdetail
		GROUP BY year, month
		HAVING sum(totalamount) > totamountbound  OR sum(quantity) > prodBound;
END; $$ 
LANGUAGE plpgsql;

SELECT * 
FROM getTopMonths(19000,320000);