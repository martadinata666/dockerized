FROM 192.168.0.2:5050/dedyms/ffmpeg-static:latest AS ffmpeg

FROM 192.168.0.2:5050/dedyms/debian:latest as notify
# Fetch notify_push
ARG TARGETPLATFORM
ARG PUSH_VERSION
RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  NOTIFY_PUSH_ARCH=x86_64  ;; \
         "linux/arm64")  NOTIFY_PUSH_ARCH=aarch64  ;; \
    esac \
    && curl -o notify-push -L  https://github.com/nextcloud/notify_push/releases/download/$PUSH_VERSION/notify_push-${NOTIFY_PUSH_ARCH}-unknown-linux-musl && \ 
    mv notify-push /usr/local/bin/notify-push && \
    chmod +x /usr/local/bin/notify-push

FROM 192.168.0.2:5050/dedyms/apache:fpm8.1
ARG TARGETPLATFORM
ARG NEXTCLOUD_VERSION
ARG PUSH_VERSION
ENV PHP_MEMORY_LIMIT 8192M
ENV PHP_UPLOAD_LIMIT 8192M
ENV NEXTCLOUD_UPDATE=1
# Move to root to create things
USER root

#RUN if [ "${TARGETARCH}" = "amd64" ]; then \
#        curl -o notify-push -L  https://github.com/nextcloud/notify_push/releases/download/$PUSH_VERSION/notify_push-x86_64-unknown-linux-musl && \
#        mv notify-push /usr/local/bin/notify-push && \
#        chmod +x /usr/local/bin/notify-push; \
#    fi;
#RUN if [ "${TARGETARCH}" = "arm64" ]; then \
#        curl -o notify-push -L https://github.com/nextcloud/notify_push/releases/download/$PUSH_VERSION/notify_push-aarch64-unknown-linux-musl && \
#        mv notify-push /usr/local/bin/notify-push && \
#        chmod +x /usr/local/bin/notify-push; \
#    fi;

RUN set -ex; \
    \
    apt update; \
    apt install -y --no-install-recommends \
        rsync \
        bzip2 \
        iproute2 \
        libimage-exiftool-perl \
        libldap-common \
    ; \
    apt autoremove -y --purge; \
    apt clean; \
    rm -rf /var/lib/apt/lists/*

RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.interned_strings_buffer=64'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=512'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.huge_code_pages=1;' \
        echo 'opcache.enable_file_override=1;' \
        echo 'opcache.jit_buffer_size=256M;' \
        echo 'opcache.jit=12555;' \
        echo 'opcache.revalidate_freq=5'; \
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
        "https://192.168.0.2:25000/nextcloud/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2"; \
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
COPY --chown=$CONTAINERUSER:$CONTAINERUSER supervisor/notify-push.conf /supervisor/conf.d/notify-push.conf
COPY --chown=$CONTAINERUSER:$CONTAINERUSER supervisor/yacron.yml /supervisor/yacron.yml
COPY --from=notify --chown=$CONTAINERUSER:$CONTAINERUSER /usr/local/bin/notify-push /usr/local/bin/notify-push
COPY --from=ffmpeg /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg /usr/local/bin/ffprobe /usr/local/bin/ffprobe
COPY *.sh upgrade.exclude /

# Add modified entrypoint because fpm already using user 1000
#COPY entrypoint.sh /entrypoint.sh
COPY config/* /usr/src/nextcloud/config/

# No cmd, already inside base image and switch back
USER $CONTAINERUSER
ENTRYPOINT ["/entrypoint-minimal.sh"]
CMD ["supervisord","-c","/supervisor/supervisord.conf"]
