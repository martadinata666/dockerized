FROM 192.168.0.2:5050/dedyms/debian:latest AS fetcher
ARG TARGETARCH
ARG BUILDX_VERSION
RUN curl -L \
  --output /docker-buildx \
  "https://github.com/docker/buildx/releases/download/$BUILDX_VERSION/buildx-$BUILDX_VERSION.linux-$TARGETARCH"
RUN chmod a+x /docker-buildx

FROM 192.168.0.2:5050/dedyms/docker-static:latest
ARG BUILD_VERSION
ENV BUILDX_VERSION=$BUILD_VERSION
RUN apt update && apt install --no-install-recommends jq curl && apt clean && rm -rf /var/lib/apt/lists/*
COPY --from=fetcher /docker-buildx /usr/lib/docker/cli-plugins/docker-buildx

