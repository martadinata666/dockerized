FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && apt install -y --no-install-recommends apache2 ssl-cert libapache2-mod-php && apt clean && rm -rf /var/lib/apt/lists/*
RUN usermod --append --groups ssl-cert $CONTAINERUSER
RUN a2enmod ssl && a2enmod rewrite
COPY ports.conf /etc/apache2/ports.conf
COPY envvars /etc/apache2/envvars
RUN chown $CONTAINERUSER:$CONTAINERUSER /var/www/html
USER $CONTAINERUSER
WORKDIR /var/www/html
VOLUME /var/www/html
CMD ["apache2ctl", "-DFOREGROUND"]
