#!/bin/bash

# Definir el directorio base
BASE_DIR="./db_data"

# Crear la lista de directorios
DIRS=(
  "pg_commit_ts"
  "pg_logical/pg_logical"
  "pg_logical/snapshots"
  "pg_logical/mappings"
  "pg_notify"
  "pg_replslot"
  "pg_snapshots"
  "pg_tblspc"
  "pg_twophase"
)

# Crear cada directorio
for dir in "${DIRS[@]}"; do
  mkdir -p "${BASE_DIR}/${dir}"
done

echo "Directorios creados en ${BASE_DIR}"
