FROM 192.168.0.2:5050/dedyms/php-fpm:alpine AS cache
ARG TOKEN
WORKDIR /var/www/html/
ENV COMPOSER_MEMORY_LIMIT=3G
USER root
RUN apk add --no-cache git wget

# ./composer config -a github-oauth.github.com $TOKEN && \
USER $CONTAINERUSER
RUN git clone --depth 1 https://github.com/martadinata666/Heimdall.git /var/www/html && \
    wget https://getcomposer.org/download/1.10.20/composer.phar && mv ./composer.phar ./composer && chmod +x ./composer && \
    rm -rf .git/ && \
    ./composer config -a github-oauth.github.com $TOKEN && \
    ./composer update && \
    ./composer install --prefer-dist --no-dev --no-interaction && \
    ./composer clear-cache && \
    rm auth.json && unlink public/storage && \
    php artisan storage:link && \
    rm ./composer

FROM 192.168.0.2:5050/dedyms/nginx:mainline-fpm7
COPY --from=cache --chown=$CONTAINERUSER:$CONTAINERUSER /var/www/html/ /var/www/html/
COPY default.conf /etc/nginx/conf.d/default.conf
USER $CONTAINERUSER
WORKDIR /var/www/html
VOLUME ["/var/www/html/storage", "/var/www/html/database"]
