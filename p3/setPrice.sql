--Actualizamos price de orderdetail

update orderdetail
set price = foo.price
from (select orderdetail.orderid, orderdetail.prod_id, products.price / pow(1.02, extract (year from now()) - extract (year from orders.orderdate)) as price, orderdetail.quantity
from orders, orderdetail, products
where orderdetail.orderid = orders.orderid and orderdetail.prod_id = products.prod_id) as foo
where orderdetail.orderid = foo.orderid and orderdetail.prod_id = foo.prod_id and orderdetail.quantity = foo.quantity;
