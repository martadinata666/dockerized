FROM 192.168.0.2:5050/dedyms/node:lts-dev as tukang
RUN git clone --depth=1 https://github.com/xtermjs/xterm.js.git $HOME/xtermjs
WORKDIR $HOME/xtermjs
RUN yarn install

FROM 192.168.0.2:5050/dedyms/node:lts
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/xtermjs $HOME/xtermjs
WORKDIR $HOME/xtermjs
CMD ["yarn","start"]
