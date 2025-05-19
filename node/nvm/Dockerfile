FROM 192.168.0.2:5050/dedyms/debian:latest as base
ARG NODE_RELEASE
ARG NVM_RELEASE
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
    npm --cache /dev/shm install -g npm && \
    npm --cache /dev/shm install -g yarn && \
    npm --cache /dev/shm install -g pnpm && \
    npm --cache /dev/shm install -g pm2 && \
    rm -rf $HOME/.npm
USER $CONTAINERUSER

## Test part
#FROM base
#RUN npm -version && \
#    node -v