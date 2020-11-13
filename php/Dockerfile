FROM php:7.3.8-apache

#ELGG Version here
ARG version="3.3.12"

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        netcat \
        default-mysql-client \
        wget \
        unzip \
        msmtp \
        msmtp-mta \
        supervisor \
        libmemcached-dev \
        zlib1g-dev \
   && pecl install memcached-3.1.5 \
   && docker-php-ext-enable memcached \
   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
   && docker-php-ext-install gd pdo pdo_mysql mbstring opcache \
   && apt install -y busybox-static

COPY ./php.ini /usr/local/etc/php/
COPY ./elgg-install.sh /elgg/elgg-install.sh
COPY ./elgg-setting.sh /elgg/elgg-setting.sh
COPY ./elgg/src/elgg-${version}.zip /elgg/src/elgg-${version}.zip
#RUN wget -q -nc -P /elgg/src/ https://elgg.org/download/elgg-${version}.zip

WORKDIR /elgg/src

RUN chmod +x /elgg/elgg-install.sh \
 && chmod +x /elgg/elgg-setting.sh

#RUN unzip -q /elgg/src/elgg-${version}.zip \
# && cp -rf elgg-${version}/* /var/www/html \
# && rm -rf elgg-${version} \
# && mkdir /elgg/data \
# && chown www-data:www-data /var/www/html/elgg-config/ \
# && chown www-data:www-data /elgg/data/

#Configs apache
RUN a2enmod rewrite \
 && a2enmod cache \
 && a2enmod cache_disk

#Set time zone in server
ENV TIMEZONE="GMT+0"
RUN cp -f /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

#Set time zone in PHP
RUN sed -i "s#{{timezone}}#$TIMEZONE#g" /usr/local/etc/php/php.ini

COPY ./msmtprc /etc/msmtprc
RUN chown www-data:www-data /etc/msmtprc && chmod 600 /etc/msmtprc

RUN mkdir -p /var/spool/cron/crontabs/
COPY ./root /var/spool/cron/crontabs/root

RUN mkdir -p /var/log/supervisor
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
