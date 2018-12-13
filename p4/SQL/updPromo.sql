-- Añadimos la  columna promo en customers
ALTER TABLE customers ADD COLUMN promo integer;

--CREAMOS UN CARRITO PARA EL CLIENTE CON ID = 1
UPDATE orders
SET status = 'NULL'
WHERE orderid = 108;

--CREAMOS UN CARRITO PARA EL CLIENTE CON ID = 2
UPDATE orders
SET status = 'NULL'
WHERE orderid = 110;

--Trigger para la plicacion de la promocion
DROP FUNCTION  IF EXISTS  updPromo() CASCADE;
CREATE  FUNCTION  updPromo() RETURNS  TRIGGER AS $$

BEGIN

PERFORM pg_sleep(60);

UPDATE orderdetail
SET price = foo.prod_price * (1 - (CAST (foo.promo AS FLOAT) / 100))
FROM (SELECT orders.customerid,orderdetail.orderid,orderdetail.prod_id, products.price AS prod_price, customers.promo
	FROM customers NATURAL INNER JOIN orders NATURAL INNER JOIN orderdetail, products
	WHERE customerid = 1 AND status = 'NULL' AND orderdetail.prod_id = products.prod_id) AS foo
WHERE orderdetail.orderid = foo.orderid AND orderdetail.prod_id = foo.prod_id;


RETURN NEW;
END; $$
LANGUAGE plpgsql;

DROP  TRIGGER IF EXISTS updPromo ON customers;
CREATE  TRIGGER updPromo AFTER UPDATE OF promo ON customers
FOR  EACH ROW
EXECUTE  PROCEDURE updPromo();

-- SELECT * FROM orderdetail WHERE orderid = 108;
--
-- UPDATE customers
-- SET promo = 30
-- WHERE customerid = 1;
--
-- SELECT * FROM orderdetail WHERE orderid = 108;
