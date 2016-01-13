#!/bin/bash
set -e

DEBUG="$DEBUG"

if [ "$DEBUG" = true ]; then
  echo "DEBUG TRUE: install xdebug."
  curl -L https://pecl.php.net/get/xdebug-2.3.3.tgz >> /usr/src/php/ext/xdebug.tgz \
  && tar -xf /usr/src/php/ext/xdebug.tgz -C /usr/src/php/ext/ \
  && rm /usr/src/php/ext/xdebug.tgz \
  && docker-php-ext-install xdebug-2.3.3 \
  && echo "xdebug.remote_enable=1"       >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_handler=dbgp"   >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_port=9000"      >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

  apt-get install -y vim
fi