#!/bin/bash
CI_REGISTRY_IMAGE="192.168.0.2:6060/dedyms/qbittorrent-nox"
export RELEASE=$(curl --silent "https://api.github.com/repos/userdocs/qbittorrent-nox-static/releases/latest" | jq -r .tag_name)
docker buildx build --build-arg QBVERSION=$RELEASE --push \
      -t "$CI_REGISTRY_IMAGE" -t "$CI_REGISTRY_IMAGE:$RELEASE" . -f Dockerfile
