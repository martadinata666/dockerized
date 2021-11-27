FROM 192.168.0.2:5050/dedyms/ffmpeg-static:latest AS ffmpeg

FROM 192.168.0.2:5050/dedyms/debian:latest AS downloader
RUN apt update && apt install wget unzip
USER $CONTAINERUSER
WORKDIR $HOME
RUN wget https://github.com/trebonius0/Photato/releases/download/1.0.2/Photato-Release.zip && unzip Photato-Release.zip && ls -al 

FROM 192.168.0.2:5050/dedyms/jre:11
RUN apt update && apt install -y --no-install-recommends exiftool && apt clean && rm -rf /var/lib/apt/lists/*
ENV LANG C.UTF-8
ENV PHOTATO_VERSION=1.0.2
USER $CONTAINERUSER
COPY --from=ffmpeg --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local/bin $HOME/.local/bin
COPY --from=downloader --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/Photato-Release.jar $HOME/.local/bin/photato.jar
COPY --from=downloader --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/www $HOME/photato/www
COPY --chown=$CONTAINERUSER:$CONTAINERUSER photato.ini $HOME/photato/config/photato.ini
RUN mkdir -p $HOME/photato/pictures $HOME/photato/cache $HOME/photato/config
WORKDIR $HOME/photato
VOLUME $HOME/photato/pictures $HOME/photato/cache $HOME/photato/config
EXPOSE 8186

# start
#ENTRYPOINT ["java", "-jar", "Photato-Release.jar", "/pictures", "/cache", "/config"]
CMD ["bash", "-c", "java -jar $HOME/.local/bin/photato.jar $HOME/photato/pictures $HOME/photato/cache $HOME/photato/config"]
