--Actualizamos price de orderdetail

UPDATE orderdetail
SET price = foo.price
FROM (SELECT orderdetail.orderid, 
	     orderdetail.prod_id, 
	     products.price / pow(1.02, extract (year FROM now()) - extract (year FROM orders.orderdate)) AS price, 
             orderdetail.quantity
      FROM orders, orderdetail, products
      WHERE orderdetail.orderid = orders.orderid AND orderdetail.prod_id = products.prod_id) AS foo
WHERE orderdetail.orderid = foo.orderid AND orderdetail.prod_id = foo.prod_id AND orderdetail.quantity = foo.quantity;
