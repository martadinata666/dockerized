FROM 192.168.0.2:5050/dedyms/debian:dev as fetcher
ARG RELEASE
RUN curl -L https://github.com/Kovah/LinkAce/releases/download/${RELEASE}/linkace-${RELEASE}.zip -o linkace-${RELEASE}.zip && \
    unzip linkace-${RELEASE}.zip && \
    unzip linkace.zip -d htdocs

FROM 192.168.0.2:5050/dedyms/apache:fpm
ARG RELEASE
ENV LINKACE_VERSION=$RELEASE
USER root
RUN apt update && \
    apt install -y --no-install-recommends mariadb-client && \
    apt clean && \
    rm -rf /var/lib/apt/lists
COPY apache.conf /etc/apache2/sites-available/000-default-ssl.conf
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=fetcher $HOME/htdocs /var/www/html
COPY --chown=$CONTAINERUSER:$CONTAINERUSER laravel-cron.conf /supervisor/conf.d/laravel-cron.conf
COPY --chown=$CONTAINERUSER:$CONTAINERUSER entrypoint.sh /entrypoint.sh
USER $CONTAINERUSER
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
CMD ["supervisord","-c","/supervisor/supervisord.conf"]
