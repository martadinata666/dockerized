docker buildx build --build-arg RELEASE=staging . -f Dockerfile -t 192.168.0.2:6060/dedyms/unmanic:git --push
