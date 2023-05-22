
# FFMPEG for converting
FROM 192.168.0.2:5050/dedyms/ffmpeg-static AS ffmpeg

# Fetch and build node modules
FROM 192.168.0.2:5050/dedyms/node:lts-dev AS tukang
RUN apt update && \
    apt install -y --no-install-recommends python3-dev python-is-python3
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=ffmpeg $HOME/.local/bin $HOME/.local/bin
USER $CONTAINERUSER
RUN git clone --depth=1 https://github.com/diogonr/detsube.git $HOME/detsube
WORKDIR $HOME/detsube
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN pnpm -d fetch && \
    pnpm -d install

# Runtime image
FROM 192.168.0.2:5050/dedyms/node:lts
RUN apt update && apt install -y --no-install-recommends python3-minimal python-is-python3 libfontconfig1 && apt clean && rm -rf /var/lib/apt/lists/*
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang $HOME/detsube $HOME/detsube
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=ffmpeg $HOME/.local $HOME/.local
WORKDIR $HOME/detsube
#RUN sed -i 's/false/true/g' src/core/services/database.service.ts
USER $CONTAINERUSER
VOLUME $HOME/detsube/db
CMD ["pnpm","run","start:dev"]