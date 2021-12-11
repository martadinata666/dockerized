FROM 192.168.0.2:5050/dedyms/ffmpeg-static:latest AS ffmpeg

FROM 192.168.0.2:5050/dedyms/apache:fpm
ARG TARGETARCH
ARG NEXTCLOUD_VERSION
ARG PUSH_VERSION
ENV PHP_MEMORY_LIMIT 2048M
ENV PHP_UPLOAD_LIMIT 3000M
# BUMP
# Move to root to create things
USER root

# Fetch notify_push
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
        curl -o notify-push -L  https://github.com/nextcloud/notify_push/releases/download/$PUSH_VERSION/notify_push-x86_64-unknown-linux-musl && \
        mv notify-push /usr/local/bin/notify-push && \
        chmod +x /usr/local/bin/notify-push; \
    fi;
RUN if [ "${TARGETARCH}" = "arm64" ]; then \
        curl -o notify-push -L https://github.com/nextcloud/notify_push/releases/download/$PUSH_VERSION/notify_push-aarch64-unknown-linux-musl && \
        mv notify-push /usr/local/bin/notify-push && \
        chmod +x /usr/local/bin/notify-push; \
    fi;

RUN set -ex; \
    \
    apt update; \
    apt install -y --no-install-recommends \
        rsync \
        bzip2 \
        iproute2 \
        busybox-static \
        libldap-common \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    \
    mkdir -p /var/spool/cron/crontabs; \
    echo '*/5 * * * * php -f /var/www/html/cron.php' > /var/spool/cron/crontabs/debian

RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=512'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini; \
    \
    echo 'apc.enable_cli=1' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini; \
    \
    { \
        echo 'memory_limit=${PHP_MEMORY_LIMIT}'; \
        echo 'upload_max_filesize=${PHP_UPLOAD_LIMIT}'; \
        echo 'post_max_size=${PHP_UPLOAD_LIMIT}'; \
    } > /usr/local/etc/php/conf.d/nextcloud.ini

# Downloading NextCloud
RUN set -ex; \
    fetchDeps=" \
        dirmngr \
        gnupg \
    "; \
    \
    apt update; \
    apt install -y --no-install-recommends $fetchDeps; \
    \
    curl -fsSL -o nextcloud.tar.bz2 \
        "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2"; \
    curl -fsSL -o nextcloud.tar.bz2.asc \
        "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
# gpg key from https://nextcloud.com/nextcloud.asc
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 28806A878AE423A28372792ED75899B9A724937A; \
    gpg --batch --verify nextcloud.tar.bz2.asc nextcloud.tar.bz2; \
    tar -xjf nextcloud.tar.bz2 -C /usr/src/; \
    gpgconf --kill all; \
    rm nextcloud.tar.bz2.asc nextcloud.tar.bz2; \
    rm -rf "$GNUPGHOME" /usr/src/nextcloud/updater; \
    mkdir -p /usr/src/nextcloud/data; \
    mkdir -p /usr/src/nextcloud/custom_apps; \
    chmod +x /usr/src/nextcloud/occ; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $fetchDeps; \
    rm -rf /var/lib/apt/lists/*

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY 000-default-ssl.conf /etc/apache2/sites-available/000-default-ssl.conf
COPY --chown=$CONTAINERUSER:$CONTAINERUSER event.py /usr/local/bin/event.py
COPY --from=ffmpeg $HOME/.local/bin/ /usr/local/bin/
COPY --chown=$CONTAINERUSER:$CONTAINERUSER supervisord.conf /home/debian/supervisor/supervisord.conf
COPY *.sh upgrade.exclude /
# Add modified entrypoint because fpm already using user 1000
#COPY entrypoint.sh /entrypoint.sh
COPY config/* /usr/src/nextcloud/config/
# No cmd, already inside base image and switch back
USER $CONTAINERUSER
ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord","-c","/home/debian/supervisor/supervisord.conf"]
