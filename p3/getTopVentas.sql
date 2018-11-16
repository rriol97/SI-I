DROP FUNCTION IF EXISTS getTopVentas(agno integer);

CREATE OR REPLACE FUNCTION getTopVentas(agno integer)
RETURNS TABLE(year integer, pelicula varchar, ventas bigint)  AS $$
BEGIN
	RETURN QUERY
		SELECT foo.anyo::int, imdb_movies.movietitle, foo.sales AS ventas
		FROM (	SELECT anyo, max(topventas.ventas) AS sales
			FROM topventas
			WHERE anyo >= agno
			GROUP BY topventas.anyo) AS foo, topventas, imdb_movies			
		WHERE topventas.anyo = foo.anyo AND imdb_movies.movieid = topventas.movieid AND topventas.ventas = foo.sales;

END; $$ 
LANGUAGE plpgsql;

SELECT * 
FROM getTopVentas(2014);

