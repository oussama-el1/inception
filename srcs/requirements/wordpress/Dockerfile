FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    wget \
    php \
    php-fpm \
    php-mysql \
    php-redis \
    mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY tools/wpscript.sh /usr/local/bin/wpscript.sh
RUN chmod +x /usr/local/bin/wpscript.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/wpscript.sh"]