EXPLAIN
select count(*) 
from orders 
where status is null;

EXPLAIN 
select count(*) 
from orders 
where status ='Shipped';

DROP INDEX IF EXISTS indexD;
CREATE INDEX indexD
ON orders(status);

EXPLAIN
select count(*) 
from orders 
where status is null;

EXPLAIN 
select count(*) 
from orders 
where status ='Shipped';

ANALYZE orders;

EXPLAIN
select count(*) 
from orders 
where status is null;

EXPLAIN 
select count(*) 
from orders 
where status ='Shipped';

EXPLAIN 
select count(*) 
from orders 
where status ='Paid';

EXPLAIN
select count(*) 
from orders 
where status ='Processed';

