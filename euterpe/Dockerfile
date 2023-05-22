FROM 192.168.0.2:5050/dedyms/go:latest AS tukang
ARG RELEASE
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends libtagc0-dev upx-ucl libicu-dev git ssl-cert make
RUN git clone -b $RELEASE https://github.com/ironsmile/euterpe.git $HOME/euterpe
WORKDIR $HOME/euterpe
RUN make release && \
    mv euterpe /tmp/euterpe
#RUN go build --tags "sqlite_icu" -ldflags "-X github.com/ironsmile/euterpe/src/version.Version=`git describe --tags --always`" -o euterpe && \
#    upx euterpe


FROM 192.168.0.2:5050/dedyms/debian:latest
RUN sudo apt-get update && \
    sudo apt-get install -y libtagc0 libicu72 && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*
RUN mkdir $HOME/.euterpe $HOME/musics
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/localcerts/euterpe.pem
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/localcerts/euterpe.key
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /tmp/euterpe $HOME/.local/bin/euterpe
COPY --chown=$CONTAINERUSER:$CONTAINERUSER config.json $HOME/.euterpe/config.json
VOLUME $HOME/.euterpe
WORKDIR $HOME/.euterpe
CMD ["euterpe","-D"]
