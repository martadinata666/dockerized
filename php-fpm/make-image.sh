docker buildx build . -f 8.4/Dockerfile.build -t 192.168.0.2:6060/dedyms/php-fpm:8.4 --push --progress=plain
#docker buildx build . -f 8.4/Dockerfile.build.pie -t 192.168.0.2:6060/dedyms/php-fpm:8.4-pie --push --no-cache --progress=plain
