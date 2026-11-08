#!/bin/bash
FFMPEG_VERSION=n9.0
TAG_VERSION=9
docker buildx build --build-arg FFMPEG_VERSION=$FFMPEG_VERSION . -f Dockerfile -t 192.168.0.2:6060/dedyms/ffmpeg:$TAG_VERSION --push
