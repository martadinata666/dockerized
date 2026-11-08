#!/bin/bash
export GITHUB_REPO_NAME="nextcloud/server"
export GITHUB_PUSH_NAME="nextcloud/notify_push"
#export NEXTCLOUDRELEASE=$(curl --silent "https://api.github.com/repos/$GITHUB_REPO_NAME/releases/latest" | jq -r .tag_name)
# Nextcloud had many simultanous version, fetch version from github result old version, define version manually
export NEXTCLOUDRELEASE=v35.0.2
export PUSHRELEASE=$(curl --silent "https://api.github.com/repos/$GITHUB_PUSH_NAME/releases/latest" | jq -r .tag_name)
export RELEASE=$(echo $NEXTCLOUDRELEASE | cut -c 2-)
echo $NEXTCLOUDRELEASE
echo $RELEASE
echo $PUSHRELEASE
docker buildx build --pull --push \
                                  --build-arg NEXTCLOUD_VERSION=$NEXTCLOUDRELEASE --build-arg PUSH_VERSION=$PUSHRELEASE \
                                  . -f Dockerfile -t 192.168.0.2:6060/dedyms/nextcloud:$RELEASE
