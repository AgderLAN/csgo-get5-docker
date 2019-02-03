#!/bin/bash

SKIP_DB=false

DB_USERNAME="${DB_USERNAME:-get5}"
DB_DATABASE="${DB_DATABASE:-get5}"

if [ -z ${MYSQL_ROOT_PASSWORD+x} ]; then
  echo "MYSQL_ROOT_PASSWORD is not set. Skipping DB initialization."
  SKIP_DB=true
fi

if [ "$SKIP_DB" == false ] && [ -z ${MYSQL_HOST+x} ]; then
  echo "MYSQL_HOST is not set. Skipping DB initialization."
  SKIP_DB=true
fi

if [ "$SKIP_DB" == false ] && [ -z ${DB_PASSWORD+x} ]; then
  echo "DB_PASSWORD is not set. Skipping DB initialization."
  SKIP_DB=true
fi

if [ "$SKIP_DB" == false ]; then
echo "Attempting to create table and db user, if needed ..."
cat << EOF | mysql -h${MYSQL_HOST} -uroot -p${MYSQL_ROOT_PASSWORD}
CREATE USER IF NOT EXISTS '${DB_USERNAME}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${DB_DATABASE} /*\!40100 DEFAULT CHARACTER SET utf8 */;
GRANT ALL PRIVILEGES ON ${DB_DATABASE}.* TO '${DB_USERNAME}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Attempting to run db migration"
/bin/bash -c "source /app/venv/bin/activate; python /app/manager.py db upgrade"
fi

echo "Starting get5-web ..."
/usr/bin/uwsgi --http :8080 --wsgi-file /app/get5.wsgi --master --processes 4 --threads 2gr