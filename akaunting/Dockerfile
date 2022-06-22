
FROM 192.168.0.2:5050/dedyms/debian:dev AS fetcher
ARG RELEASE
RUN wget https://github.com/akaunting/akaunting/releases/download/$RELEASE/Akaunting_$RELEASE-Stable.zip -O /tmp/akaunting.zip && \
    unzip /tmp/akaunting.zip -d /tmp/htdocs

FROM 192.168.0.2:5050/dedyms/nginx:mainline-fpm
ARG RELEASE
ENV AKAUNTING_VERSION=$RELEASE
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER /tmp/htdocs/ /var/www/html
COPY --chown=$CONTAINERUSER:$CONTAINERUSER nginx.conf /etc/nginx/conf.d/default.conf
VOLUME /var/www/html/storage
VOLUME /var/www/html/modules