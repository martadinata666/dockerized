ARG BUILDKIT_VERSION
FROM 192.168.0.2:5050/dedyms/debian:latest AS fetcher
USER root
ARG TARGETARCH
ARG BUILDX_VERSION
RUN curl -L \
  --output /docker-buildx \
  "https://github.com/docker/buildx/releases/download/v$BUILDX_VERSION/buildx-v$BUILDX_VERSION.linux-$TARGETARCH"
RUN chmod a+x /docker-buildx

#FROM moby/buildkit:v${BUILDKIT_VERSION} AS buildkit

FROM 192.168.0.2:5050/dedyms/docker-static:24.0.6
USER root
ARG BUILD_VERSION
ENV DOCKER_BUILDKIT=0
ENV BUILDX_NO_DEFAULT_ATTESTATIONS=1
ENV BUILDX_VERSION=$BUILD_VERSION
ENV DOCKER_TLS_CERTDIR=/certs
ENV DOCKER_CLI_EXPERIMENTAL=enabled
COPY --from=fetcher /docker-buildx /usr/lib/docker/cli-plugins/docker-buildx
#COPY --from=buildkit /usr/bin/buildctl /usr/local/bin/buildctl
#COPY --from=buildkit /usr/bin/buildkit* /usr/local/bin/
# Some smoke test
RUN docker --version && \
    docker buildx version
RUN apt update && \
    apt install -y --no-install-recommends jq curl && \
    apt clean && rm -rf /var/lib/apt/lists/*
