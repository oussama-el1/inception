FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php \
    php-mysqli \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O index.php

RUN chown -R www-data:www-data /var/www/html/index.php && \
    chmod 755 /var/www/html/index.php

USER www-data
EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080"]