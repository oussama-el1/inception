#!/bin/bash

service mariadb start

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -hlocalhost --silent || mysqladmin ping -hlocalhost -p"$MYSQL_ROOT_PASSWORD" --silent; do
    sleep 1
done
echo "MariaDB is up and running!"

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then

    echo "Running Initial Setup..."

    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
    
    echo "Database initialized!"
else
    echo "Database already exists. Skipping setup."
fi

mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

echo "Starting MariaDB Safe Mode..."
exec mysqld_safe