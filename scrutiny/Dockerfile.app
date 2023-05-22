FROM 192.168.0.2:5050/dedyms/debian:latest AS tukang
ARG RELEASE
ARG TARGETARCH
USER $CONTAINERUSER
RUN mkdir -p $HOME/scrutiny/config && \
    mkdir -p $HOME/scrutiny/web && \
    mkdir -p $HOME/scrutiny/bin && \
    mkdir -p $HOME/scrutiny/data
WORKDIR $HOME/scrutiny
COPY scrutiny.yaml $HOME/scrutiny/config/scrutiny.yaml
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/AnalogJ/scrutiny/releases/download/$RELEASE/scrutiny-web-linux-$TARGETARCH $HOME/scrutiny/bin
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/AnalogJ/scrutiny/releases/download/$RELEASE/scrutiny-web-frontend.tar.gz $HOME/scrutiny/web
RUN chmod +x $HOME/scrutiny/bin/scrutiny-web-linux-$TARGETARCH && \
    mv $HOME/scrutiny/bin/scrutiny-web-linux-$TARGETARCH $HOME/scrutiny/bin/scrutiny-web-linux && \
    tar xvzf $HOME/scrutiny/web/scrutiny-web-frontend.tar.gz --strip-components 1 -C $HOME/scrutiny/web && \
    rm $HOME/scrutiny/web/scrutiny-web-frontend.tar.gz


FROM 192.168.0.2:5050/dedyms/debian:latest
ARG RELEASE
ENV SCRUTINY_VERSION=$RELEASE
USER $CONTAINERUSER
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/scrutiny /opt/scrutiny
VOLUME /opt/scrutiny/data
CMD /opt/scrutiny/bin/scrutiny-web-linux start
