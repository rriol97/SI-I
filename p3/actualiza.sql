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

--Inicializamos los valores de ambas columnas
SELECT products.prod_id, products.movieid, products.price, products.description, inventory.stock, inventory.sales
INTO productsAUX
FROM products inner join inventory

on products.prod_id = inventory.prod_id;

-- Clave primaria de products
ALTER TABLE products ADD CONSTRAINT products_pkey PRIMARY KEY (prod_id);
-- Clave foranea de movieid
ALTER TABLE products ADD FOREIGN KEY (movieid) REFERENCES imdb_movies(movieid);

--Borramos las tablas inventory y products
DROP TABLE products;
DROP TABLE inventory;

--Ronombramos productsAUX a products
ALTER TABLE productsAUX RENAME TO products;

--Anadimos clave primaria a orderdetail
SELECT orderid, prod_id, sum(price) as price, sum(quantity) as quantity
INTO orderdetailAUX
FROM orderdetail
GROUP BY orderid, prod_id;

DROP TABLE orderdetail;

ALTER TABLE orderdetailAUX RENAME TO orderdetail;

ALTER TABLE orderdetail ADD CONSTRAINT orderdetail_pkey PRIMARY KEY (orderid,prod_id);

-- Anadimos claves foraneas a orderdetail
ALTER TABLE orderdetail ADD FOREIGN KEY (orderid) REFERENCES orders(orderid);
--(no funciona: prod_id 3215 no existe) ALTER TABLE orderdetail ADD FOREIGN KEY (prod_id) REFERENCES products(prod_id);

 


