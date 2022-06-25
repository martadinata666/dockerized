FROM 192.168.0.2:5050/dedyms/apprise:latest AS apprise

FROM 192.168.0.2:5050/dedyms/node:lts-dev AS fetcher
ARG RELEASE
WORKDIR $HOME
RUN apt update && apt install -y --no-install-recommends python3 python-is-python3 libsqlite3-dev && git clone -b $RELEASE --depth=1 https://github.com/louislam/uptime-kuma.git uptime-kuma
WORKDIR $HOME/uptime-kuma
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN npm -d install && \
    npm -d run build && \
    npm -d prune --prod

FROM 192.168.0.2:5050/dedyms/node:lts
RUN apt update && apt install -y --no-install-recommends \
        python3 python3-pip python3-cryptography python3-six python3-yaml python3-click python3-markdown python3-requests python3-requests-oauthlib \
        sqlite3 iputils-ping util-linux file && \
    apt clean && \
    rm -rf /var/lib/a1pt/* && npm install -g pnpm
COPY --from=apprise --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local $HOME/.local
COPY --from=fetcher --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/uptime-kuma $HOME/uptime-kuma
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libeatmydata.so
WORKDIR $HOME/uptime-kuma
VOLUME $HOME/uptime-kuma/data
EXPOSE 3001
HEALTHCHECK --interval=60s --timeout=30s --start-period=300s CMD node extra/healthcheck.js
USER $CONTAINERUSER
CMD ["npm", "run", "start-server"]
