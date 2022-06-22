
FROM 192.168.0.2:5050/dedyms/jre:11

ARG VERSION
ENV FLEET_VERSION=$VERSION
ENV fleet_database_driver="org.mariadb.jdbc.Driver"
ENV fleet_app_port=8080
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/linuxserver/fleet/releases/download/$VERSION/fleet-$VERSION.jar $HOME/.local/bin/fleet.jar
USER $CONTAINERUSER
RUN mkdir -p $HOME/fleet/config
WORKDIR $HOME/fleet
VOLUME $HOME/fleet/config
CMD ["bash", "-c", "java -Dlog4j2.formatMsgNoLookups=true -Dfleet.config.base=./config -jar $HOME/.local/bin/fleet.jar"]
