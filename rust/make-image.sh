#!/bin/bash
RUST_VERSION=1.99.1
RUSTUP_VERSION=1.29.3
#docker buildx create --use --config buildx-config.toml --driver docker-container \
#                                                       --driver-opt env.BUILDKIT_UNSAFE_HTTP=1 \
#                                                       --driver-opt network=host \
#                                                       --driver-opt image=moby/buildkit:v0.12.5
#docker buildx inspect --bootstrap
docker buildx build --build-arg RUSTUP_VERSION=$RUSTUP_VERSION --build-arg RUST_VERSION=$RUST_VERSION --push . \
       -f Dockerfile -t 192.168.0.2:6060/dedyms/rust:$RUST_VERSION --progress=plain
#docker buildx stop
#docker buildx rm
