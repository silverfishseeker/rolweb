#!/bin/bash
set -e # Devolver error inmediatamente si un comando falla

echo "Entrypoint: Instalando gemas"
bundle install

echo "Entrypoint: Preparando base de datos"
bundle exec rails db:prepare

echo "Entrypoint: limpiando tmp"
rm -rf /app/tmp/*

echo "Entrypoint: Arrancando Rails"
exec bundle exec rails server -b 0.0.0.0 -e ${RAILS_ENV}