#!/bin/bash
docker buildx build . -f Dockerfile -t 192.168.0.2:6060/dedyms/python-http-server --push
