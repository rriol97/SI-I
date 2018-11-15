DROP FUNCTION IF EXISTS setOrderAmount();

CREATE OR REPLACE FUNCTION setOrderAmount()
RETURNS void AS $$
BEGIN
	UPDATE orders
	SET    netamount = ordernetprice.wholeorderprice,
	       totalamount = netamount*(100+tax)/100
	FROM (SELECT orderid, sum(price*quantity) as wholeorderprice
	      FROM orderdetail NATURAL JOIN orders
	      GROUP BY orderid) as ordernetprice
	WHERE ordernetprice.orderid=orders.orderid AND (netamount is NULL OR totalamount is NULL);

END; $$ 
LANGUAGE plpgsql;

-- Realmente da igual invocar esta funcion en select o en from puesto que no devuelve nada, solo actualiza la base de datos.
SELECT * 
FROM setOrderAmount();
