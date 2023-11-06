# Fetch from git
FROM 192.168.0.2:5050/dedyms/debian:latest as fetcher
ARG TARGETPLATFORM
ARG VERSION=$VERSION
ENV CADVISOR_VERSION=$VERSION
RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  CADVISOR_ARCH=amd64  ;; \
         "linux/arm64")  CADVISOR_ARCH=arm64  ;; \
    esac \
    && curl -o cadvisor -L  https://github.com/google/cadvisor/releases/download/$VERSION/cadvisor-$VERSION-linux-{$CADVISOR_ARCH} && \ 
    sudo mv cadvisor /usr/local/bin/cadvisor && \
    sudo chmod +x /usr/local/bin/cadvisor
#RUN git clone --depth=1 --branch release-v0.43 https://github.com/google/cadvisor.git /go/src/github.com/google/cadvisor
#RUN git clone --depth=1 --branch release-${CADVISOR_VERSION} https://github.com/google/cadvisor.git /go/src/github.com/google/cadvisor
#WORKDIR /go/src/github.com/google/cadvisor
#RUN make build

# Image for usage
FROM 192.168.0.2:5050/dedyms/debian:latest
ARG VERSION=$VERSION
ENV CADVISOR_VERSION=VERSION
COPY --from=fetcher /usr/local/bin/cadvisor /usr/local/bin/cadvisor
# Run as non-root user preventing cadvisor looking some stats
USER root
ENTRYPOINT ["/usr/bin/tini","-g","--","/usr/local/bin/cadvisor","-docker_only=true"]
