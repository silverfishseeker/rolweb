# Utiliza la imagen base de Ruby
FROM postgres:15-alpine

# Establece el directorio de trabajo en el contenedor
WORKDIR /var/lib/postgresql/data

# Crear estructura de directorios por si git las elimina por ser carpetas vacías
# Es necesario que existan o no funciona
# RUN mkdir -p pg_commit_ts pg_logical/mappings pg_logical/snapshots \
#  pg_multixact/members pg_multixact/offsets pg_notify pg_replslot \
#  pg_subtrans pg_tblspc pg_twophase pg_wal/archive_status pg_xact pg_snapshots
 #&& postgres

