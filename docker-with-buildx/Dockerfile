FROM alpine AS fetcher
RUN apk add curl
ARG TARGETARCH
ARG BUILDX_VERSION
RUN curl -L \
  --output /docker-buildx \
  "https://github.com/docker/buildx/releases/download/$BUILDX_VERSION/buildx-$BUILDX_VERSION.linux-$TARGETARCH"
RUN chmod a+x /docker-buildx

FROM docker:latest
ARG BUILD_VERSION
ENV BUILDX_VERSION=$BUILD_VERSION
RUN apk add --no-cache jq curl
COPY --from=fetcher /docker-buildx /usr/lib/docker/cli-plugins/docker-buildx

