# Fetch shinobi and it deps
FROM 192.168.0.2:5050/dedyms/node:lts-dev as fetcher
RUN git clone --depth=1 -b dev https://gitlab.com/Shinobi-Systems/Shinobi.git Shinobi && \
    rm -rf Shinobi/plugins
WORKDIR $HOME/Shinobi
RUN npm -d ci --no-audit && \
    npm -d uninstall mysql

# VAAPI base image
FROM 192.168.0.2:5050/dedyms/ffmpeg:6
ENV PM2_HOME=/Shinobi/pm2
# Add nodejs
ARG KEYRING=/usr/share/keyrings/nodesource.gpg
ARG VERSION=node_18.x
ARG DISTRO=bookworm
ARG DATE
ENV SHINOBI_VERSION=dev-$DATE
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends gpg && \
    sudo curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | sudo tee "$KEYRING" >/dev/null && \
    echo 'Package: *\nPin: origin deb.nodesource.com\nPin-Priority: 1001' | sudo tee /etc/apt/preferences.d/nodejs && \
    echo "deb [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list && \
    sudo apt update && \
    sudo apt install -y --no-install-recommends nodejs yasm ps-watcher netcat-openbsd && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo npm --cache /dev/shm install -g npm && \
    sudo npm --cache /dev/shm install -g yarn && \
    sudo npm --cache /dev/shm install -g pnpm && \
    sudo npm --cache=/dev/shm install -g pm2 && \
    sudo rm -rf $HOME/.config && rm -rf $HOME/.npm

COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/Shinobi /Shinobi
WORKDIR /Shinobi
VOLUME ["/Shinobi/videos","/Shinobi/plugins","/Shinobi/libs/customAutoLoad","/config"]
COPY --chown=$CONTAINERUSER:$CONTAINERUSER entrypoint.sh entrypoint.sh
COPY --chown=$CONTAINERUSER:$CONTAINERUSER wait-for /usr/local/bin/wait-for
COPY --chown=$CONTAINERUSER:$CONTAINERUSER pm2.yml pm2.yml
USER $CONTAINERUSER
ENTRYPOINT ["/usr/bin/tini","-g","--","/Shinobi/entrypoint.sh"]
CMD ["pm2-docker","pm2.yml"]
