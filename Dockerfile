FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Configure PHP-FPM logging
RUN echo "access.log = /proc/self/fd/2" >> /usr/local/etc/php-fpm.d/docker.conf && \
    echo "access.format = \"%R - %u %t \"%m %r\" %s %f %{mili}d %{kilo}M %C%%\"" >> /usr/local/etc/php-fpm.d/docker.conf

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy package files
COPY package.json package-lock.json ./

# Install npm dependencies
RUN npm install --no-audit --no-fund

# Copy the rest of the application
COPY . .

# Install composer dependencies
RUN composer install --no-dev --no-scripts --no-autoloader

# Generate autoload files
RUN composer dump-autoload --optimize

# Build assets
RUN npm install && \
    npm run prod && \
    npm cache clean --force

# Copy compiled assets to public directory
RUN mkdir -p /var/www/public && \
    cp -r public/* /var/www/public/

# Generate key
RUN php artisan key:generate

# Set permissions
RUN chown -R www-data:www-data /var/www/storage /var/www/public && \
    chmod -R 775 /var/www/storage /var/www/public

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=9000"] 