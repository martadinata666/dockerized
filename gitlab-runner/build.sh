VERSION=v17.3.3
docker buildx build --push --build-arg RELEASE=$VERSION  --platform linux/amd64 . -t 192.168.0.2:5050/dedyms/gitlab-runner:$VERSION -f runner/Dockerfile.runner
docker buildx build --push --build-arg RELEASE=$VERSION  --platform linux/amd64 . -t 192.168.0.2:5050/dedyms/gitlab-runner:$VERSION-helper -f helper/Dockerfile.helper
