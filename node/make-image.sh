docker buildx build . -f 24/Dockerfile -t 192.168.0.2:6060/dedyms/node:lts --push
docker buildx build . -f 24/Dockerfile.dev -t 192.168.0.2:6060/dedyms/node:lts-dev --push
docker buildx build . -f 24/Dockerfile.ffmpeg -t 192.168.0.2:6060/dedyms/node:lts-ffmpeg --push