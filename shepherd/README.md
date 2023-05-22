# Shepherd
[![pipeline status](https://gitlab.com/dedyms/shepherd/badges/master/pipeline.svg)](https://gitlab.com/dedyms/shepherd/-/commits/master)
* ### [Original]https://github.com/djmaze/shepherd
* ### https://gitlab.com/dedyms/shepherd

## A Docker swarm service for automatically updating your services whenever their base image is refreshed.

## Usage
```
    docker service create --name shepherd \
                          --constraint "node.role==manager" \
                          --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,ro \
                          martadinata666/shepherd
```
## Compose
```
version: "3"
services:
  shepherd:
    image: martadinata666/shepherd
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    deploy:
      placement:
        constraints:
        - node.role == manager
```
## Or Compose with apprise 
```
version: "3.5"
services:
  app:
    image: registry.gitlab.com/dedyms/shepherd:latest
    environment:
      APPRISE_SIDECAR_URL: http://notify:8000/notify/
      NOTIFICATION_URL: your-preferered-notification
      # FOR NOTIFICATION FORMAT CHECK
      # https://github.com/caronc/apprise/wiki
      TZ: 'Asia/Jakarta'
      SLEEP_TIME: '720m'
      FILTER_SERVICES: ''
      VERBOSE: 'true'
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - shepherd
    deploy:
      placement:
        constraints:
        - node.role == manager

  notify:
    image: caronc/apprise
    # Internal port 8000, if you have other services, you can open port to host. As sample we use port 1000
    #ports:
    #  - 1000:8000
    deploy:
      placement:
        constraints:
        - node.role == manager

    networks:
      - shepherd

networks:
  shepherd:
    name: shepherd

```
* #### If your set up NOTIFICATION_URL and APPRISE_URL correctly, there will be a notification dry run test.

### Configuration

* Shepherd will try to update your services every 5 minutes by default. You can adjust this value using the `SLEEP_TIME` variable.

* You can prevent services from being updated by appending them to the `BLACKLIST_SERVICES` variable. This should be a space-separated list of service names.

* Alternatively you can specify a filter for the services you want updated using the `FILTER_SERVICES` variable. This can be anything accepted by the filtering flag in `docker service ls`.

* You can enable private registry authentication by setting the `WITH_REGISTRY_AUTH` variable.

* You can enable connection to insecure private registry by setting the `WITH_INSECURE_REGISTRY` variable.

* You can force image deployment whatever the architecture by setting the `WITH_NO_RESOLVE_IMAGE` variable.

* You can enable old image autocleaning on service update by setting the `IMAGE_AUTOCLEAN_LIMIT` variable.

* You can enable one shot running with `RUN_ONCE_AND_EXIT` variable.

Example:

    docker service create --name shepherd \
                        --constraint "node.role==manager" \
                        --env SLEEP_TIME="5m" \
                        --env BLACKLIST_SERVICES="shepherd my-other-service" \
                        --env WITH_REGISTRY_AUTH="true" \
                        --env WITH_INSECURE_REGISTRY="true" \
                        --env WITH_NO_RESOLVE_IMAGE="true" \
                        --env FILTER_SERVICES="label=com.mydomain.autodeploy" \
                        --env APPRISE_SIDECAR_URL="http://notify:8000/notify/" \
                        --env NOTIFICATION_URL="your-prefered-notification-service"
                        --env IMAGE_AUTOCLEAN_LIMIT="5" \
                        --env RUN_ONCE_AND_EXIT="true" \
                        --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,ro \
                        --mount type=bind,source=/root/.docker/config.json,target=/root/.docker/config.json,ro \
                        martadinata666/shepherd

## How does it work?

Shepherd just triggers updates by updating the image specification for each service, removing the current digest.

Most of the work is thankfully done by Docker which [resolves the image tag, checks the registry for a newer version and updates running container tasks as needed](https://docs.docker.com/engine/swarm/services/#update-a-services-image-after-creation).

Also, Docker handles all the work of [applying rolling updates](https://docs.docker.com/engine/swarm/swarm-tutorial/rolling-update/). So at least with replicated services, there should be no noticeable downtime.
