#!/bin/sh
# Wait for database to get available

MYSQL_LOOPS="100"
MYSQL_HOST="$ELGG_DB_HOST"


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

php	/docker-install.php