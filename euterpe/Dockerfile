
FROM 192.168.0.2:5050/dedyms/euterpe:dev AS tukang
ARG RELEASE
#USER $CONTAINERUSER
RUN git clone -b $RELEASE https://github.com/ironsmile/euterpe.git /euterpe
WORKDIR /euterpe
RUN make release
RUN mv euterpe /tmp/euterpe
#RUN go build --tags "sqlite_icu" -ldflags "-X github.com/ironsmile/euterpe/src/version.Version=`git describe --tags --always`" -o euterpe && \
#    upx euterpe


FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt-get update && apt-get install -y libtagc0 libicu67 && apt clean && rm -rf /var/lib/apt/lists/*
USER $CONTAINERUSER
RUN mkdir $HOME/.euterpe
RUN mkdir $HOME/musics
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/localcerts/euterpe.pem
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/localcerts/euterpe.key
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /tmp/euterpe $HOME/.local/bin/euterpe
COPY --chown=$CONTAINERUSER:$CONTAINERUSER config.json $HOME/.euterpe/config.json
VOLUME $HOME/.euterpe
WORKDIR $HOME/.euterpe
EXPOSE 9996
CMD ["euterpe","-D"]
