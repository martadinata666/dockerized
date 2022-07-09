FROM 192.168.0.2:5050/dedyms/debian:dev AS tukangmpd
ARG RELEASE
RUN git clone --depth=1 -b $RELEASE https://github.com/MusicPlayerDaemon/MPD.git
WORKDIR /MPD
RUN apt update && \
    apt install -y --no-install-recommends meson g++ \
    libfmt-dev \
    libpcre2-dev \
    libmad0-dev libmpg123-dev libid3tag0-dev \
    libflac-dev libvorbis-dev libopus-dev libogg-dev \
    libsndfile1-dev libfaad-dev libwavpack-dev \
    libmp3lame-dev libtwolame-dev libshine-dev \
    libsamplerate0-dev libcurl4-gnutls-dev libyajl-dev libexpat-dev libshout3-dev \
    libmpdclient-dev \
    libsqlite3-dev \
    libboost-dev \
    libicu-dev
RUN meson . output/release --buildtype=debugoptimized -Db_ndebug=true
RUN ninja -C output/release


FROM 192.168.0.2:5050/dedyms/debian:dev AS tukangympd
WORKDIR /src
RUN apt update && apt install -y --no-install-recommends cmake libmpdclient-dev libssl-dev
#ADD https://github.com/notandy/ympd/archive/master.zip master.zip
RUN git clone --depth=1 https://github.com/martadinata666/ympd.git /src/
RUN cmake /src/ && \
    make

FROM 192.168.0.2:5050/dedyms/debian:latest
ARG RELEASE
ENV MPD_VERSION=$RELEASE
RUN apt update && \
    apt install -y --no-install-recommends supervisor icecast2 \
                                           libfmt7 libyajl2 sqlite3 libicu67 libcurl3-gnutls \
                                           libsamplerate0 libid3tag0 libshout3 libflac8 libfaad2 libmad0 libmpg123-0 \
                                           libmpdclient2 libsndfile1 libwavpack1 libmp3lame0 libtwolame0 libshine3 && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean
WORKDIR $HOME
COPY --chown=$CONTAINERUSER:$CONTAINERSER --from=tukangmpd /MPD/output/release/mpd $HOME/.local/bin/mpd
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukangympd /src/ympd $HOME/.local/bin/ympd
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukangympd /src/mkdata $HOME/.local/bin/mkdata
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
