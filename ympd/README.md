# YMPD Web Based MPD Client
* ### https://github.com/notandy/ympd
* ### https://gitlab.com/dedyms/ympd
![ympd Homepage](https://i.imgur.com/pV77Mdf.png)

## Supported tags
* [latest,git](https://gitlab.com/dedyms/ympd/-/blob/master/Dockerfile)

## Usage
### Compose (Sample conjunction with YMPD)
```
---
version: '2.4'
services:
  ms:
    image: vimagick/mpd
    container_name: mpd
    privileged: true
    ports:
      - "8800:8800"
    volumes:
      - /path/to/mpd.conf:/etc/mpd.conf
      - /path/to/Music:/var/lib/mpd/music
      - /path/to/playlists:/var/lib/mpd/playlists
    restart: always
  web:
    image: registry.gitlab.com/dedyms/ympd:latest
    container_name: ympd
    restart: always
    environment:
      MPD_SERVER: mpd
      MPD_PORT: 6600
    ports:
      - "8083:8080"
    depends_on:
      - ms
```
### Compose (Standalone)
```
---
version: '2.4'
services:
  web:
    image: registry.gitlab.com/dedyms/ympd:latest
    container_name: ympd
    restart: always
    environment:
      MPD_SERVER: mpd-ip-address
      MPD_PORT: mpd-port
    ports:
      - "8083:8080"
```
