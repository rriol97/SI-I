DROP FUNCTION IF EXISTS getTopVentas(agno integer);

CREATE OR REPLACE FUNCTION getTopVentas(agno integer)
RETURNS TABLE(year integer, pelicula varchar, ventas bigint)  AS $$
BEGIN
	RETURN QUERY
		SELECT foo.anyo, topventas.movietitle, foo.sales AS ventas
		FROM (	SELECT anyo, max(topventas.ventas) AS sales
			FROM topventas
			WHERE anyo >= agno
			GROUP BY topventas.anyo 
			ORDER BY sales DESC) AS foo, topventas				
		WHERE topventas.ventas = foo.sales AND topventas.anyo = foo.anyo;

END; $$ 
LANGUAGE plpgsql;

SELECT * 
FROM getTopVentas(2014);


