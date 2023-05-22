DOCKERVERSION=23.0.6
curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz && \
        tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C ~/.local/bin docker/docker && \
        rm docker-${DOCKERVERSION}.tgz; \
