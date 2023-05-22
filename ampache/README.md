# Ampache, web based player
### http://ampache.org/

## Usage
```
version: "3.5"
services:
  db:
    image: mariadb:10.5
    container_name: ampache-db
    networks:
      - ampache
    environment:
      MYSQL_ROOT_PASSWORD: ampacheroot
      MYSQL_USER: ampache
      MYSQL_PASSWORD: ampachepass
      MYSQL_DATABASE: ampache
      TZ: Asia/Jakarta
    volumes:
      - db:/var/lib/mysql
    restart: unless-stopped
  web:
    image: martadinata666/ampache:latest
    container_name: ampache
    environment:
      TZ: Asia/Jakarta
    ports:
      - 4040:443
    volumes:
      - data:/var/www/localhost/htdocs/
      - /path/to/music:/Music
    restart: unless-stopped
    networks:
      - ampache
volumes:
  data:
  db:
  dedyms_music:
    external: true
networks:
  ampache:
    name: ampache
    driver: bridge

```
### This image doesn't provide mysql, the compose will pull mariadb 10.5 image.
### Or can connect to existing mariadb instance
### As this image using standard user #1000 , set your music permission correctly.
```
sudo chown -R 1000:1000 /path/to/music
```
