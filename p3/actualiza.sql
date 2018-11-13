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
