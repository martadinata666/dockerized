#!/bin/bash
set -eu

echo "Migrating database"
php /var/www/html/artisan migrate --force
echo "Clearing cache"
php /var/www/html/artisan cache:clear

exec "$@"
