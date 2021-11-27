FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && apt install -y --no-install-recommends icecast2 && apt clean && rm -rf /var/lib/apt/lists/*
USER $CONTAINERUSER
RUN mkdir -p $HOME/icecast2
WORKDIR $HOME/icecast2
COPY --chown=$CONTAINERUSER:$CONTAINERUSER icecast.xml $HOME/icecast2/icecast.xml
VOLUME $HOME/icecast2
CMD ["bash", "-c", "icecast2 -c $HOME/icecast2/icecast.xml"]
