#!/bin/sh
# Wait for database to get available

MYSQL_LOOPS="20"
MYSQL_HOST="$ELGG_DB_HOST"
MYSQL_USER="$MYSQL_USER"
MYSQL_PASS="$MYSQL_PASS"
ELGG_DB_HOST="$ELGG_DB_HOST"
ELGG_DB_NAME="$ELGG_DB_NAME"



#wait for mysql
i=0
while ! netcat $MYSQL_HOST $MYSQL_PORT >/dev/null 2>&1 < /dev/null; do
  i=`expr $i + 1`
  if [ $i -ge $MYSQL_LOOPS ]; then
    echo "$(date) - ${MYSQL_HOST}:${MYSQL_PORT} still not reachable, giving up."
    exit 0
  fi
  echo "$(date) - waiting for ${MYSQL_HOST}:${MYSQL_PORT}... 1/$MYSQL_LOOPS."
  sleep 1
done

# Recreates the base Rlgg
if ! [ $(mysql -N -s -u $MYSQL_USER -p $MYSQL_PASS -h $MYSQL_HOST -e \
    "select count(*) from information_schema.tables where \
        table_schema='$ELGG_DB_NAME' and table_name='elgg_entities';") -eq 1 ]; then
    
    mysql -u $MYSQL_USER -p $MYSQL_PASS -h $MYSQL_HOST -e "DROP DATABASE $ELGG_DB_NAME; CREATE DATABASE $ELGG_DB_NAME;"
fi

php	/elgg-docker/elgg-install.php