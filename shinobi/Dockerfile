# Fetch shinobi and it deps
FROM 192.168.0.2:5050/dedyms/node:lts-dev as fetcher
RUN git clone --depth=1 -b dev https://gitlab.com/Shinobi-Systems/Shinobi.git Shinobi && \
    rm -rf Shinobi/plugins
WORKDIR $HOME/Shinobi
RUN npm -d ci --no-audit && \
    npm -d uninstall mysql

# VAAPI base image
FROM 192.168.0.2:5050/dedyms/ffmpeg:4
ENV PM2_HOME=/Shinobi/pm2
# Add nodejs
ARG KEYRING=/usr/share/keyrings/nodesource.gpg
ARG VERSION=node_18.x
ARG DISTRO=sid
ARG DATE
ENV SHINOBI_VERSION=dev-$DATE
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash - && \
    sudo apt install -y --no-install-recommends nodejs tini git mariadb-client yasm ps-watcher && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo npm --cache=/dev/shm install -g pm2 && \
    sudo mkdir -p /config && \
    sudo chown $CONTAINERUSER:$CONTAINERUSER /config

COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/Shinobi /Shinobi
WORKDIR /Shinobi
VOLUME ["/Shinobi/videos","/Shinobi/plugins","/Shinobi/libs/customAutoLoad","/config"]
COPY --chown=$CONTAINERUSER:$CONTAINERUSER entrypoint.sh entrypoint.sh
COPY --chown=$CONTAINERUSER:$CONTAINERUSER pm2.yml pm2.yml
USER $CONTAINERUSER
ENTRYPOINT ["/usr/bin/tini","-g","--","sh","entrypoint.sh"]
CMD ["pm2-docker","pm2.yml"]
