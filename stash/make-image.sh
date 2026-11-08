#!/bin/bash
export STASH_VERSION=$(curl --silent "https://api.github.com/repos/stashapp/stash/releases/latest" | jq -r .tag_name)
echo $STASH_VERSION
FFMPEG_VERSION=9
#Maybe need to update ffmpeg if needed
docker buildx build \
                    --build-arg STASHVERSION=$STASH_VERSION --build-arg VERSION=$FFMPEG_VERSION \
                    . -f Dockerfile -t 192.168.0.2:6060/dedyms/stash:latest --push --progress=plain
