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
SELECT products.prod_id, products.movieid, products.price, products.description, CASE WHEN inventory.prod_id is NULL THEN 0 ELSE inventory.stock END AS stock , CASE WHEN inventory.prod_id is NULL THEN 0 ELSE inventory.sales END AS sales
INTO productsAUX
FROM products LEFT JOIN inventory ON products.prod_id = inventory.prod_id;

--Borramos las tablas inventory y products
DROP TABLE products;
DROP TABLE inventory;

--Ronombramos productsAUX a products
ALTER TABLE productsAUX RENAME TO products;

-- Clave primaria de products
ALTER TABLE products ADD CONSTRAINT products_pkey PRIMARY KEY (prod_id);
-- Clave foranea de movieid
ALTER TABLE products ADD FOREIGN KEY (movieid) REFERENCES imdb_movies(movieid);

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
ALTER TABLE orderdetail ADD FOREIGN KEY (prod_id) REFERENCES products(prod_id);


-- Apartado b: Cohesion de lenguajes, generos y paises.

--Languages
SELECT ROW_NUMBER() OVER (ORDER BY language) AS lan_id, language
INTO languages
FROM (SELECT DISTINCT language
      FROM IMDB_movielanguages) AS languages;

ALTER TABLE languages ADD CONSTRAINT languages_pkey PRIMARY KEY (lan_id);

SELECT movieid, lan_id
INTO imdb_movielanguagesAux
FROM imdb_movielanguages NATURAL JOIN languages
GROUP BY movieid, lan_id;

DROP TABLE imdb_movielanguages;
ALTER TABLE imdb_movielanguagesAux RENAME TO imdb_movielanguages;
ALTER TABLE imdb_movielanguages ADD CONSTRAINT imdb_movielanguages_pkey PRIMARY KEY (movieid, lan_id);

-- Anadimos claves foraneas 
ALTER TABLE imdb_movielanguages ADD FOREIGN KEY (movieid) REFERENCES IMDB_movies(movieid);
ALTER TABLE imdb_movielanguages ADD FOREIGN KEY (lan_id) REFERENCES languages(lan_id);


--Generos
SELECT ROW_NUMBER() OVER (ORDER BY genre) AS genre_id, genre
INTO genres
FROM (SELECT DISTINCT genre
      FROM IMDB_moviegenres) AS genres;

ALTER TABLE genres ADD CONSTRAINT genres_pkey PRIMARY KEY (genre_id);

SELECT movieid, genre_id
INTO imdb_moviegenresAux
FROM imdb_moviegenres NATURAL JOIN genres
GROUP BY movieid, genre_id;

DROP TABLE imdb_moviegenres;
ALTER TABLE imdb_moviegenresAux RENAME TO imdb_moviegenres;
ALTER TABLE imdb_moviegenres ADD CONSTRAINT imdb_moviegenres_pkey PRIMARY KEY (movieid, genre_id);

-- Anadimos claves foraneas 
ALTER TABLE imdb_moviegenres ADD FOREIGN KEY (movieid) REFERENCES IMDB_movies(movieid);
ALTER TABLE imdb_moviegenres ADD FOREIGN KEY (genre_id) REFERENCES genres(genre_id);


--Paises
SELECT ROW_NUMBER() OVER (ORDER BY country) AS country_id, country
INTO countries
FROM (SELECT DISTINCT country
      FROM IMDB_moviecountries) AS countries;

ALTER TABLE countries ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);

SELECT movieid, country_id
INTO imdb_moviecountriesAux
FROM imdb_moviecountries NATURAL JOIN countries
GROUP BY movieid, country_id;

DROP TABLE imdb_moviecountries;
ALTER TABLE imdb_moviecountriesAux RENAME TO imdb_moviecountries;
ALTER TABLE imdb_moviecountries ADD CONSTRAINT imdb_moviecountries_pkey PRIMARY KEY (movieid, country_id);

-- Anadimos claves foraneas 
ALTER TABLE imdb_moviecountries ADD FOREIGN KEY (movieid) REFERENCES IMDB_movies(movieid);
ALTER TABLE imdb_moviecountries ADD FOREIGN KEY (country_id) REFERENCES countries(country_id);


-- Anadimos la tabla "alertas", necesaria para updInventory()
CREATE TABLE IF NOT EXISTS alertas (time timestamp, prodid int, msg text);

--Creamos view para apartado e
CREATE VIEW TopVentas AS 
	SELECT extract(year FROM orders.orderdate) AS anyo, imdb_movies.movietitle, count(orderdetail.orderid) AS ventas
	FROM imdb_movies, products, orderdetail, orders
	WHERE imdb_movies.movieid = products.movieid AND products.prod_id = orderdetail.prod_id and orders.orderid = orderdetail.orderid
	GROUP BY anyo, imdb_movies.movietitle
	ORDER BY ventas DESC;




 


