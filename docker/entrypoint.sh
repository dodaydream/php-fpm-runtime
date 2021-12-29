#!/bin/bash

# set permission for folder
chown -R www-data:www-data /var/www/html
chown -R www-data:www-data storage bootstrap/cache

# install composer dependencies
composer install --optimize-autoloader --no-dev

# optimize laravel
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Update nginx to match worker_processes to no. of cpu's
procs=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i -e "s/worker_processes  1/worker_processes $procs/" /etc/nginx/nginx.conf

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
