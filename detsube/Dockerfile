FROM 192.168.0.2:5050/dedyms/node:16-dev AS tukang
RUN apt update && \
    apt install -y --no-install-recommends python3-dev python-is-python3
USER $CONTAINERUSER
RUN git clone --depth=1 https://github.com/diogonr/detsube.git $HOME/detsube
WORKDIR $HOME/detsube
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN npm install
FROM 192.168.0.2:5050/dedyms/ffmpeg-static AS ffmpeg

FROM 192.168.0.2:5050/dedyms/node:16
RUN apt update && apt install -y --no-install-recommends python3-minimal python-is-python3 libfontconfig1 && apt clean && rm -rf /var/lib/apt/lists/*
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang $HOME/detsube $HOME/detsube
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=ffmpeg $HOME/.local $HOME/.local
WORKDIR $HOME/detsube
#testt workaround
RUN sed -i 's/false/true/g' src/core/services/database.service.ts
USER $CONTAINERUSER
VOLUME $HOME/detsube/db
CMD ["npm","run","start:dev"]