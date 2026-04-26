#!/bin/bash
set -e # Devolver error inmediatamente si un comando falla

echo "EP: Preparando base de datos"
bundle exec rails db:prepare

echo "EP: impiando tmp"
bundle exec rails tmp:clear

echo "EP: Arrancando Rails"
exec bundle exec rails server -b 0.0.0.0 -e ${RAILS_ENV}

echo "EP: Terminando entrypoint"