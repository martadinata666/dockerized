
FROM 192.168.0.2:5050/dedyms/node:lts-dev as fetcher
ENV VITE_DOMAIN="localhost"
ENV VITE_SITE_URL="http://localhost:3000"
ENV ORIGIN="http://localhost:3000"
ENV PORT=3000
COPY --chown=$CONTAINERUSER:$CONTAINERUSER /beatbump/app/build $HOME/beatbump/build
ADD --chown=$CONTAINERUSER:$CONTAINERUSER  https://raw.githubusercontent.com/snuffyDev/Beatbump/dev/app/package.json $HOME/beatbump/package.json
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://raw.githubusercontent.com/snuffyDev/Beatbump/dev/app/package-lock.json $HOME/beatbump/package-lock.json
WORKDIR $HOME/beatbump	
RUN npm config set fetch-retries 1000 && \
    npm config set fetch-retry-mintimeout 999999999 && \
    npm config set fetch-retry-maxtimeout 999999999
RUN npm -d ci --no-audit --legacy-peer-deps && \
    npm cache clean --force


# Runtime
FROM 192.168.0.2:5050/dedyms/node:lts
ENV VITE_DOMAIN="localhost"
ENV VITE_SITE_URL="http://localhost:3000"
ENV ORIGIN="http://localhost:3000"
ENV PORT=3000
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/beatbump $HOME/beatbump
WORKDIR $HOME/beatbump
USER $CONTAINERUSER
CMD ["node","build"]
