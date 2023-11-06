FROM 192.168.0.2:5050/dedyms/php-fpm:8.2 AS cache
ARG TOKEN
ARG RELEASE
WORKDIR /var/www/html/
ENV COMPOSER_MEMORY_LIMIT=3G
USER root
RUN apt update && \
    apt install -y --no-install-recommends git ca-certificates curl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
USER $CONTAINERUSER
RUN git clone --depth=1 -b ${RELEASE} https://github.com/linuxserver/Heimdall.git /var/www/html && \
    rm -rf ./.git && \
    git clone --depth=1 https://github.com/linuxserver/Heimdall-Apps.git /var/www/html/app/SupportedApps && \
    rm -rf ./app/SupportedApps/.git && \
    curl -L https://getcomposer.org/download/latest-2.x/composer.phar -o ./composer.phar && \
    mv ./composer.phar ./composer && \
    chmod +x ./composer && \
    rm -rf vendor/ && \
    ./composer update && \     
    ./composer install --prefer-dist --no-interaction && \     
    ./composer clear-cache && \
    sed -i 's/bg1.jpg/bg1.webp/g' public/css/app.css && \
    curl -sS -L https://picsum.photos/3840/2160.webp -o /var/www/html/public/img/bg1.webp && \
    rm -rf ./composer && \
    ls -al /var/www/html && \
    rm -rf public/storage && \
    php artisan db:seed && \
    php artisan storage:link


FROM 192.168.0.2:5050/dedyms/nginx:mainline-fpm8.2
ARG RELEASE
ENV HEIMDALL_RELEASE=$RELEASE
ENV PHP_MEMORY_LIMIT 2048M
ENV PHP_UPLOAD_LIMIT 3000M
USER root
RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.interned_strings_buffer=32'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=512'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=5'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini; \
    \
    echo 'apc.enable_cli=1' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini; \
    \
    { \
        echo 'memory_limit=${PHP_MEMORY_LIMIT}'; \
        echo 'upload_max_filesize=${PHP_UPLOAD_LIMIT}'; \
        echo 'post_max_size=${PHP_UPLOAD_LIMIT}'; \
    } > /usr/local/etc/php/conf.d/heimdall.ini
COPY --from=cache --chown=$CONTAINERUSER:$CONTAINERUSER /var/www/html /var/www/html
COPY --chown=$CONTAINERUSER:$CONTAINERUSER yacron.yml /supervisor/yacron.yml
COPY default.conf /etc/nginx/conf.d/default.conf
USER $CONTAINERUSER
WORKDIR /var/www/html
VOLUME ["/var/www/html/storage", "/var/www/html/database"]
