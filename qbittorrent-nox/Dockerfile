
FROM 192.168.0.2:5050/dedyms/debian:dev AS fetcher
ARG QBVERSION
ARG MATUIRELEASE
ARG ZIPRELEASE
ARG TARGETARCH
ARG TARGETPLATFORM
RUN echo $TARGETOS $TARGETARCH
#RUN apt update && \
#    apt install -y --no-install-recommends wget git && \
#    apt clean && \
#    rm -rf /var/lib/apt/*
WORKDIR $HOME
USER $CONTAINERUSER
# Fetch qbittorrent-binary
RUN pwd
RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  QBIT_ARCH=x86_64  ;; \
         "linux/arm64")  QBIT_ARCH=aarch64  ;; \
    esac \ 
    && curl -L https://github.com/userdocs/qbittorrent-nox-static/releases/download/$QBVERSION/$QBIT_ARCH-qbittorrent-nox -o qbittorrent-nox && \
    mv ./qbittorrent-nox $HOME/.local/bin/qbittorrent-nox; 

#RUN if [ "${TARGETARCH}" = "amd64" ]; then \
#        wget https://github.com/userdocs/qbittorrent-nox-static/releases/download/$QBVERSION/x86_64-cmake-qbittorrent-nox && \
#        mv ./x86_64-cmake-qbittorrent-nox /home/$CONTAINERUSER/.local/bin/qbittorrent-nox; \
#    fi;

#RUN if [ "${TARGETARCH}" = "arm64" ]; then \
#        wget https://github.com/userdocs/qbittorrent-nox-static/releases/download/$QBVERSION/aarch64-cmake-qbittorrent-nox && \
#        mv ./aarch64-cmake-qbittorrent-nox /home/$CONTAINERUSER/.local/bin/qbittorrent-nox; \
#    fi;
RUN chmod +x $HOME/.local/bin/qbittorrent-nox
#RUN git clone --single-branch --depth=1 --branch latest-release https://github.com/WDaan/VueTorrent.git
RUN curl -o matui.zip -L https://github.com/bill-ahmed/qbit-matUI/releases/download/$MATUIRELEASE/qbit-matUI\_Unix\_$ZIPRELEASE.zip && \
    unzip matui.zip && \
    mv qbit-matUI\_Unix\_$ZIPRELEASE matui

FROM 192.168.0.2:5050/dedyms/debian:latest
WORKDIR $HOME
ARG QBVERSION
ARG MATUIRELEASE
ENV QBITTORRENT_VERSION=$QBVERSION
ENV QBIT_MATYUI_RELEASE=$MATUIRELEASE
ENV WEBPORT=8090
USER $CONTAINERUSER
RUN pwd && mkdir -p $HOME/qbittorrent/downloads && mkdir -p $HOME/qbittorrent/qBittorrent/config && chown -R $CONTAINERUSER:$CONTAINERUSER $HOME/qbittorrent
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local/bin/ $HOME/.local/bin/
#COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/VueTorrent/ $HOME/VueTorrent/
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/matui/ $HOME/matui/
COPY --chown=$CONTAINERUSER:$CONTAINERUSER qBittorrent.conf $HOME/qbittorrent/qBittorrent/config/qBittorrent.conf
VOLUME $HOME/qbittorrent
WORKDIR $HOME/qbittorrent
CMD ["bash", "-c", "qbittorrent-nox --webui-port=$WEBPORT --profile=$HOME/qbittorrent"]
