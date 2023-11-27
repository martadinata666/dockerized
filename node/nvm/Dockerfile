FROM 192.168.0.2:5050/dedyms/debian:latest
ARG NODE_RELEASE
ARG NVM_RELEASE
USER root
ENV NVM_DIR=/usr/local/nvm \
    NODE_VERSION=$NODE_RELEASE \
    PATH=/usr/local/nvm/versions/node/v${NODE_VERSION}/bin/:$PATH
RUN mkdir /usr/local/nvm && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_RELEASE/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    rm -rf /usr/local/nvm/.cache
USER $CONTAINERUSER
