#!/bin/bash
PHP_VERSION=8.5.12
TAG_VERSION=8.5
docker buildx build --build-arg PHP_VERSION=$PHP_VERSION . -f Dockerfile -t 192.168.0.2:6060/dedyms/php-fpm:$TAG_VERSION --push --progress=plain
