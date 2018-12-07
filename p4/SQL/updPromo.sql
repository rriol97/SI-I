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

DECLARE
	prod record;
BEGIN

FOR prod IN SELECT *
	    FROM (SELECT orderid, promo FROM orders NATURAL INNER JOIN customers WHERE customerid = NEW.customerid and status = 'NULL') AS foo NATURAL INNER JOIN orderdetail

LOOP
	UPDATE orderdetail
	SET price = products.price * (CAST (prod.promo AS FLOAT) / 100)
	FROM products
	WHERE products.prod_id = prod.prod_id and prod.orderid = orderdetail.orderid;

END LOOP;
RETURN NEW; 
END; $$ 
LANGUAGE plpgsql;
 
DROP  TRIGGER IF EXISTS updPromo ON customers;
CREATE  TRIGGER updPromo AFTER UPDATE OF promo ON customers
FOR  EACH ROW  
EXECUTE  PROCEDURE updPromo();


UPDATE customers
SET promo = 50
WHERE customerid = 2;