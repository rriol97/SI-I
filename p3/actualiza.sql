-- Actualizaciones de la base de datos

--Eliminamos la columna numparticipation de la tabla imdb_actormovies
ALTER TABLE imdb_actormovies DROP CONSTRAINT imdb_actormovies_pkey;
ALTER TABLE imdb_actormovies DROP numparticipation;
ALTER TABLE imdb_actormovies ADD CONSTRAINT imdb_actormovies_pkey PRIMARY KEY (actorid,movieid); 

--Eliminamos la columna numpartitipation de la tabla imdb_directormovies
ALTER TABLE imdb_directormovies DROP CONSTRAINT imdb_directormovies_pkey;
ALTER TABLE imdb_directormovies DROP numpartitipation;
ALTER TABLE imdb_directormovies ADD CONSTRAINT imdb_directormovies_pkey PRIMARY KEY (directorid,movieid);

--Anadimos foreing key movieid y actorid a la tabla imdb_actormovies
ALTER TABLE imdb_actormovies ADD FOREIGN KEY (movieid) REFERENCES imdb_movies(movieid);
ALTER TABLE imdb_actormovies ADD FOREIGN KEY (actorid) REFERENCES imdb_actors(actorid);

--Anadimos foreing key prod_id a la tabla inventory
ALTER TABLE inventory ADD FOREIGN KEY (prod_id) REFERENCES products(prod_id);

--Anadimos los campos de stock y sales a products
ALTER TABLE products ADD COLUMN stock integer default 0;
ALTER TABLE products ALTER COLUMN stock SET NOT NULL;
ALTER TABLE products ADD COLUMN sales integer default 0;
ALTER TABLE products ALTER COLUMN sales SET NOT NULL;

-- Inicializamos los valores de ambas columnas
INSERT INTO products (prod_id, movieid, price, description, stock, sales)
	SELECT products.prod_id, products.movieid, products.price, products.description, inventory.stock, inventory.sales 
	FROM inventory, products 
	WHERE products.prod_id = inventory.prod_id;


UPDATE products
SET products.stock = inventory.stock
FROM products INNER JOIN inventory
ON inventory.prod_id=products.prod_id;

