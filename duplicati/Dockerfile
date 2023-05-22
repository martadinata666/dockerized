FROM 192.168.0.2:5050/dedyms/debian:latest AS fetcher
USER root
ARG RELEASE
ARG RELEASELINK
RUN apt update && \
    apt install -y --no-install-recommends unzip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
USER $CONTAINERUSER
RUN mkdir -p $HOME/duplicati
WORKDIR $HOME/duplicati
COPY --chown=$CONTAINERUSER:$CONTAINERUSER duplicati.zip duplicati.zip
RUN mkdir -p $HOME/duplicati/data && \
    unzip ./duplicati.zip -d ./ && \
    rm duplicati.zip && \
    ls -al


FROM 192.168.0.2:5050/dedyms/mono:latest
#FROM mcr.microsoft.com/dotnet/sdk:6.0.402-bullseye-slim
#ARG HOME=/home/debian
#ARG CONTAINERUSER=debian
#RUN groupadd --gid 1000 debian && \
#    useradd --system --create-home --uid 1000 --gid 1000 debian
ENV DUPLICATI_VERSION=${RELEASE}
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends libsqlite3-0 && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/duplicati $HOME/duplicati
USER $CONTAINERUSER
VOLUME $HOME/duplicati/data
WORKDIR $HOME/duplicati
CMD ["mono","Duplicati.Server.exe","--webservice-interface=any","--server-datafolder=/home/debian/duplicati/data","--webservice-allowed-hostnames=*"]
#CMD ["dotnet","Duplicati.Server.exe","--webservice-interface=any","--server-datafolder=/home/debian/duplicati/data","--webservice-allowed-hostnames=*"]
