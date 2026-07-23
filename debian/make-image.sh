docker buildx build . -f trixie/Dockerfile \
                      -t 192.168.0.2:6060/dedyms/debian:latest \
                      -t 192.168.0.2:6060/dedyms/debian:trixie \
                      --push
docker buildx build . -f trixie/Dockerfile.dev -t 192.168.0.2:6060/dedyms/debian:dev --push