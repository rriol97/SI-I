UPDATE orders
SET 
	netamount = orderdetail.price * orderdetail.quantity,
	totalamount = netamount*tax/100
FROM orderdetail
WHERE orders.orderid = orderdetail.orderid AND (netamount is NULL OR totalamount is NULL);