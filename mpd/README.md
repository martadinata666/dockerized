## MPD in docker
### https://www.musicpd.org/

## Usage
### Standalone
```
version: '3.5'
services:
  player:
    image: martadinata666/mpd:latest
    container_name: mpd
    ports:
      - "8800:8800"
      - "6600:6600"
    volumes:
      - /path/to/music:/music
      - lib:/mpd
    restart: always
```
In this situation you can manage MPD by client, such as ncmpcpp, cantata, mpc, etc.
###/path/to/music need permission user #1000
```
$sudo chown -R 1000:1000 /path/to/music
```

### Conjuntion with ympd (Web based client)
```
version: '3.5'
services:
  player:
    image: martadinata666/mpd:latest
    container_name: mpd
    networks:
      - mpd
    ports:
      - "8800:8800"
    volumes:
      - dedyms_music:/music
      - lib:/mpd
    restart: always
  web:
    image: martadinata666/ympd:latest
    container_name: mpd-web
    networks:
      - mpd
    restart: always
    environment:
      MPD_SERVER: mpd
      MPD_PORT: 6600
    ports:
      - "8083:8080"
    depends_on:
      - mpd
volumes:
  lib:
  dedyms_music:
    external: true
networks:
  mpd:
    name: mpd
    driver: bridge
```
