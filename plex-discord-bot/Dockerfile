FROM 192.168.0.2:5050/dedyms/node:lts-dev AS tukang
USER $CONTAINERUSER
RUN git clone --depth=1 https://github.com/irbyk/Plex-Discord-Bot_V2.git $HOME/plex-discord-bot
WORKDIR $HOME/plex-discord-bot
RUN npm -d install erlpack && npm -d install

FROM 192.168.0.2:5050/dedyms/node:lts
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang $HOME/plex-discord-bot $HOME/plex-discord-bot
WORKDIR $HOME/plex-discord-bot
USER $CONTAINERUSER
VOLUME $HOME/plex-discord-bot/config
CMD node index.js