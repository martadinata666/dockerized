#!/bin/bash
export RELEASE=$(curl --silent "https://api.github.com/repos/nodejs/node/releases" | jq -r 'first(.[] | select(.name | contains("LTS"))) | .tag_name')
export NODE_RELEASE=$(echo $RELEASE | cut -c2-)
export SHORT_NODE_RELEASE=$(echo $RELEASE | cut -c2-3)
export NVM_RELEASE=$(curl --silent "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r .tag_name)
FFMPEG_VERSION=9
VERSION=nvm
CI_REGISTRY_IMAGE=192.168.0.2:6060/dedyms/node

docker buildx build --build-arg NODE_RELEASE=$NODE_RELEASE --build-arg NVM_RELEASE=$NVM_RELEASE --push -t "$CI_REGISTRY_IMAGE:$SHORT_NODE_RELEASE" -t "$CI_REGISTRY_IMAGE:lts" . -f "$VERSION"/Dockerfile
docker buildx build --build-arg NODE_RELEASE=$NODE_RELEASE --build-arg NVM_RELEASE=$NVM_RELEASE --push -t "$CI_REGISTRY_IMAGE:$SHORT_NODE_RELEASE-dev" -t "$CI_REGISTRY_IMAGE:lts-dev" . -f "$VERSION"/Dockerfile.dev
docker buildx build --build-arg NODE_RELEASE=$NODE_RELEASE --build-arg NVM_RELEASE=$NVM_RELEASE --build-arg FFMPEG_VERSION=$FFMPEG_VERSION --push -t "$CI_REGISTRY_IMAGE:$SHORT_NODE_RELEASE-ffmpeg" -t "$CI_REGISTRY_IMAGE:lts-ffmpeg" . -f "$VERSION"/Dockerfile.ffmpeg
