FROM php:5.5-apache

ENV DEBCONF_FRONTEND non-interactive

RUN apt-get update && apt-get install -y \
        git \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        mysql-client \
        pngquant \
        unzip \
        wget \
        zlib1g-dev \
    && docker-php-ext-install \
        curl \
        exif \
        mbstring \
        mcrypt \
        mysql \
        mysqli \
        pcntl \
        pdo_mysql \
        zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN pecl install \
        memcache \
    && echo "extension=memcache.so" > /usr/local/etc/php/conf.d/pecl-memcache.ini

RUN cd /usr/local \
    && curl -sS https://getcomposer.org/installer | php \
    && chmod +x /usr/local/composer.phar \
    && ln -s /usr/local/composer.phar /usr/local/bin/composer

RUN cd /usr/local \
    && git clone http://github.com/drush-ops/drush.git --branch master \
    && cd /usr/local/drush \
    && composer install \
    && ln -s /usr/local/drush/drush /usr/bin/drush

RUN apt-get clean

RUN a2enmod deflate
RUN a2enmod expires
RUN a2enmod headers
RUN a2enmod mime
RUN a2enmod rewrite
