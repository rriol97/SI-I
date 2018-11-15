DROP FUNCTION  IF EXISTS  updInventory() CASCADE;
CREATE  FUNCTION  updInventory() RETURNS  TRIGGER AS $$
DECLARE
	prod record;
BEGIN


FOR prod IN SELECT prod_id, stock, sales, quantity
	    FROM orders NATURAL JOIN orderdetail NATURAL JOIN products
	    WHERE orderid = OLD.orderid
LOOP

	UPDATE products
	SET    stock = prod.stock-prod.quantity,
	       sales = prod.sales+prod.quantity
	WHERE products.prod_id= prod.prod_id;

	IF prod.stock = prod.quantity THEN 
		-- El stock se queda en 0, hay que anadir tambien alarma
		
		-- EL stock se queda en 0, hay que anadir tambien alarma
		INSERT INTO alertas VALUES  (current_timestamp, prod.prod_id, 'El stock se ha quedado en 0');
		
	ELSE
		-- En este caso el stock seria inferior a 0.
		-- Hemos concluido que es razonable admitir esto para evitar problemas con comprar concurrentes o muy seguidas.
		-- El funcionamiento es igual que en el caso anterior pero cambianod ligeramente el mensaje.

		INSERT INTO alertas VALUES  (current_timestamp, prod.prod_id, 'El stock esta por debajo de 0, recordamos comprar inventario.');
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
