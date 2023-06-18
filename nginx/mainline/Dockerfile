#syntax=docker/dockerfile:1.4
# Get ssl autogeneration by using debian then copy to nginx alpine
FROM 192.168.0.2:5050/dedyms/debian:latest AS sslgenerator
RUN sudo apt update && sudo apt install -y ssl-cert

FROM 192.168.0.2:5050/dedyms/debian:latest
RUN sudo apt update && \
    sudo apt install -y nginx-full && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*

RUN sudo mkdir -p /etc/ssl/localcerts && \
    sudo mkdir -p /var/www/html && \
    sudo mkdir -p /var/cache/nginx && \
    sudo mkdir -p /run/nginx/ && \
    sudo ln -sf /dev/stdout /var/log/nginx/access.log && \
    sudo ln -sf /dev/stderr /var/log/nginx/error.log && \
    sudo chown -R $CONTAINERUSER:$CONTAINERUSER /var/www/html /var/cache/nginx /var/log/nginx /var/lib/nginx
COPY --from=sslgenerator /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/localcerts/nginx.pem
COPY --from=sslgenerator /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/localcerts/nginx.key
COPY --chown=$CONTAINERUSER:$CONTAINERUSER mainline/default.conf /etc/nginx/conf.d/default.conf
COPY --chown=$CONTAINERUSER:$CONTAINERUSER mainline/nginx.conf /etc/nginx/nginx.conf
RUN sudo chmod 666 /etc/ssl/localcerts/nginx*

USER $CONTAINERUSER
STOPSIGNAL SIGQUIT
VOLUME /var/www/html
WORKDIR /var/www/html
CMD ["nginx", "-g", "daemon off;"]