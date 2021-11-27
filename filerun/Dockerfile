FROM php:7.4-apache-buster
ARG TARGETARCH
ENV FR_DB_HOST=db \
    FR_DB_PORT=3306 \
    FR_DB_NAME=filerun \
    FR_DB_USER=filerun \
    FR_DB_PASS=filerun \
    APACHE_RUN_USER=user \
    APACHE_RUN_USER_ID=1000 \
    APACHE_RUN_GROUP=user \
    APACHE_RUN_GROUP_ID=1000
VOLUME ["/var/www/html", "/user-files"]
# set recommended PHP.ini settings
# see http://docs.filerun.com/php_configuration
COPY filerun-optimization.ini /usr/local/etc/php/conf.d/
COPY autoconfig.php entrypoint.sh wait-for-it.sh import-db.sh filerun.setup.sql supervisord.conf /
# add PHP, extensions and third-party software
RUN apt update && \
    apt-get install -y --no-install-recommends \
        libapache2-mod-xsendfile \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libtiff-dev \
        libwebp-dev \
        libldap2-dev \
        libxml2-dev \
        libzip-dev \
        libcurl4-gnutls-dev \
        libosmesa6-dev \
        libgl1 \
        ufraw \
        dcraw \
        locales \
        imagemagick \
        ffmpeg \
        mariadb-client \
        unzip \
        cron \
        vim \
        supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/log/supervisord /var/run/supervisord && \
    sed -i '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml && \
    docker-php-ext-configure zip && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-configure ldap && \
    docker-php-ext-install -j$(nproc) pdo_mysql exif zip gd opcache ldap && \
    a2enmod rewrite

# Install STL and Install ionCube
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
    curl -O -L https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.zip && \
    unzip -j ioncube_loaders_lin_x86-64.zip ioncube/ioncube_loader_lin_7.4.so -d /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ && \
    echo "zend_extension=ioncube_loader_lin_7.4.so" >> /usr/local/etc/php/conf.d/00_ioncube_loader_lin_7.4.ini && \
    rm -rf ioncube_loaders_lin_x86-64.zip && \
    echo [Install STL-THUMB] && \
    curl -O -L https://github.com/unlimitedbacon/stl-thumb/releases/download/v0.3.1/stl-thumb_0.3.1_amd64.deb && \
    dpkg -i stl-thumb_0.3.1_amd64.deb && \
    rm -rf stl-thumb_0.3.1_amd64.deb; \
    fi
    
RUN if [ "${TARGETARCH}" = "arm64" ]; then \
    curl -O -L https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.zip && \
    unzip -j ioncube_loaders_lin_aarch64.zip ioncube/ioncube_loader_lin_7.4.so -d /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ && \
    echo "zend_extension=ioncube_loader_lin_7.4.so" >> /usr/local/etc/php/conf.d/00_ioncube_loader_lin_7.4.ini && \
    rm -rf ioncube_loaders_lin_aarch64.zip && \
    echo [Install STL-THUMB] && \
    curl -O -L https://github.com/unlimitedbacon/stl-thumb/releases/download/v0.3.1/stl-thumb_0.3.1_arm64.deb && \
    dpkg -i stl-thumb_0.3.1_arm64.deb && \
    rm -rf stl-thumb_0.3.1_arm64.deb; \
    fi

# Enable Apache XSendfile
RUN echo [Enable Apache XSendfile] && \
    mkdir /user-files && \
    echo "XSendFile On\nXSendFilePath /user-files" | tee "/etc/apache2/conf-available/filerun.conf" && \
    a2enconf filerun && \
    echo [Download FileRun installation package version 2021.03.26] && \
    curl -o /filerun.zip -L 'https://f.afian.se/wl/?id=iwmi3ydsxr2Ocq1Lo6atTsIfQA70gDov&fmode=download&recipient=ZmlsZXJ1bi5jb20%3D' && \
    chown www-data:www-data /user-files && \
    chmod +x /wait-for-it.sh /import-db.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
