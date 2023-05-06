FROM phpdockerio/php:8.2-fpm

ENV PHP_IDE_CONFIG serverName=karma8_test_phpfpm

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        php8.2-mysql php8.2-xdebug \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

WORKDIR "/var/www/karma8_test"