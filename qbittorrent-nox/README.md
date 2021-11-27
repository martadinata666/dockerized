## Qbittorrent-Nox
### Web based torrent client

* ### https://gitlab.com/dedyms/qbittorrent-nox
* ### https://www.qbittorrent.org/download.php

## Supported tags
* [latest,master](https://gitlab.com/dedyms/qbittorrent-nox/-/blob/master/Dockerfile)

## Usage
```
version: "3.5"
services:
  web:
    image: registry.gitlab.com/dedyms/qbittorrent-nox:latest
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Jakarta
      - WEBPORT=8090
    volumes:
      - /path/to/config:/config
      - /path/to/downloads:/downloads
    ports:
      - 6881:6881
      - 6881:6881/udp
      - 8090:8090
    restart: unless-stopped
    networks:
      - qbittorrent
networks:
  qbittorrent:
    name: qbittorrent
    driver: bridge
```
**/path/to/config** and **/path/to/downloads** must writeable with user ID #1000

## Default username and password
```
username: admin
password: adminadmin
```
