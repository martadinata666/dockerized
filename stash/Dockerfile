FROM 192.168.0.2:5050/dedyms/debian:latest AS fetcher
ARG VERSION
RUN apt update && apt install -y --no-install-recommends wget
USER $CONTAINERUSER
WORKDIR $HOME
ARG TARGETARCH
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
       wget https://github.com/stashapp/stash/releases/download/$VERSION/stash-linux && \ 
       chmod +x ./stash-linux; \
    fi;

RUN if [ "${TARGETARCH}" = "arm64" ]; then \
       wget https://github.com/stashapp/stash/releases/download/$VERSION/stash-linux-arm64v8 && \
       mv stash-linux-arm64v8 stash-linux && \
       chmod +x ./stash-linux; \
    fi;

#RUN wget https://github.com/stashapp/stash/releases/download/$VERSION/stash-linux && chmod +x ./stash-linux

FROM 192.168.0.2:5050/dedyms/ffmpeg-static:latest AS ffmpeg

FROM 192.168.0.2:5050/dedyms/debian:latest
ARG VERSION
ENV STASH_CONFIG_FILE=$HOME/stash/config.yml
ENV STASH_VERSION=$VERSION
COPY --from=ffmpeg --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local/bin $HOME/.local/bin
COPY --from=fetcher --chown=$CONTAINERUSER $HOME/stash-linux $HOME/.local/bin/stash
EXPOSE 9999
USER $CONTAINERUSER
RUN mkdir $HOME/stash
WORKDIR $HOME/stash
VOLUME $HOME/stash
CMD ["stash"]
