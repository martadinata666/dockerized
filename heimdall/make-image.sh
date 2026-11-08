#!/bin/bash
export RELEASE=$(curl --silent "https://api.github.com/repos/linuxserver/heimdall/releases/latest" | jq -r .tag_name)
echo $RELEASE
#Maybe need newer php version
docker buildx build --build-arg RELEASE=$RELEASE . -f Dockerfile -t 192.168.0.2:6060/dedyms/heimdall:$RELEASE --push --pull
