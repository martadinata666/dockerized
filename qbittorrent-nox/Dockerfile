FROM 192.168.0.2:5050/dedyms/debian:dev AS fetcher
ARG QBVERSION
ARG TARGETARCH
RUN echo $TARGETOS $TARGETARCH
#RUN apt update && \
#    apt install -y --no-install-recommends wget git && \
#    apt clean && \
#    rm -rf /var/lib/apt/*
WORKDIR /home/$CONTAINERUSER
USER $CONTAINERUSER
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
        wget https://github.com/userdocs/qbittorrent-nox-static/releases/download/$QBVERSION/x86_64-qbittorrent-nox && \
        mv ./x86_64-qbittorrent-nox /home/$CONTAINERUSER/.local/bin/qbittorrent-nox; \
    fi;

RUN if [ "${TARGETARCH}" = "arm64" ]; then \
        wget https://github.com/userdocs/qbittorrent-nox-static/releases/download/$QBVERSION/aarch64-qbittorrent-nox && \
        mv ./aarch64-qbittorrent-nox /home/$CONTAINERUSER/.local/bin/qbittorrent-nox; \
    fi;
RUN chmod +x $HOME/.local/bin/qbittorrent-nox
RUN git clone --single-branch --depth=1 --branch latest-release https://github.com/WDaan/VueTorrent.git

FROM 192.168.0.2:5050/dedyms/debian:latest
WORKDIR $HOME
ARG QBVERSION
ENV QBITTORRENT_VERSION=$QBVERSION
ENV WEBPORT=8090
USER $CONTAINERUSER
RUN mkdir -p $HOME/qbittorrent/downloads && mkdir -p $HOME/qbittorrent/qBittorrent/config && chown -R $CONTAINERUSER:$CONTAINERUSER $HOME/qbittorrent
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local/bin/ $HOME/.local/bin/
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/VueTorrent/ $HOME/qbittorrent/VueTorrent/
COPY --chown=$CONTAINERUSER:$CONTAINERUSER qBittorrent.conf $HOME/qbittorrent/qBittorrent/config/qBittorrent.conf
VOLUME $HOME/qbittorrent/downloads
WORKDIR $HOME/qbittorrent
CMD ["bash", "-c", "qbittorrent-nox --webui-port=$WEBPORT --profile=$HOME/qbittorrent"]
