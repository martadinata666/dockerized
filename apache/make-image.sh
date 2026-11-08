#!/bin/bash
VERSION=8.5
docker buildx build --build-arg VERSION=$VERSION . -f Dockerfile -t 192.168.0.2:6060/dedyms/apache:fpm --push --pull