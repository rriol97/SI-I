-- Actualizamos el precio de la columna orderdetail
UPDATE orderdetail
SET price = products.price / pow(1.02, extract (year FROM now()) - extract (year FROM orders.orderdate))
FROM products, orders
WHERE orderdetail.orderid = orders.orderid AND orderdetail.prod_id = products.prod_id; 
