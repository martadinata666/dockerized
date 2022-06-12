FROM 192.168.0.2:5050/dedyms/node:lts
COPY --chown=$CONTAINERUSER:$CONTAINERUSER /beatbump/build $HOME/beatbump/build
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://raw.githubusercontent.com/snuffyDev/Beatbump/rewrite/package.json $HOME/beatbump/package.json
WORKDIR $HOME/beatbump
CMD ["node","build"]
