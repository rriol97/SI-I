DROP FUNCTION  IF EXISTS  updInventory() CASCADE;
CREATE  FUNCTION  updInventory() RETURNS  TRIGGER AS $$
DECLARE
	prod record;
BEGIN


FOR prod IN SELECT prod_id, stock, sales, quantity
	    FROM orders NATURAL JOIN orderdetail NATURAL JOIN products
	    WHERE orderid = OLD.orderid
LOOP
	IF prod.stock > prod.quantity THEN
		UPDATE products
		SET    stock = prod.stock-prod.quantity,
		       sales = prod.sales+prod.quantity
		WHERE products.prod_id= prod.prod_id;
	ELSIF prod.stock = prod.quantity THEN 
		-- EL stock se queda en 0, hay que anadir tambien alarma
		UPDATE products
		SET    stock = prod.stock-prod.quantity,
		       sales = prod.sales+prod.quantity
		WHERE products.prod_id= prod.prod_id;
		-- EL stock se queda en 0, hay que anadir tambien alarma
		INSERT INTO alertas VALUES  (current_timestamp, prod.prod_id, 'El stock se ha quedado en 0');
		
	ELSE
		RAISE EXCEPTION 'No hay suficiente stock para el producto %.', prod.prod_id;
	END IF;

END LOOP;

NEW.orderdate = 'now()';

RETURN NEW; 
END; $$ 
LANGUAGE plpgsql;
 
DROP  TRIGGER IF EXISTS  updInventory ON  orders;
CREATE  TRIGGER  updInventory BEFORE UPDATE OF status ON orders
FOR  EACH ROW  
WHEN (NEW.status = 'Paid')
EXECUTE  PROCEDURE  updInventory();

UPDATE orders SET status='Paid' WHERE orderid=43777;

SELECT * FROM orders WHERE orderid=43777;
