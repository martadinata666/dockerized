FROM 192.168.0.2:5050/dedyms/debian:latest as tukang
ARG TARGETARCH
ARG RELEASE
USER $CONTAINERUSER
RUN curl -o $HOME/.local/bin/documize -L https://github.com/documize/community/releases/download/$RELEASE/documize-community-linux-$TARGETARCH
RUN chmod 700 /home/$CONTAINERUSER/.local/bin/documize

# Set multistage because add 700 make the data double
FROM 192.168.0.2:5050/dedyms/debian:latest
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang /home/$CONTAINERUSER/.local/bin/documize /home/$CONTAINERUSER/.local/bin/documize
RUN mkdir -p $HOME/documize && chown $CONTAINERUSER:$CONTAINERUSER $HOME/documize
VOLUME $HOME/documize
WORKDIR $HOME/documize
USER $CONTAINERUSER
CMD ["bash", "-c", "/home/$CONTAINERUSER/.local/bin/documize"]
