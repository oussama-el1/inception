#!/bin/bash

echo "Waiting for MariaDB to be ready..."
while ! mariadb -h mariadb -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1;" > /dev/null 2>&1; do
    echo "MariaDB is not ready yet... Retrying in 3 seconds"
    sleep 3
done
echo "MariaDB is connected!"

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
exec /usr/sbin/php-fpm8.2 -F