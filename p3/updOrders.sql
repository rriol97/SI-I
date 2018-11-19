--El metodo es igual a 1 si añade al carrito y 0 en caso de que se elimine.

DROP FUNCTION  IF EXISTS  updOrders() CASCADE;
CREATE  FUNCTION  updOrders() RETURNS  TRIGGER AS $$
BEGIN
	IF (TG_OP = 'DELETE' OR TG_OP = 'UPDATE' ) THEN
		
		IF (TG_OP = 'UPDATE' AND NEW.quantity=0) THEN 
			DELETE FROM orderdetail WHERE OLD.orderid=orderid AND OLD.prod_id=prod_id;
		END IF;

		UPDATE orders
		SET    netamount = foo.netprice,
		       totalamount = foo.netprice*(100+tax)/100
		FROM (SELECT orderid, sum(price*quantity) as netprice
		      FROM orderdetail NATURAL JOIN orders
		      WHERE orderid = OLD.orderid
		      GROUP BY orderid) as foo
		WHERE foo.orderid=orders.orderid;
	ELSE 

		UPDATE orderdetail
		SET price = products.price / pow(1.02, extract (year FROM now()) - extract (year FROM orders.orderdate))
		FROM products, orders
		WHERE orderdetail.orderid = orders.orderid AND orderdetail.prod_id = products.prod_id AND orderdetail.orderid = NEW.orderid;
	
		UPDATE orders
		SET    netamount = foo.netprice,
		       totalamount = foo.netprice*(100+tax)/100
		FROM (SELECT orderid, sum(price*quantity) as netprice
		      FROM orderdetail NATURAL JOIN orders
		      WHERE orderid = NEW.orderid
		      GROUP BY orderid) as foo
		WHERE foo.orderid=orders.orderid;
			
	END IF;
			
	
RETURN NEW; 
END; $$ 
LANGUAGE plpgsql;
 
DROP  TRIGGER IF EXISTS  updOrders ON  orders;
CREATE  TRIGGER  updOrders AFTER INSERT OR UPDATE OR DELETE ON orderdetail
FOR EACH ROW
EXECUTE PROCEDURE updOrders();

UPDATE orderdetail SET quantity=4 WHERE orderid=1 and prod_id=1014;
SELECT * FROM orders WHERE orderid = 1;
INSERT INTO orderdetail (orderid, prod_id, quantity) values (1, 2, 2);
SELECT * FROM orders WHERE orderid = 1;
DELETE FROM orderdetail WHERE orderid = 1 and prod_id = 2;
SELECT * FROM orders WHERE orderid = 1;



