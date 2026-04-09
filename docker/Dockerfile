FROM php:8.2-apache

# 1. Install MySQL driver [cite: 1]
RUN docker-php-ext-install mysqli

# 2. Copy the entire project to the container 
# We copy from the root so the structure stays: /var/www/html/Frontend/ and /var/www/html/Backend/
COPY . /var/www/html/

# 3. Fix Permissions so Apache (www-data) can read the folders
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# 4. Tell Apache that the "Home Page" is inside the Frontend folder
RUN sed -i 's|/var/www/html|/var/www/html/Frontend|g' /etc/apache2/sites-available/000-default.conf

# 5. Add an Alias so Apache can still find the Backend folder even though the Home is set to Frontend
RUN echo 'Alias /Backend /var/www/html/Backend' >> /etc/apache2/apache2.conf
