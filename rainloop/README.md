# Rainloop CE Docker 

# Usage
## CLI
```
docker run -d --name rainloop -p 8085:80 martadinata666/rainloop -v /path/to/data:/var/www/localhost/htdocs/data
```
## Compose
```
---
version: "2.4"
services:
  rainloop:
    image: martadinata666/rainloop
    container_name: rainloop
    volumes:
      - /path/to/data:/var/www/localhost/htdocs/data
    ports:
      - 8085:80
    restart: unless-stopped
```

## Tweak as you need
http://ip-address:8085/?admin

Here you can add domain mailbox, change admain password, etc.

## Static data for rainloop config
```
### Set /path/to/data/ as user 1000
-v /path/to/data:/var/www/localhost/htdocs/data
```

## Default admin login
```
User: admin
Pass: 12345
```
# Rainloop Login
http://ip-address:8085
```
Username: youremail@domain.tld
Password: yourpassword
```
The email is your email that registered to the domain mailbox. Assume GMail mailbox added then your login **bla3[at]gmail.com** and **password**
