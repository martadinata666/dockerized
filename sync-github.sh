#!/bin/bash
# sed -i '1i\#syntax=docker/dockerfile:1.4' ./*/*/Dockerfile*
git-disable-repo.sh --true && \
mv ./..git ./.git && \
git fetch && \
git add . && \
git commit -m "Update" && \
git push origin master --force && \
git-disable-repo.sh --false
mv ./.git ./..git
