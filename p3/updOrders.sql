--El metodo es igual a 1 si añade al carrito y 0 en caso de que se elimine.

DROP FUNCTION  IF EXISTS  updOrders() CASCADE;
CREATE  FUNCTION  updOrders() RETURNS  TRIGGER AS $$
BEGIN
	-- Si la cantidad es 0 no tiene sentido seguir guardando ese registro
	IF  NEW.quantity = 0 THEN 
		DELETE FROM orderdetail WHERE OLD.orderid = orderid AND OLD.prod_id = prod_id;
	END IF;

	-- Actualizamos la columna totalamount
	UPDATE orders 
	SET totalamount = foo.price 
	FROM (SELECT orderid, sum(price * quantity) as price
		FROM orderdetail
		WHERE orderid=OLD.orderid	
		GROUP BY orderid) as foo;
		
	
RETURN NEW; 
END; $$ 
LANGUAGE plpgsql;
 
DROP  TRIGGER IF EXISTS  updOrders ON  orders;
CREATE  TRIGGER  updOrders AFTER UPDATE OF quantity ON orderdetail
FOR EACH ROW
EXECUTE PROCEDURE updOrders();

UPDATE orderdetail SET quantity=0 WHERE orderid=1 and  prod_id=1014;
select * from orders where orderid = 1;

