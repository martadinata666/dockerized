#syntax=docker/dockerfile:1.4
FROM 192.168.0.2:5050/dedyms/debian:latest AS tukang
ARG RELEASE
ARG TARGETARCH
USER $CONTAINERUSER
RUN mkdir -p /home/$CONTAINERUSER/scrutiny/config && \
    mkdir -p /home/$CONTAINERUSER/scrutiny/web && \
    mkdir -p /home/$CONTAINERUSER/scrutiny/bin
WORKDIR /home/$CONTAINERUSER/scrutiny
COPY scrutiny.yaml /home/$CONTAINERUSER/scrutiny/config/scrutiny.yaml
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/AnalogJ/scrutiny/releases/download/$RELEASE/scrutiny-web-linux-$TARGETARCH /home/$CONTAINERUSER/scrutiny/bin
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/AnalogJ/scrutiny/releases/download/$RELEASE/scrutiny-web-frontend.tar.gz /home/$CONTAINERUSER/scrutiny/web
RUN chmod +x /home/$CONTAINERUSER/scrutiny/bin/scrutiny-web-linux-$TARGETARCH && \
    mv /home/$CONTAINERUSER/scrutiny/bin/scrutiny-web-linux-$TARGETARCH /home/$CONTAINERUSER/scrutiny/bin/scrutiny-web-linux && \
    tar xvzf /home/$CONTAINERUSER/scrutiny/web/scrutiny-web-frontend.tar.gz --strip-components 1 -C /home/$CONTAINERUSER/scrutiny/web && \
    rm /home/$CONTAINERUSER/scrutiny/web/scrutiny-web-frontend.tar.gz


FROM 192.168.0.2:5050/dedyms/debian:latest
ARG RELEASE
ENV SCRUTINY_VERSION=$RELEASE
USER $CONTAINERUSER
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER/scrutiny /scrutiny
VOLUME /scrutiny
CMD /scrutiny/bin/scrutiny-web-linux start
