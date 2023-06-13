FROM 192.168.0.2:5050/dedyms/debian:dev AS tukangmpd
ARG RELEASE
RUN git clone --depth=1 -b $RELEASE https://github.com/MusicPlayerDaemon/MPD.git MPD
WORKDIR $HOME/MPD
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends meson g++ \
    libfmt-dev \
    libpcre2-dev \
    libmad0-dev libid3tag0-dev \
    libflac-dev libvorbis-dev libopus-dev libogg-dev \
    libsndfile1-dev libfaad-dev libwavpack-dev \
    libmp3lame-dev \
    libsamplerate0-dev libcurl4-gnutls-dev libyajl-dev libexpat-dev libshout3-dev \
    libmpdclient-dev \
    libsqlite3-dev \
    libboost-dev \
    libicu-dev
RUN meson . output/release --buildtype=debugoptimized -Db_ndebug=true
RUN ninja -C output/release -j$(nproc)


FROM 192.168.0.2:5050/dedyms/debian:dev AS tukangympd
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends cmake libmpdclient-dev libssl-dev
#ADD https://github.com/notandy/ympd/archive/master.zip master.zip
RUN git clone --depth=1 https://github.com/martadinata666/ympd.git ympd
WORKDIR $HOME/ympd
RUN cmake . && \
    make

FROM 192.168.0.2:5050/dedyms/debian:dev as tukangmpdscribble
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends meson pkg-config cmake libmpdclient-dev libgcrypt20-dev
RUN git clone --depth=1 https://github.com/MusicPlayerDaemon/mpdscribble mpdscribble
WORKDIR $HOME/mpdscribble
RUN meson build
WORKDIR $HOME/mpdscribble/build
RUN sudo ninja install

FROM 192.168.0.2:5050/dedyms/debian:latest
ARG RELEASE
ENV MPD_VERSION=$RELEASE
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends supervisor icecast2 ncmpcpp \
                                           libfmt9 libyajl2 sqlite3 libicu72 libcurl3-gnutls \
                                           libsamplerate0 libid3tag0 libshout3 libflac12 libfaad2 libmad0 libmpg123-0 \
                                           libmpdclient2 libsndfile1 libwavpack1 libmp3lame0 libtwolame0 libshine3 && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo apt clean
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukangmpd $HOME/MPD/output/release/mpd /usr/local/bin/mpd
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukangympd $HOME/ympd/ympd /usr/local/bin/ympd
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukangympd $HOME/ympd/mkdata /usr/local/bin/mkdata
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukangmpdscribble /usr/local/bin/mpdscribble /usr/local/bin/mpdscribble
COPY --chown=$CONTAINERUSER:$CONTAINERUSER config/* $HOME/mpd/
COPY --chown=$CONTAINERUSER:$CONTAINERUSER supervisor /supervisor
ENV MPD_SERVER=localhost
ENV MPD_PORT=6600
ENV WEBPORT=8080
EXPOSE 8080/tcp
USER $CONTAINERUSER
RUN mkdir -p $HOME/mpd && \
    mkdir -p $HOME/mpd/data $HOME/mpd/data/playlists $HOME/mpd/icecast-log $HOME/mpd/scrobble
VOLUME $HOME/mpd
#CMD ympd -h $MPD_SERVER -p $MPD_PORT
CMD ["supervisord","-c","/supervisor/supervisord.conf"]
