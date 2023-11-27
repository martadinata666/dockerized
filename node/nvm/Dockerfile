FROM 192.168.0.2:5050/dedyms/debian:latest as base
ARG NODE_RELEASE=20.10.0
ARG NVM_RELEASE=v0.39.5
USER root
ENV NVM_DIR=/usr/local/nvm \
    NODE_VERSION=$NODE_RELEASE \
    PATH=/usr/local/nvm/versions/node/v$NODE_RELEASE/bin/:$PATH \
    NODE_PATH=$NVM_DIR/v$NODE_RELEASE/lib/node_modules
RUN mkdir /usr/local/nvm && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_RELEASE/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    rm -rf /usr/local/nvm/.cache && \
    rm -rf $HOME/.npm
USER $CONTAINERUSER

## Test part
#FROM base
#RUN npm -version && \
#    node -v