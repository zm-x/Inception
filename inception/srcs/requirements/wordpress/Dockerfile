FROM debian:12

RUN apt-get update && apt-get install -y \
    curl \
    mariadb-client \
    netcat-openbsd \
    php8.2-fpm \
    php8.2-mysqli \
    php8.2-curl \
    php8.2-dom \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    php8.2-redis && \
    rm -rf /var/lib/apt/lists/*

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod 755 /usr/local/bin/wp

RUN mkdir -p /run/php /var/www/html

COPY tools/init.sh /usr/local/bin/init.sh
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN chmod 755 /usr/local/bin/init.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["php-fpm8.2", "-F"]