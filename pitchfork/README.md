## Pitchfork 
### Old but gold MPD web-based music client

* ### https://gitlab.com/dedyms/pitchfork
* ### https://github.com/cdecker/pitchfork
![Pitchfork Homepage](https://i.imgur.com/AlBtjfi.png)

## Supported tags
* ### [git,latest](https://gitlab.com/dedyms/pitchfork/-/blob/master/Dockerfile)

## Usage
```
---
version: '3.5'
services:
  web:
    image: martadinata666/pitchfork:latest
    container_name: pitchfork
    restart: always
    volumes:
      - data:/var/www/localhost/htdocs/
    ports:
      - "8086:80"
volumes:
  data:
```
After run the container, access to http://ip-address:8086 or any port that assigned. 
Pitchfork will going to show setup page, fill MPD ip-address and host. And **SAVE**
![pitchfork Config](https://i.imgur.com/P00pMag.png)
