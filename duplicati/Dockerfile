FROM 192.168.0.2:5050/dedyms/debian:latest AS fetcher
ARG RELEASE
ARG RELEASELINK
RUN apt update && \
    apt install -y --no-install-recommends unzip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
USER $CONTAINERUSER
RUN mkdir -p $HOME/duplicati
WORKDIR $HOME/duplicati
RUN mkdir -p $HOME/duplicati && \
    mkdir -p $HOME/duplicati/data && \
    curl -o duplicati.zip -L ${RELEASELINK} && \
    unzip ./duplicati.zip -d ./ && \
    rm duplicati.zip && \
    ls -al


FROM 192.168.0.2:5050/dedyms/mono:latest
ARG RELEASE
ENV DUPLICATI_VERSION=${RELEASE}
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/duplicati $HOME/duplicati
USER $CONTAINERUSER
VOLUME $HOME/duplicati/data
WORKDIR $HOME/duplicati
CMD ["mono","Duplicati.Server.exe","--webservice-interface=any","--server-datafolder=/home/debian/duplicati/data","--webservice-allowed-hostnames=*"]
