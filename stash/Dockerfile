FROM 192.168.0.2:5050/dedyms/debian:latest AS fetcher
ARG VERSION
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends wget
USER $CONTAINERUSER
WORKDIR $HOME
ARG TARGETARCH
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
       wget --progress=dot:mega https://github.com/stashapp/stash/releases/download/$VERSION/stash-linux && \ 
       chmod +x ./stash-linux; \
    fi;

RUN if [ "${TARGETARCH}" = "arm64" ]; then \
       wget --progress=dot:mega https://github.com/stashapp/stash/releases/download/$VERSION/stash-linux-arm64v8 && \
       mv stash-linux-arm64v8 stash-linux && \
       chmod +x ./stash-linux; \
    fi;

#RUN wget https://github.com/stashapp/stash/releases/download/$VERSION/stash-linux && chmod +x ./stash-linux

#FROM 192.168.0.2:5050/dedyms/ffmpeg-static:latest AS ffmpeg

FROM 192.168.0.2:5050/dedyms/ffmpeg:6
ARG VERSION
ENV STASH_CONFIG_FILE=$HOME/stash/config.yml
ENV STASH_VERSION=$VERSION
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends python3-minimal python-is-python3 && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists* && \
    sudo ln -s /usr/local/bin/ffmpeg $HOME/.local/bin/ffmpeg && \
    sudo ln -s /usr/local/bin/ffprobe $HOME/.local/bin/ffprobe
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/stash-linux $HOME/.local/bin/stash
USER $CONTAINERUSER
RUN mkdir $HOME/stash
WORKDIR $HOME/stash
VOLUME $HOME/stash
CMD ["stash"]
