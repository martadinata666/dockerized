FROM 192.168.0.2:5050/dedyms/node:lts-dev AS fetcher
USER $CONTAINERUSER
WORKDIR $HOME
RUN git clone --depth=1 https://github.com/Tzahi12345/YoutubeDL-Material.git ytdl
#RUN git clone --depth=1 -b 4.3-prep https://github.com/martadinata666/YoutubeDL-Material.git ytdl


FROM 192.168.0.2:5050/dedyms/node:lts-dev AS backend
USER $CONTAINERUSER
WORKDIR $HOME/youtubedl-material
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=fetcher $HOME/ytdl/backend ./backend
WORKDIR $HOME/youtubedl-material/backend
RUN npm -d ci

FROM 192.168.0.2:5050/dedyms/debian:dev as tcd
USER root
COPY fetch-tcd.sh fetch-tcd.sh
RUN ./fetch-tcd.sh


FROM 192.168.0.2:5050/dedyms/ffmpeg-static:latest AS ffmpeg

FROM 192.168.0.2:5050/dedyms/node:lts
ENV NO_UPDATE_NOTIFIER=true
ENV PM2_HOME=$HOME/youtubedl-material/pm2
ENV ALLOW_CONFIG_MUTATIONS=true
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends python3-minimal atomicparsley python3-pip libicu72 && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo npm install -g pm2
WORKDIR $HOME/youtubedl-material
RUN pip3 install --break-system-packages --user --no-cache-dir pycryptodomex
COPY --from=backend --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/youtubedl-material/backend $HOME/youtubedl-material
COPY --chown=$CONTAINERUSER:$CONTAINERUSER ytdl/backend/public $HOME/youtubedl-material/public
COPY --from=tcd --chown=$CONTAINERUSER:$CONTAINERUSR /usr/local/bin/TwitchDownloaderCLI /usr/local/bin/TwitchDownloaderCLI
COPY --from=ffmpeg --chown=$CONTAINERUSER:$CONTAINERUSER /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg --chown=$CONTAINERUSER:$CONTAINERUSER /usr/local/bin/ffprobe /usr/local/bin/ffprobe
RUN mkdir -p $HOME/youtubedl-material/audio $HOME/youtubedl-material/users
VOLUME ["$HOME/youtubedl-material/audio","$HOME/youtubedl-material/video","$HOME/youtubedl-material/appdata","$HOME/youtubedl-material/users","$HOME/youtubedl-material/subscriptions"]
CMD ["pm2-docker","app.js"]


#    sudo pip3 install --user --no-cache-dir tcd && \
