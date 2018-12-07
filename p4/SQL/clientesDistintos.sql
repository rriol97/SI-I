DROP INDEX IF EXISTS indiceAa;

CREATE INDEX indiceAa
ON orders (EXTRACT (YEAR FROM orderdate), EXTRACT (MONTH FROM orderdate), totalamount);

EXPLAIN
SELECT COUNT(DISTINCT customerid)
FROM orders
WHERE totalamount > 100 AND EXTRACT (YEAR FROM orderdate) = 2015 AND EXTRACT (MONTH FROM orderdate) = 04;

