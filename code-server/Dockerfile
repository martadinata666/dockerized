FROM 192.168.0.2:5050/dedyms/node:lts as tukang
ARG RELEASE
ARG TARRELEASE
ARG TARGETARCH
ENV CODE_SERVER_VERSION=$RELEASE
# environment settings
#RUN apt update && \
#    apt install -y build-essential \
#	libx11-dev \
#	libxkbfile-dev \
#	libsecret-1-dev \
#	pkg-config \
#        curl && \
#        yarn --production --verbose --frozen-lockfile global add code-server@"$CODE_RELEASE" && \
#        yarnpkg cache clean && \
#apt-get purge --auto-remove -y \
#	build-essential \
#	libx11-dev \
#	libxkbfile-dev \
#	libsecret-1-dev \
#	pkg-config && \
# apt install -y \
#	ssl-cert \
#        git \
#	jq \
#	net-tools && \
# apt clean && \
# rm -rf \
#	/tmp/* \
#	/var/lib/apt/lists/* \
#	/var/tmp/*
RUN apt update && apt install -y --no-install-recommends git && apt clean && rm -rf /var/lib/apt/*
RUN curl -fL https://github.com/cdr/code-server/releases/download/$RELEASE/code-server-$TARRELEASE-linux-$TARGETARCH.tar.gz \
    | tar -C /usr/local/lib -xzv && \
    mv /usr/local/lib/code-server-$TARRELEASE-linux-$TARGETARCH /usr/local/lib/code-server && \
    ln -s /usr/local/lib/code-server/bin/code-server /usr/local/bin/code-server && \
    mkdir -p $HOME/code-server && \
    chown $CONTAINERUSER:$CONTAINERUSER $HOME/code-server
#PATH="~/.local/bin:$PATH"
#code-server
# Now visit http://127.0.0.1:8080. Your password is in ~/.config/code-server/config.yaml
WORKDIR $HOME/code-server
USER $CONTAINERUSER
EXPOSE 8443
VOLUME $HOME
CMD ["bash", "-c", "code-server --bind-addr 0.0.0.0:8443 --user-data-dir $HOME/code-server --extensions-dir $HOME/code-server/extensions --config $HOME/code-server/config.yaml --disable-telemetry"]
