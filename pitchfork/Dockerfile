
FROM 192.168.0.2:5050/dedyms/apache2:fcgid AS tukang
WORKDIR /var/www/html
USER root
RUN apt update -y && apt install -y unzip && apt clean && rm -rf /var/lib/apt/lists && rm /var/www/html/index.html
USER $CONTAINERUSER
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/martadinata666/pitchfork/archive/master.zip /var/www/html
RUN unzip master.zip -d /var/www/html && rm master.zip

FROM 192.168.0.2:5050/dedyms/apache2:fcgid
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /var/www/html/pitchfork-master/ /var/www/html/
VOLUME /var/www/html/config
