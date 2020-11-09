#!/bin/sh
set -e

WAIT_MYSQL_START="30" # In seconds

#wait for mysql
i=0
while ! netcat $ELGG_DB_HOST $ELGG_DB_PORT >/dev/null 2>&1 < /dev/null; do
  i=`expr $i + 1`
  if [ $i -ge $MYSQL_LOOPS ]; then
    echo "$(date) - ${ELGG_DB_HOST}:${ELGG_DB_PORT} still not reachable, giving up."
    exit 1
  fi
  echo "$(date) - waiting for ${ELGG_DB_HOST}:${ELGG_DB_PORT}... $i/$WAIT_MYSQL_START."
  sleep 1
done
echo "The MySQL server is ready."

echo "Starting installation elgg."
#This directory will hold Elgg's ``settings.php`` file after installation.
if [ ! -d "${ELGG_PATH}elgg-config/" ]; then
	find -type f -name "*.zip" -exec unzip -q {} \;
	mv elgg-*/ elgg/
	cp -a elgg/. ${ELGG_PATH}
	rm -rf elgg
	chown -R www-data:www-data "${ELGG_PATH}elgg-config/"
fi


if [ ! -d "$ELGG_DATA_ROOT" ]; then
  mkdir $ELGG_DATA_ROOT
fi 
chmod -R 777 "${ELGG_DATA_ROOT}" 
chown -R www-data:www-data "${ELGG_DATA_ROOT}"

# this script from https://github.com/keviocastro/elgg-docker