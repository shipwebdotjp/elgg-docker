FROM php:5.6-apache
COPY docker_config/php.ini /usr/local/etc/php/
COPY . /var/www/html/ 

#RUN apt-get update && apt-get install -y apt-utils pwgen 

# Elgg requirements
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    	&& docker-php-ext-install gd \
    	&& docker-php-ext-install pdo \
    	&& docker-php-ext-install mysql \
    	&& docker-php-ext-install mbstring


# Email server
# RUN apt-get -y install ssmtp

#Configs apache
RUN a2enmod rewrite

#Set time zone in server
ENV TIMEZONE="America/Sao_Paulo"
RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime


# set defaults or env vars for Elgg and MySQL
# MySQL
ENV MYSQL_USER=${MYSQL_USER:-"admin"}
ENV MYSQL_PASS=${MYSQL_PASS:-"123123"}

# required for installation
ENV ELGG_DB_HOST=${ELGG_DB_HOST:-"127.0.0.1"}
ENV ELGG_DB_USER=$MYSQL_USER
ENV ELGG_DB_PASS=$MYSQL_PASS
ENV ELGG_DB_NAME=${ELGG_DB_NAME:-"elgg"}

ENV ELGG_SITE_NAME=${ELGG_SITE_NAME:-"Elgg Site"}
# Elgg requires a FQDN for the email address.
ENV ELGG_SITE_EMAIL=${ELGG_SITE_EMAIL:-"no-reply@${HOSTNAME}"}
ENV ELGG_WWW_ROOT=${ELGG_WWW_ROOT:-"http://localhost:${PORT}"}
ENV ELGG_DATA_ROOT=${ELGG_DATA_ROOT:-"/media/elgg/"}

# admin user setup
ENV ELGG_DISPLAY_NAME=${ELGG_DISPLAY_NAME:-"admin"}
ENV ELGG_EMAIL=${ELGG_EMAIL:-"elgg-admin@${HOSTNAME}"}
ENV ELGG_USERNAME=${ELGG_USERNAME:-"admin"}
ENV ELGG_PASSWORD=${ELGG_PASSWORD:-"123123"}

# optional for installation
ENV ELGG_DB_PREFIX=${ELGG_DB_PREFIX:-"elgg_"}
ENV ELGG_PATH=${ELGG_PATH:-"/var/www/html/"}
# 2 is ACCESS_PUBLIC
ENV ELGG_SITE_ACCESS=2

COPY docker-install.php /docker-install.php
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
RUN /docker-entrypoint.sh

# ENTRYPOINT ['php', 'docker-entrypoint.sh'] 