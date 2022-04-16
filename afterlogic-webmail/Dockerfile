FROM 192.168.0.2:5050/dedyms/php-fpm:7.4 AS composer
WORKDIR /var/www/html
ENV COMPOSER_MEMORY_LIMIT=3G
USER root
RUN apt update && \
    apt install -y --no-install-recommends git ca-certificates curl wget && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
USER $CONTAINERUSER
RUN pwd && \
    git clone --depth=1 https://github.com/afterlogic/webmail-lite-8.git /var/www/html && \
    rm -rf ./.git && \
    curl -L https://getcomposer.org/download/latest-2.x/composer.phar -o ./composer.phar && \
    ls -al && \
    mv ./composer.phar ./composer && \
    chmod +x ./composer && \
    rm -rf vendor/ && \
    ./composer install && \
    rm ./composer && \
    ls -al
#RUN ls -al /var/www/html

FROM 192.168.0.2:5050/dedyms/node:lts-dev as ui
COPY --from=composer --chown=root:root /var/www/html /webmail
WORKDIR /webmail
RUN npm -d install && \
    npm -d install -g gulp-cli @quasar/cli && \
    cd modules/AdminPanelWebclient/vue && \
    npm -d install && \
    cd /webmail && \
    gulp styles --themes Default,DeepForest,Funny,Sand && \
    gulp js:min && \
    cd modules/AdminPanelWebclient/vue && \
    npm -d run build-production && \
    rm -rf /webmail/system/.git /webmail/node_modules /webmail/modules/AdminPanelWebclient/vue/node_modules

FROM 192.168.0.2:5050/dedyms/nginx:mainline-fpm7
COPY --from=ui --chown=$CONTAINERUSER:$CONTAINERUSER /webmail /var/www/html
USER $CONTAINERUSER
VOLUME ["/var/www/html/data"]
