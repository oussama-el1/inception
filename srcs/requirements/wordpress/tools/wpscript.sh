#!/bin/bash

echo "Waiting for MariaDB..."
while ! mysqladmin ping -h"mariadb" --silent; do
    sleep 1
done
echo "MariaDB is up!"

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not found. Installing..."

    wp core download --allow-root

    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root

    wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    wp user create \
        $WP_USER \
        $WP_EMAIL \
        --role=author \
        --user_pass=$WP_PASSWORD \
        --allow-root

    wp plugin install redis-cache --activate --allow-root

    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --allow-root

    if ! grep -q "WP_HOME" /var/www/html/wp-config.php; then
        sed -i "/stop editing/i define('WP_HOME', 'https://' . \$_SERVER['HTTP_HOST']);" /var/www/html/wp-config.php
        sed -i "/stop editing/i define('WP_SITEURL', 'https://' . \$_SERVER['HTTP_HOST']);" /var/www/html/wp-config.php
    fi

    wp redis enable --allow-root

    echo "WordPress installed successfully!"
fi

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F