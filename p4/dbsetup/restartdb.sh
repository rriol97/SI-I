# Es necesario que el fichero dump....gz este en el mismo directorio que el script

#!/bin/bash

dropdb -U alumnodb -h localhost si1
createdb -U alumnodb -h localhost si1

gunzip -c dump_v1.0-P4.sql.gz | psql -U alumnodb -h localhost si1

set PGPASSWORD = alumnodb


