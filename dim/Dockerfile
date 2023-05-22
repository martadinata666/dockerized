#FROM 192.168.0.2:5050/dedyms/node:lts-dev AS build-web
#ARG DEBIAN_FRONTEND=noninteractive
#USER $CONTAINERUSER
#RUN git clone https://github.com/Dusk-Labs/dim.git $HOME/dim
#WORKDIR $HOME/dim/ui
#RUN yarn && yarn build


#FROM 192.168.0.2:5050/dedyms/dim:dev-rust AS build-app
#COPY dim /dim
#WORKDIR /dim
#RUN sqlite3 -init ./database/migrations/*.sql ./dim_dev.db
#RUN DATABASE_URL="sqlite:///dim/dim_dev.db" cargo build --release
#ARG DATABASE_URL="sqlite://dim_dev.db"
#RUN cargo build --release
#RUN cargo build --features vaapi --release


FROM 192.168.0.2:5050/dedyms/debian:vaapi
ENV RUST_BACKTRACE=full
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_DIR=/etc/ssl/certs
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            libsqlite3-0 libva2 libva-drm2 libharfbuzz0b \
            libfontconfig libfribidi0 libtheora0 libvorbis0a libvorbisenc2 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/dim/ && \
    chown $CONTAINERUSER:$CONTAINERUSER /opt/dim/
COPY --chown=$CONTAINERUSER:$CONTAINERUSER dim/target/release/dim /opt/dim/dim
USER $CONTAINERUSER
RUN mkdir -p /opt/dim/config /opt/dim/utils
RUN ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /opt/dim/utils/ffmpeg && \
    ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /opt/dim/utils/ffprobe
EXPOSE 8000
WORKDIR /opt/dim
VOLUME ["/opt/dim/config"]
CMD ["./dim"]

