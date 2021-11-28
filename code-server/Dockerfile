FROM 192.168.0.2:5050/dedyms/node:lts-dev as tukang
ARG CODE_RELEASE
# environment settings
RUN apt update && \
    apt install -y build-essential \
	libx11-dev \
	libxkbfile-dev \
	libsecret-1-dev \
	pkg-config \
        curl
RUN     node --version && \
        npm install --ignore-engines -g code-server@"$CODE_RELEASE"
RUN     node --version && \
        yarn --ignore-engines rebuild code-server@"$CODE_RELEASE" && \
        yarnpkg cache clean && \
    apt-get purge --auto-remove -y \
	build-essential \
	libx11-dev \
	libxkbfile-dev \
	libsecret-1-dev \
	pkg-config && \
    apt install -y \
	ssl-cert \
        git \
	jq \
	net-tools && \
    apt clean && \
    rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
EXPOSE 8443
USER $CONTAINERUSER
WORKDIR $HOME
VOLUME $HOME
CMD ["bash", "-c", "/usr/local/bin/code-server --bind-addr 0.0.0.0:8443 --user-data-dir $HOME --extensions-dir $HOME --disable-telemetry"]
