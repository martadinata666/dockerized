#!/bin/bash
docker buildx build --platform linux/amd64,linux/arm64 \
     -t martadinata666/pyload-ng:devel-buster \
     -t registry.gitlab.com/dedyms/pyload-ng:devel-buster \
     .
