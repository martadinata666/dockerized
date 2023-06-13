## Nextcloud with SMB enabled
### https://nextcloud.com
### Usage
```
docker run -d -p 8080:80 martadinata666/nextcloud-smb
```

### Further usage (persistent storage)
```
docker run -d \
    -v ./www:/var/www/html \
    -v ./apps:/var/www/html/custom_apps \
    -v ./config:/var/www/html/config \
    -v ./data:/var/www/html/data \
    -v ./theme:/var/www/html/themes/<YOUR_CUSTOM_THEME> \
    martadinata666/nextcloud-smb
```

### Compose with mySQL (Recomended)
```
version: '2'

volumes:
  db:

services:
  db:
    image: mariadb:10.5
    restart: always
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=mariadbnc
      - MYSQL_PASSWORD=nextcloud
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
  web:
    image: martadinata666/nextcloud-smb
    restart: always
    ports:
      - 8080:80
    links:
      - db
    volumes:
      - ./www:/var/www/html
    environment:
      - MYSQL_PASSWORD=nextcloud
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=db
```
