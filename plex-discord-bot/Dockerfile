FROM 192.168.0.2:5050/dedyms/node:lts-dev AS tukang
ARG RELEASE
USER $CONTAINERUSER
RUN git clone --depth=1 -b ${RELEASE} https://github.com/irbyk/Plex-Discord-Bot_V2.git $HOME/plex-discord-bot
WORKDIR $HOME/plex-discord-bot
RUN npm -d install erlpack && npm -d ci

FROM 192.168.0.2:5050/dedyms/node:lts
ARG RELEASE
ENV PLEX_DISCORD_BOT_VERSION=$RELEASE
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang $HOME/plex-discord-bot $HOME/plex-discord-bot
WORKDIR $HOME/plex-discord-bot
USER $CONTAINERUSER
VOLUME $HOME/plex-discord-bot/config
CMD node index.js
