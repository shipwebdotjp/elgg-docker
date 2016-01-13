#!/bin/sh
set -e

WAIT_MYSQL_START="30" # In seconds
MYSQL_PORT="$MYSQL_PORT"
MYSQL_USER="$MYSQL_USER"
MYSQL_PASS="$MYSQL_PASS"
ELGG_DB_HOST="$ELGG_DB_HOST"
ELGG_DB_NAME="$ELGG_DB_NAME"

#wait for mysql
i=0
while ! netcat $ELGG_DB_HOST $MYSQL_PORT >/dev/null 2>&1 < /dev/null; do
  i=`expr $i + 1`
  if [ $i -ge $MYSQL_LOOPS ]; then
    echo "$(date) - ${ELGG_DB_HOST}:${MYSQL_PORT} still not reachable, giving up."
    exit 1
  fi
  echo "$(date) - waiting for ${ELGG_DB_HOST}:${MYSQL_PORT}... $i/$WAIT_MYSQL_START."
  sleep 1
done

echo "The MySQL server is ready."
echo "Starting installation elgg."

# Remove existing configuration files 
rm -rf engine/settings.php
rm -rf .htaccess

# Drop existing tables
mysql -u$MYSQL_USER -p$MYSQL_PASS -h$ELGG_DB_HOST --silent --skip-column-names -e "SHOW TABLES" $ELGG_DB_NAME | xargs -L1 -I% echo 'DROP TABLE `%`;' | mysql -u$MYSQL_USER -p$MYSQL_PASS -h$ELGG_DB_HOST -v $ELGG_DB_NAME
php /elgg-docker/elgg-install.php

if [ -f "${ELGG_PATH}${MYSQL_DATABASE_INITIAL_DATA}"  ]; then
  echo "MYSQL_DATABASE_INITIAL_DATA: restore dump ${ELGG_PATH}${MYSQL_DATABASE_INITIAL_DATA} at dbname ${ELGG_DB_NAME}."
  mysql -u$MYSQL_USER -p$MYSQL_PASS -h$ELGG_DB_HOST $ELGG_DB_NAME < $ELGG_PATH$MYSQL_DATABASE_INITIAL_DATA
fi

/elgg-docker/environment-setup.sh