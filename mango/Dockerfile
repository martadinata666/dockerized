FROM 192.168.0.2:5050/dedyms/debian:dev AS fetcher
USER $CONTAINERUSER
RUN curl -o $HOME/.local/bin/mango -L https://github.com/hkalexling/Mango/releases/download/v0.24.0/mango && \
    mkdir -p $HOME/mango && \
    chmod +x $HOME/.local/bin/mango

FROM 192.168.0.2:5050/dedyms/debian:latest
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local/bin/mango $HOME/.local/bin/mango
COPY --chown=$CONTAINERUSER:$CONTAINERUSER config.yml $HOME/mango-config.yml
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/mango $HOME/mango
USER $CONTAINERUSER
CMD ["mango","-c","/home/debian/mango-config.yml"]
