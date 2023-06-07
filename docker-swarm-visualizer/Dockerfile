FROM 192.168.0.2:5050/dedyms/node:lts-dev AS tukang
RUN git clone --depth=1 https://github.com/yandeu/docker-swarm-visualizer.git docker-swarm-visualizer
#RUN git clone --depth=1 https://github.com/martadinata666/docker-swarm-visualizer.git docker-swarm-visualizer
WORKDIR $HOME/docker-swarm-visualizer
RUN npm config set fetch-retries 100 && \
    npm config set fetch-retry-mintimeout 999999999 && \
    npm config set fetch-retry-maxtimeout 999999999 && \
    pnpm -d install && \
    pnpm -d run build && \
    pnpm -d prune --production && \
    ls -al

FROM 192.168.0.2:5050/dedyms/debian:dev as docker
ARG DOCKERVERSION=19.03.9
ARG TARGETARCH
USER root
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
        curl -fSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz && \
        tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
        rm docker-${DOCKERVERSION}.tgz; \
    fi;

RUN if [ "${TARGETARCH}" = "arm64" ]; then \
        curl -fSLO https://download.docker.com/linux/static/stable/aarch64/docker-${DOCKERVERSION}.tgz && \
        tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
        rm docker-${DOCKERVERSION}.tgz; \
    fi;

FROM 192.168.0.2:5050/dedyms/node:lts
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
COPY --from=tukang $HOME/docker-swarm-visualizer $HOME/docker-swarm-visualizer
WORKDIR $HOME/docker-swarm-visualizer
HEALTHCHECK CMD node /docker-swarm-visualizer/healthcheck.js || exit 1
CMD ["npm","start"]


