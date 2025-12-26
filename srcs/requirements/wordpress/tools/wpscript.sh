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

    wp redis enable --allow-root

    echo "WordPress installed successfully!"
fi

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F