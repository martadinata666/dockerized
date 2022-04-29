FROM 192.168.0.2:5050/dedyms/php-fpm:8.0 AS composer
ENV COMPOSER_MEMORY_LIMIT=3G
USER root
RUN apt update && \
    apt install -y --no-install-recommends git ca-certificates curl wget && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
USER $CONTAINERUSER
#COPY --chown=$CONTAINERUSER:$CONTAINERUSER web /var/www/html
WORKDIR /var/www/html
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
RUN npm config set fetch-retries 100 && \
    npm config set fetch-retry-mintimeout 99999999 && \
    npm config set fetch-retry-maxtimeout 99999999 && \
    npm -d install && \
    npm -d install -g gulp-cli @quasar/cli && \
    cd modules/AdminPanelWebclient/vue && \
    npm -d install && \
    cd /webmail && \
    gulp styles --themes Default,DeepForest,Funny,Sand && \
    gulp js:min && \
    cd modules/AdminPanelWebclient/vue && \
    npm -d run build-production && \
    rm -rf /webmail/system/.git /webmail/node_modules /webmail/modules/AdminPanelWebclient/vue/node_modules

FROM 192.168.0.2:5050/dedyms/apache:fpm
COPY --from=ui --chown=$CONTAINERUSER:$CONTAINERUSER /webmail /var/www/html
USER $CONTAINERUSER
RUN rm /var/www/html/index.html
VOLUME ["/var/www/html/data"]
