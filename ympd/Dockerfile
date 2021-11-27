FROM 192.168.0.2:5050/dedyms/debian:latest AS tukang
WORKDIR /src
RUN apt update && apt install -y --no-install-recommends build-essential cmake libmpdclient-dev libssl-dev unzip
#ADD https://github.com/notandy/ympd/archive/master.zip master.zip
#ADD https://github.com/SuperBFG7/ympd/archive/refs/heads/master.zip master.zip
ADD https://github.com/martadinata666/ympd-1/archive/refs/heads/master.zip master.zip
RUN unzip master.zip -d /src/
RUN cmake /src/ympd-1-master/
RUN make

FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && apt install -y libmpdclient2 openssl && rm -rf /var/lib/apt/lists/* && apt clean
WORKDIR $HOME
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang /src/ympd $HOME/.local/bin/ympd
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang /src/mkdata $HOME/.local/bin/mkdata
ENV MPD_SERVER=0.0.0.0
ENV MPD_PORT=6600
ENV WEBPORT=8080
EXPOSE 8080/tcp
USER $CONTAINERUSER
CMD ympd -h $MPD_SERVER -p $MPD_PORT
