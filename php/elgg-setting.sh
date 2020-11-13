#!/bin/sh
set -e

echo "Enable memcache..."
if [ -e "${ELGG_PATH}elgg-config/settings.php" ]; then
  sed -i "s/\/\/\(.*$CONFIG->memcache = true;\)/\1/g" "${ELGG_PATH}elgg-config/settings.php"
  sed -i "s/\/\/\(.*$CONFIG->memcache_servers = array (\)/\1\n  array('memcached', 11211),\n);/g" "${ELGG_PATH}elgg-config/settings.php"
fi


if [ -d "$ELGG_DATA_ROOT" ]; then
  chmod -R 777 "${ELGG_DATA_ROOT}" 
  chown -R www-data:www-data "${ELGG_DATA_ROOT}"
fi


# this script from https://github.com/keviocastro/elgg-docker