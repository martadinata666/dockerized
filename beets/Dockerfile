
FROM 192.168.0.2:5050/dedyms/sid-slim:latest
RUN apt update && apt install -y --no-install-recommends beets
USER $CONTAINERUSER
RUN mkdir $HOME/beets
COPY --chown=$CONTAINERUSER:$CONTAINERUSER config.json $HOME/beets/config.json
VOLUME $HOME/beets
WORKDIR $HOME/beets
CMD beets web
