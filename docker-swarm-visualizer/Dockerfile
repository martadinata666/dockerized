#syntax=docker/dockerfile:1.4
FROM 192.168.0.2:5050/dedyms/node:lts-dev AS tukang
#RUN git clone --depth=1 https://github.com/yandeu/docker-swarm-visualizer.git /docker-swarm-visualizer
RUN git clone --depth=1 https://github.com/martadinata666/docker-swarm-visualizer.git /docker-swarm-visualizer
WORKDIR /docker-swarm-visualizer
RUN npm config set fetch-retries 100 && \
    npm config set fetch-retry-mintimeout 99999999 && \
    npm config set fetch-retry-maxtimeout 999999999 && \
    pnpm -d install && \
    pnpm -d run build && \
    pnpm -d prune --production && \
    ls -al

FROM 192.168.0.2:5050/dedyms/node:lts
#ENV MS=500 CTX_ROOT=/
ARG TARGETARCH
ENV DOCKERVERSION=20.10.13

RUN if [ "${TARGETARCH}" = "amd64" ]; then \
        curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz && \
        tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
        rm docker-${DOCKERVERSION}.tgz; \
    fi;

RUN if [ "${TARGETARCH}" = "arm64" ]; then \
        curl -fsSLO https://download.docker.com/linux/static/stable/aarch64/docker-${DOCKERVERSION}.tgz && \
        tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
        rm docker-${DOCKERVERSION}.tgz; \
    fi;

#RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
#    && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
#    && rm docker-${DOCKERVERSION}.tgz

COPY --from=tukang /docker-swarm-visualizer /docker-swarm-visualizer
WORKDIR /docker-swarm-visualizer
HEALTHCHECK CMD node /docker-swarm-visualizer/healthcheck.js || exit 1
CMD ["npm","start"]


