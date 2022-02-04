FROM 192.168.0.2:5050/dedyms/debian:dev AS tukang
WORKDIR /src
RUN apt update && apt install -y --no-install-recommends build-essential cmake libmpdclient-dev libssl-dev unzip
#ADD https://github.com/notandy/ympd/archive/master.zip master.zip
RUN git clone --depth=1  https://github.com/SuperBFG7/ympd.git /src/
#ADD https://github.com/martadinata666/ympd-1/archive/refs/heads/master.zip master.zip
#RUN unzip master.zip -d /src/
#WORKDIR /src/
RUN cmake /src/ && \
    make

FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && apt install -y --no-install-recommends libmpdclient2 openssl mpd mpc supervisor icecast2 && rm -rf /var/lib/apt/lists/* && apt clean
WORKDIR $HOME
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang /src/ympd $HOME/.local/bin/ympd
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang /src/mkdata $HOME/.local/bin/mkdata
COPY --chown=$CONTAINERUSER:$CONTAINERUSER mpd.conf $HOME/mpd/mpd.conf
COPY --chown=$CONTAINERUSER:$CONTAINERUSER icecast.xml $HOME/mpd/icecast.xml
COPY --chown=$CONTAINERUSER:$CONTAINERUSER supervisor $HOME/supervisor
ENV MPD_SERVER=localhost
ENV MPD_PORT=6600
ENV WEBPORT=8080
EXPOSE 8080/tcp
USER $CONTAINERUSER
RUN mkdir -p $HOME/mpd && \
    mkdir -p $HOME/mpd/playlists
VOLUME $HOME/mpd
#CMD ympd -h $MPD_SERVER -p $MPD_PORT
CMD ["supervisord","-c","/home/debian/supervisor/supervisord.conf"]
