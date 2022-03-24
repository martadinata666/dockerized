#syntax=docker/dockerfile:1.4
FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && \
    apt install --no-install-recommends tigervnc-standalone-server openbox xterm
RUN printf "password\npassword\n\n" | vncpasswd
