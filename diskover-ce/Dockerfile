### Fetch composer deps
FROM 192.168.0.2:5050/dedyms/php-fpm:7.4 as vendor
ARG RELEASE
USER root
RUN apt update && \
    apt install -y --no-install-recommends git ca-certificates curl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
RUN git clone --depth=1 -b $RELEASE https://github.com/diskoverdata/diskover-community.git /diskover-community
WORKDIR /tmp
RUN cp /diskover-community/diskover-web/composer.json ./composer.json
RUN cp /diskover-community/diskover-web/composer.lock ./composer.lock
RUN mkdir /diskover-community/diskover-web/database
RUN curl -L https://getcomposer.org/download/latest-2.x/composer.phar -o ./composer.phar && \
    mv ./composer.phar ./composer && \
    chmod +x ./composer && \
    ./composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist && \
    rm ./composer

### Build diskover
FROM 192.168.0.2:5050/dedyms/debian:dev AS builder
ARG RELEASE
USER root
RUN apt update && \
    apt install -y --no-install-recommends python3-pip python3-dev gcc git && \
    apt clean &&\
    rm -rf /var/lib/apt/lists/*
RUN git clone --depth=1 -b $RELEASE https://github.com/diskoverdata/diskover-community.git /diskover
WORKDIR /diskover/diskover
RUN ls -al && \
    mkdir -p /root/.config/diskover && \
    mkdir -p /etc/diskover && \
    cp /diskover/diskover/configs_sample/diskover/config.yaml /etc/diskover/config.yaml && \
    pip3 install --no-cache-dir -r requirements.txt


#FROM registry.gitlab.com/dedyms/php-fpm:alpine
FROM 192.168.0.2:5050/dedyms/nginx:mainline-fpm7
ENV HOME=/home/$CONTAINERUSER
# Install php ldap extension
#RUN apt-get update && \
#        apt-get install -y libldap2-dev
#USER root
#RUN apk add --no-cache openldap-dev
#RUN docker-php-ext-configure ldap
#RUN docker-php-ext-install ldap
# Copy existing application directory contents
COPY --from=builder /usr/local /usr/local
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=builder /etc/diskover/config.yaml /etc/diskover/config.yaml
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=builder /diskover/diskover /diskover
COPY --chown=$CONTAINERUSER:$CONTAINERUSER crawl.sh /diskover/crawl.sh
COPY --chown=$CONTAINERUSER:$CONTAINERUSER nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=vendor --chown=$CONTAINERUSER:$CONTAINERUSER /diskover-community/diskover-web /var/www/html
COPY --from=vendor --chown=$CONTAINERUSER:$CONTAINERUSER /tmp/vendor /var/www/html/vendor
COPY --chown=$CONTAINERUSER:$CONTAINERUSER Constants.php /var/www/html/src/diskover/Constants.php
COPY --chown=$CONTAINERUSER:$CONTAINERUSER yacron.yml /supervisor/yacron.yml
WORKDIR /diskover
VOLUME ["/var/www/html/database"]
USER $CONTAINERUSER
