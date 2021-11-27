FROM 192.168.0.2:5050/dedyms/debian:latest as tukang
ARG TARGETARCH
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://documize.s3-eu-west-1.amazonaws.com/downloads/documize-enterprise-linux-$TARGETARCH $HOME/.local/bin/
RUN mv $HOME/.local/bin/documize-enterprise-linux-$TARGETARCH $HOME/.local/bin/documize
RUN chmod 700 /home/$CONTAINERUSER/.local/bin/documize

# Set multistage because add 700 make the data double
FROM 192.168.0.2:5050/dedyms/debian:latest
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang /home/$CONTAINERUSER/.local/bin/ /home/$CONTAINERUSER/.local/bin/
COPY --chown=$CONTAINERUSER:$CONTAINERUSER documize-mysql.conf /home/$CONTAINERUSER/documize/documize.conf
VOLUME /home/$CONTAINERUSER/documize
USER $CONTAINERUSER
CMD ["bash", "-c", "/home/$CONTAINERUSER/.local/bin/documize /home/$CONTAINERUSER/documize/documize.conf"]
