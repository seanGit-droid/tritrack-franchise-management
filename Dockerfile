FROM php:8.3-apache
RUN docker-php-ext-install mysqli
WORKDIR /var/www/html
COPY . /var/www/html/
RUN a2enmod rewrite
ENV APACHE_DOCUMENT_ROOT=/var/www/html
EXPOSE 80
