# Stage 1: Build/Development (Optional: can be used for installing composer etc)
FROM php:8.2-apache AS base

# 1. Install MySQL extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# 2. Enable Apache mod_rewrite (Standard for web apps)
RUN a2enmod rewrite

# 3. Copy application source code
# We copy from the local 'app' folder directly to the container's web root
COPY ./app /var/www/html/

# 4. Set secure permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Stage 2: Production-Ready minimal image
FROM base AS final
WORKDIR /var/www/html

# Expose standard web port
EXPOSE 80

CMD ["apache2-foreground"]