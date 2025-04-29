#!/usr/bin/env bash
# exit on error
set -o errexit

# Install PHP dependencies
composer install --no-dev

# Install NPM dependencies
npm install

# Build assets
npm run build

# Generate key
php artisan key:generate

# Run migrations
php artisan migrate --force 