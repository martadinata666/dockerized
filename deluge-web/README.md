## Deluge Web
[![pipeline report](https://gitlab.com/dedyms/deluge-web/badges/master/pipeline.svg)](https://gitlab.com/dedyms/deluge-web/-/commits/master)
* ### https://www.deluge-torrent.org/
* ### https://gitlab.com/dedyms/deluge-web

## Suppoted tags
* [latest](https://gitlab.com/dedyms/deluge-web/-/blob/master/Dockerfile)

## Usage (Compose)
```
---
version: "3.5"
services:
  web:
    image: registry.gitlab.com/dedyms/deluge-web:latest
    environment:
      - TZ=Asia/Jakarta
    ports:
      - 58946/tcp
      - 58946/udp
      - 8112:8112
    volumes:
      - /path/to/config:/home/arch
      - /path/to/downloads:/downloads
```
Access on http:/ip-addr:8112 , default password **deluge**
