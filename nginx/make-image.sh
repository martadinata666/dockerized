#!/bin/bash
export PHPVERSION=8.4
docker buildx build . -f fpm/Dockerfile.fpm$PHPVERSION -t 192.168.0.2:6060/dedyms/nginx:mainline-fpm --push --pull
