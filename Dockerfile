FROM php:5.6.30-apache

# Common
RUN apt-get update

RUN apt-get install -y \
		openssl \
		vim

# intl
RUN apt-get install -y libicu-dev \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl

# xml
RUN apt-get install -y \
	libxml2-dev \
	libxslt-dev \
	&& docker-php-ext-install \
		dom \
		xmlrpc \
		xsl

# database
RUN docker-php-ext-install \
	mysqli \
	pdo \
	pdo_mysql

# mcrypt
RUN apt-get install -y libmcrypt-dev \
	&& docker-php-ext-install mcrypt

# strings
RUN docker-php-ext-install \
	gettext \
	mbstring

# compression
RUN apt-get install -y \
	libbz2-dev \
	zlib1g-dev \
	&& docker-php-ext-install \
		zip \
		bz2

# ssh2
RUN apt-get install -y \
	libssh2-1-dev

# Install composer and put binary into $PATH
RUN curl -sS https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/ \
	&& ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# XDebug
RUN pecl install xdebug-2.5.5
ADD docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# PHP Settings
ADD php.ini /usr/local/etc/php/conf.d/php_custom.ini

# VirtualHost Settings
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

RUN a2enmod rewrite

RUN apt-get clean
