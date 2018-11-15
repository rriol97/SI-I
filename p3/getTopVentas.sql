DROP FUNCTION IF EXISTS getTopVentas(agno integer) CASCADED;

CREATE OR REPLACE FUNCTION getTopVentas(agno integer)
RETURNS TABLE(year integer, pelicula text, ventas integer)  AS $$
BEGIN
	RETURN QUERY
		SELECT foo.anyo, aux.movietitle, foo.ventas
		FROM (
			SELECT anyo, max(aux.ventas) AS ventas 
			FROM (
				SELECT extract (year FROM orders.orderdate) AS anyo, imdb_movies.movietitle, count(orderdetail.orderid) AS ventas
				FROM imdb_movies, products, orderdetail, orders
				where cast(extract (year from orders.orderdate) as integer) >= agno and imdb_movies.movieid = products.movieid  						AND products.prod_id = orderdetail.prod_id and orders.orderid = orderdetail.orderid
				GROUP BY anyo, imdb_movies.movietitle
				ORDER BY ventas desc) as aux
			GROUP BY aux.anyo 
			ORDER BY aux.ventas desc) AS foo,				
		WHERE aux.ventas = foo.ventas AND aux.anyo = foo.anyo;

END; $$ 
LANGUAGE plpgsql;

SELECT * 
FROM getTopVentas(2012);


