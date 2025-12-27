FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf /etc/nginx/sites-enabled/default
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

COPY tools/index.html /var/www/html/index.html

EXPOSE 8000

CMD ["nginx", "-g", "daemon off;"]