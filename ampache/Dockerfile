FROM 192.168.0.2:5050/dedyms/debian:dev AS fetcher
ARG RELEASE
#WORKDIR /ampache
RUN curl -o ampache.zip -L https://github.com/ampache/ampache/releases/download/${RELEASE}/ampache-${RELEASE}\_all\_php8.2.zip && \
    unzip ./ampache.zip -d ampache && \
    rm ./ampache.zip

FROM 192.168.0.2:5050/dedyms/apache:fpm
ARG RELEASE
ENV AMPACHE_RELEASE=$RELEASE
ENV PHP_MEMORY_LIMIT 1024M
ENV PHP_UPLOAD_LIMIT 512M
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/ampache/ /var/www/html
COPY ampache.conf /etc/apache2/sites-available/000-default.conf
COPY ampache-ssl.conf /etc/apache2/sites-available/000-default-ssl.conf
USER $CONTAINERUSER
VOLUME /var/www/html/config
