#!/bin/bash
DOCKER_PATH=/home/dedyms/Documents/docker-gitlab-local
### ESSENTIAL
# Check debian version
cd ${DOCKER_PATH}/debian && ./make-image.sh

# Check ffmeg version https://git.ffmpeg.org/ffmpeg.git
cd ${DOCKER_PATH}/ffmpeg && ./make-image.sh

# Check php version
cd ${DOCKER_PATH}/php-fpm && ./make-image.sh

# Auto latest version of LTS
cd ${DOCKER_PATH}/node && ./make-image.sh

# Update php version if php-update changed version
cd ${DOCKER_PATH}/apache && ./make-image.sh
cd ${DOCKER_PATH}/nginx && ./make-image.sh

# LTS manually generated, just update base image
cd ${DOCKER_PATH}/mariadb && ./make-image.sh

cd ${DOCKER_PATH}

docker buildx prune -f -a

### ADDITIONAL
## Can be automated
# qbittorrent (debian)
# stash (yacron ffmpeg)
# python-http-server (debian)
##########
## Manual due to importance
# Shinobi (node)
# Heimdall (nginx)
# Unmanic (ffmpeg)
# nextcloud (apache ffmpeg-static)