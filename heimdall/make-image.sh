docker buildx build --build-arg RELEASE=v2.8.2 . -f Dockerfile -t 192.168.0.2:6060/dedyms/heimdall:2.8.2 --push
