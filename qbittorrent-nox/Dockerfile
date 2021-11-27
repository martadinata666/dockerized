FROM 192.168.0.2:5050/dedyms/debian:latest AS fetcher
#FROM debian:latest as fetcher
ARG QBVERSION
#ARG VUERELEASE
ARG TARGETARCH
RUN echo $TARGETOS $TARGETARCH
RUN apt update && \
    apt install -y --no-install-recommends wget git && \
    apt clean && \
    rm -rf /var/lib/apt/*
WORKDIR /home/$CONTAINERUSER
USER $CONTAINERUSER
#RUN wget https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-$QBVERSION\_v$LIBTORRENT/x86_64-qbittorrent-nox && \ 
#    chmod +x ./x86_64-qbittorrent-nox && \
#    ls -al && \
#    mv ./x86_64-qbittorrent-nox /home/$CONTAINERUSER/.local/bin/qbittorrent-nox && \
#    git clone --single-branch --branch latest-release https://github.com/WDaan/VueTorrent.git

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
#FROM debian:latest
WORKDIR $HOME
ARG QBVERSION
#ARG VUERELEASE
ENV QBITTORRENT_VERSION=$QBVERSION
#ENV VUE_RELEASE=$VUERELEASE
ENV WEBPORT=8090
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER/.local/bin/ /home/$CONTAINERUSER/.local/bin/
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER/VueTorrent/ /home/$CONTAINERUSER/.local/share/VueTorrent/
USER $CONTAINERUSER
CMD ["bash", "-c", "qbittorrent-nox --webui-port=$WEBPORT"]
