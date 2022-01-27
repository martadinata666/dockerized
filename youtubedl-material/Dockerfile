FROM 192.168.0.2:5050/dedyms/node:lts-dev AS fetcher
USER $CONTAINERUSER
WORKDIR $HOME
RUN git clone --depth=1 https://github.com/Tzahi12345/YoutubeDL-Material.git ytdl

FROM 192.168.0.2:5050/dedyms/node:lts-dev AS frontend
RUN npm -d install -g @angular/cli && rm -rf $HOME/.npm && rm -rf $HOME/.config
USER $CONTAINERUSER
WORKDIR $HOME/youtubedl-material
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=fetcher $HOME/ytdl/package.json package.json
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=fetcher $HOME/ytdl/package-lock.json package-lock.json
RUN npm install && ls -al
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=fetcher $HOME/ytdl/angular.json angular.json
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=fetcher $HOME/ytdl/tsconfig.json tsconfig.json
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=fetcher $HOME/ytdl/src ./src
RUN ng build --prod && ls -al


FROM 192.168.0.2:5050/dedyms/node:lts-dev AS backend
USER $CONTAINERUSER
WORKDIR $HOME/youtubedl-material
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=fetcher $HOME/ytdl/backend ./backend
WORKDIR $HOME/youtubedl-material/backend
RUN npm -d install --prod && ls -al

FROM 192.168.0.2:5050/dedyms/ffmpeg-static:latest AS ffmpeg

FROM 192.168.0.2:5050/dedyms/node:lts
ENV NO_UPDATE_NOTIFIER=true
ENV FOREVER_ROOT=$HOME/youtubedl-material/.forever
RUN apt update && \
    apt install -y --no-install-recommends python3-minimal atomicparsley python-is-python3 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g forever && \
    rm -rf $HOME/.config
USER $CONTAINERUSER
WORKDIR $HOME/youtubedl-material
COPY --from=backend --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/youtubedl-material/backend $HOME/youtubedl-material
COPY --from=frontend --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/youtubedl-material/backend/public $HOME/youtubedl-material/public
COPY --from=ffmpeg --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local/bin $HOME/.local/bin
COPY --chown=$CONTAINERUSER:$CONTAINERUSER default.json $HOME/youtubedl-material/appdata/default.json
RUN mkdir -p $HOME/youtubedl-material/audio $HOME/youtubedl-material/video
VOLUME $HOME/youtubedl-material/audio
VOLUME $HOME/youtubedl-material/video
VOLUME $HOME/youtubedl-material/appdata
EXPOSE 8080
CMD ["node","app.js"]
