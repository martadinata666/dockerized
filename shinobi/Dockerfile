# Fetch shinobi and it deps
FROM 192.168.0.2:5050/dedyms/node:lts-dev as fetcher
RUN git clone --depth=10 -b dev https://gitlab.com/Shinobi-Systems/Shinobi.git Shinobi && \
    rm -rf Shinobi/plugins
WORKDIR $HOME/Shinobi
# Always check notification on web, for unknown reason will blanked
RUN npm -d ci --no-audit && \
    npm install node-telegram-bot-api
#    npm install --save mysql2@^2.1.0 && \
#    npm install --save  knex@2.4.2
#RUN npm install --prod

# VAAPI + Node base image
FROM 192.168.0.2:5050/dedyms/node:lts-ffmpeg
ARG DATE
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends yasm ps-watcher netcat-openbsd git && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*
ENV SHINOBI_VERSION=dev-$DATE \
    PM2_HOME=/Shinobi/pm2
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/Shinobi /Shinobi
WORKDIR /Shinobi
VOLUME ["/Shinobi/videos","/Shinobi/plugins","/Shinobi/libs/customAutoLoad","/config"]
COPY --chown=$CONTAINERUSER:$CONTAINERUSER entrypoint.sh entrypoint.sh
COPY --chown=$CONTAINERUSER:$CONTAINERUSER wait-for /usr/local/bin/wait-for
COPY --chown=$CONTAINERUSER:$CONTAINERUSER pm2.yml pm2.yml
USER $CONTAINERUSER
ENTRYPOINT ["/usr/bin/tini","-g","--","/Shinobi/entrypoint.sh"]
CMD ["pm2-docker","pm2.yml"]
