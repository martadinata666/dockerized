
FROM 192.168.0.2:5050/dedyms/owntone-server:dev AS tukang
RUN apt update && apt install -y --no-install-recommends git
USER $CONTAINERUSER
ARG RELEASE
RUN git clone -b $RELEASE https://github.com/owntone/owntone-server.git $HOME/owntone-src
WORKDIR $HOME/owntone-src
RUN autoreconf -i && \
    ./configure --prefix=$HOME/.local \
                --sysconfdir=$HOME/owntone \
                --localstatedir=$HOME/owntone \
                --disable-install-user \
                --with-pulseaudio \
                --disable-libspotify \
                --enable-spotify \
                --enable-lastfm \
                --without-alsa \
                --disable-option-checking \
                --disable-install-systemd && \
    make -j6 && \
    make install

FROM 192.168.0.2:5050/dedyms/debian:latest
ENV PATH="$HOME/.local/sbin:$PATH"
ARG RELEASE
ENV OWNTONE_RELEASE=$RELEASE
RUN apt update && apt install -y --no-install-recommends antlr3 libantlr3c-dev libconfuse-dev libunistring-dev libsqlite3-dev \
  libavcodec-dev libavformat-dev libavfilter-dev libswscale-dev libavutil-dev \
  libmxml-dev libgcrypt20-dev libavahi-client-dev zlib1g-dev \
  libevent-dev libplist-dev libsodium-dev libjson-c-dev \
  libcurl4-openssl-dev libprotobuf-c-dev libpulse-dev libwebsockets-dev && \
  apt remove -y --purge *-dev && \
  apt install -y libavfilter7 libavformat58 libavcodec58 avahi-daemon libnss-mdns && \
  apt clean && \ 
  rm -rf /var/lib/apt/lists/*
#RUN mkdir supervisord
#COPY supervisord.conf /supervisord/supervisord.conf
COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local $HOME/.local
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/owntone $HOME/owntone
COPY --chown=$CONTAINERUSER:$CONTAINERUSER owntone.conf $HOME/owntone/owntone.conf
USER $CONTAINERUSER
VOLUME $HOME/owntone
WORKDIR $HOME/owntone
CMD ["owntone","-c","./owntone.conf","-f","-P","./owntone.pid","-w","/$HOME/.local/share/owntone/htdocs"]
