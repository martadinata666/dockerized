FROM 192.168.0.2:5050/dedyms/debian:latest as fetcher
#ENV MS=500 CTX_ROOT=/
#FROM debian:sid-slim
ARG TARGETARCH
ARG RELEASE
ENV DOCKERVERSION=$RELEASE
ENV DOCKER_TLS_CERTDIR=/certs
ENV DOCKER_CLI_EXPERIMENTAL=enabled
USER root
RUN echo $TARGETARCH
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

RUN if [ "${TARGETARCH}" = "arm" ]; then \
        curl -fsSLO https://download.docker.com/linux/static/stable/armhf/docker-${DOCKERVERSION}.tgz && \
        tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
        rm docker-${DOCKERVERSION}.tgz; \
    fi;

RUN docker --version


FROM 192.168.0.2:5050/dedyms/debian:latest
ARG RELEASE
ENV DOCKERVERSION=$RELEASE \
    DOCKER_TLS_CERTDIR=/certs \
    DOCKER_CLI_EXPERIMENTAL=enabled
COPY --from=fetcher /usr/local/bin/docker /usr/local/bin/docker
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
USER root
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
#RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
#    && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
#    && rm docker-${DOCKERVERSION}.tgz
