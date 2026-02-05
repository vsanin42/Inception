FROM alpine:3.22.2

RUN apk add --no-cache \
    curl \
    ca-certificates \
    mariadb-client \
    php83 \
    php83-fpm \
    php83-phar \
    php83-mysqli \
    php83-curl \
    php83-mbstring \
    php83-xml \
    php83-zip \
    php83-openssl \
    php83-intl

RUN mkdir -p /var/www/html && \
    adduser  -S -D -u 82 \
             -s /sbin/nologin \
             -h /var/www \
             -G www-data www-data && \
    sed -i \
        -e 's/^user = .*/user = www-data/' \
        -e 's/^group = .*/group = www-data/' \
        -e 's/^listen = .*/listen = 9000/' \
        /etc/php83/php-fpm.d/www.conf && \
    cd /var/www/html && \
    curl -fL https://wordpress.org/latest.tar.gz -o wp.tar.gz && \
    tar -xvzf wp.tar.gz --strip-components=1 && \
    rm -f wp.tar.gz && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

COPY ./tools /usr/local/bin
RUN chmod 755 -R /usr/local/bin && \
    cd /usr/local/bin && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

HEALTHCHECK --interval=10s --timeout=3s --retries=3 --start-period=30s \
  CMD nc -z localhost 9000 || exit 1

ENTRYPOINT [ "/usr/local/bin/wordpress_entrypoint.sh" ]