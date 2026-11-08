#!/bin/bash
FFMPEG_VERSION=9

docker buildx build --build-arg RELEASE=staging . \
        --build-arg FFMPEG_VERSION=$FFMPEG_VERSION \
       -f Dockerfile -t 192.168.0.2:6060/dedyms/unmanic:git --push
