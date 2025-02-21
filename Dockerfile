# Start from the official PHP-FPM Alpine image
FROM php:8.3-fpm-alpine

# Install necessary packages
RUN apk update && apk add --no-cache nginx supervisor nano

# Install extensions
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions pdo_pgsql curl openssl mbstring zip gd xml sourceguardian

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create necessary directories for Supervisord
RUN mkdir -p /var/log/supervisor
# Create necessary directories for Nginx
RUN mkdir -p /etc/nginx /run/nginx /var/lib/nginx/tmp /var/log/nginx \
    && chown -R www-data:www-data /var/lib/nginx /var/log/nginx \
    && chmod -R 755 /var/lib/nginx /var/log/nginx

# Copy configuration files
COPY ./k8s/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./k8s/php/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY ./k8s/supervisord/supervisord.conf /etc/supervisord.conf

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN echo 'memory_limit = 2048M' >> "$PHP_INI_DIR/conf.d/99-docker-php-memlimit.ini";

ADD ./k8s/cron/crontab /crontab
RUN /usr/bin/crontab /crontab

# Copy existing application directory permissions
RUN rm -rf /var/www/
COPY . /var/www/
RUN chown -R www-data:www-data /var/www/

WORKDIR /var/www
USER www-data
RUN composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader
RUN rm -f /var/www/auth.json

USER root

# Expose ports
EXPOSE 80

# Start systemd
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]