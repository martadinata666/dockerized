#!/bin/bash
VERSION=13
docker buildx build --build-arg VERSION=$VERSION . -f Dockerfile \
                      -t 192.168.0.2:6060/dedyms/debian:latest \
                      -t 192.168.0.2:6060/dedyms/debian:$VERSION \
                      --push
docker buildx build . -f Dockerfile.dev -t 192.168.0.2:6060/dedyms/debian:dev --push
