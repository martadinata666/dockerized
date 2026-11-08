#!/bin/bash
VERSION=8.5
docker buildx build --build-arg VERSION=$VERSION . \
    -f fpm/Dockerfile -t 192.168.0.2:6060/dedyms/nginx:mainline-fpm --push --pull
