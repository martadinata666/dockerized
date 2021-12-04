FROM 192.168.0.2:5050/dedyms/node:lts-dev AS tukang
USER $CONTAINERUSER
RUN git clone --depth=1 https://github.com/jellyfin/jellyfin-vue.git $HOME/jellyfin-vue
WORKDIR $HOME/jellyfin-vue
RUN npm ci --no-audit && \
    npm run build

FROM 192.168.0.2:5050/dedyms/nginx:mainline
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/jellyfin-vue/src/dist/ /var/www/html 
COPY --chown=$CONTAINERUSER:$CONTAINERUSER static/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=$CONTAINERUSER:$CONTAINERUSER static/mime.types /etc/nginx/mime.types
