FROM 192.168.0.2:5050/dedyms/debian:latest
#ENV MS=500 CTX_ROOT=/
ARG TARGETARCH
ARG RELEASE
ENV DOCKERVERSION=$RELEASE
ENV DOCKER_TLS_CERTDIR=/certs
ENV DOCKER_CLI_EXPERIMENTAL=enabled
USER root
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
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
#RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
#    && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
#    && rm docker-${DOCKERVERSION}.tgz
