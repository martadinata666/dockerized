
FROM 192.168.0.2:5050/dedyms/debian:latest as tukang
ARG TARGETARCH
ARG RELEASE
USER $CONTAINERUSER
RUN curl -o $HOME/.local/bin/documize -L https://github.com/documize/community/releases/download/$RELEASE/documize-community-linux-$TARGETARCH
#RUN curl -o $HOME/.local/bin/documize https://community-downloads.s3.us-east-2.amazonaws.com/documize-community-plus-linux-$TARGETARCH
RUN chmod 700 /home/$CONTAINERUSER/.local/bin/documize

# Set multistage because add 700 make the data double
FROM 192.168.0.2:5050/dedyms/debian:latest
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang /home/$CONTAINERUSER/.local/bin/documize /home/$CONTAINERUSER/.local/bin/documize
COPY --chown=$CONTAINERUSER:$CONTAINERUSER documize-mysql.conf /home/$CONTAINERUSER/documize/documize.conf
VOLUME /home/$CONTAINERUSER/documize
USER $CONTAINERUSER
CMD ["bash", "-c", "/home/$CONTAINERUSER/.local/bin/documize /home/$CONTAINERUSER/documize/documize.conf"]
