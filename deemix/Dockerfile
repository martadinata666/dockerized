
#FROM 192.168.0.2:5050/dedyms/node:lts-dev as builder
#WORKDIR $HOME
#ENV NODE_ENV=production
#USER $CONTAINERUSER
#RUN git clone --depth=1 --recursive https://gitlab.com/RemixDev/deemix-gui.git && rm -rf $HOME/deemix-gui/.git
#WORKDIR $HOME/deemix-gui/server
#RUN yarn install --prod && yarn build && rm -rf node_modules
#WORKDIR $HOME/deemix-gui/webui
#RUN yarn install --prod && yarn build && rm -rf node_modules

FROM 192.168.0.2:5050/dedyms/node:lts
ENV WEBPORT=6595
COPY --chown=$CONTAINERUSER:$CONTAINERUSER deemix-gui $HOME/deemix-gui
WORKDIR $HOME/deemix-gui
USER $CONTAINERUSER
RUN mkdir -p /home/debian/deemix-gui/server/config
VOLUME /home/debian/deemix-gui/server/config
CMD yarn start-server --host 0.0.0.0
