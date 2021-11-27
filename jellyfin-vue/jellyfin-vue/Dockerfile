FROM martadinata666/node:14-dev AS tukang
USER $CONTAINERUSER
RUN git clone --depth=1 https://github.com/jellyfin/jellyfin-vue.git $HOME/jellyfin-vue
WORKDIR $HOME/jellyfin-vue
RUN npm -d ci --no-audit && \
    npm -d run build:standalone && \
    mkdir -p $HOME/jellyfin-vue-baked && \
    cp -r .docker/nuxt.config.js .docker/package.json .docker/package-lock.json $HOME/jellyfin-vue-baked && \
    cp -r src/.nuxt $HOME/jellyfin-vue-baked/.nuxt && \
    cp -r src/static $HOME/jellyfin-vue-baked/static
WORKDIR $HOME/jellyfin-vue-baked
RUN npm ci --production --no-audit && rm package-lock.json

FROM martadinata666/node:14
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/jellyfin-vue-baked $HOME/jellyfin-vue
WORKDIR $HOME/jellyfin-vue
USER $CONTAINERUSER
CMD ["npm", "start"]
 
