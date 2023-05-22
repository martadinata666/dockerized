
FROM 192.168.0.2:5050/dedyms/node:lts-dev AS tukang
USER $CONTAINERUSER
WORKDIR $HOME
RUN git clone --depth=1 https://github.com/tone-row/flowchart-fun.git flowchart-fun
WORKDIR /home/$CONTAINERUSER/flowchart-fun
#RUN npm install yarn && ls -la $HOME/.config && yarn install
RUN yarn install

FROM 192.168.0.2:5050/dedyms/node:lts
RUN npm install -g concurrently && rm -rf $HOME/.config
ENV NODE_ENV=production
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER/flowchart-fun/ /home/$CONTAINERUSER/flowchart-fun/
WORKDIR /home/$CONTAINERUSER/flowchart-fun
USER $CONTAINERUSER
CMD ["yarn", "start"]
