
FROM 192.168.0.2:5050/dedyms/debian:dev AS fetcher
ARG RELEASE
WORKDIR /lychee
RUN curl -o lychee.zip -L https://github.com/LycheeOrg/Lychee/releases/download/$RELEASE/Lychee.zip
RUN unzip lychee.zip

FROM 192.168.0.2:5050/dedyms/ffmpeg-static:latest AS ffmpeg

FROM 192.168.0.2:5050/dedyms/apache:fpm
ARG RELEASE
ENV LYCHEE_VERSION=$RELEASE
COPY --from=ffmpeg /$HOME/.local/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg /$HOME/.local/bin/ffprobe /usr/local/bin/ffprobe
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER /lychee/Lychee/ /var/www/html
COPY apache.conf /etc/apache2/sites-available/000-default.conf
COPY apache-ssl.conf /etc/apache2/sites-available/000-default-ssl.conf
VOLUME /var/www/html/public/uploads
VOLUME /var/www/html/public/sym
VOLUME /var/www/html/database