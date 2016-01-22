#!/bin/bash
set -e

DEBUG="$DEBUG"
PHP_DEFAULT_LOCALE="$PHP_DEFAULT_LOCALE"

if [ "$DEBUG" = true ] && [ ! -s /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ]; then

  if [ ! -s /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ]; then
    echo "DEBUG TRUE: install xdebug and vim editor."
    curl -L https://pecl.php.net/get/xdebug-2.3.3.tgz >> /usr/src/php/ext/xdebug.tgz \
    && tar -xf /usr/src/php/ext/xdebug.tgz -C /usr/src/php/ext/ \
    && rm /usr/src/php/ext/xdebug.tgz \
    && docker-php-ext-install xdebug-2.3.3 \
    && echo "xdebug.remote_enable=1"       >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp"   >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000"      >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini 
  fi

  if [ ! -x "$(command -v vim)" ]; then
    apt-get install -y vim-nox
    # curl -fSL http://www.vim.org/scripts/download_script.php?src_id=9793 -o debugger.tar.gz
    # tar -xzvf debugger.tar.gz 
    # mkdir -p ~/.vim/
    # cp plugin/debugger.*  ~/.vim/plugin/
    # rm -rf debugger.tar.gz plugin
  fi

fi