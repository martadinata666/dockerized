#!/bin/bash
VERSION=13
docker buildx build --build-arg VERSION=$VERSION . -f 12.3/Dockerfile.debian -t 192.168.0.2:6060/dedyms/mariadb:lts --push --progress=plain
