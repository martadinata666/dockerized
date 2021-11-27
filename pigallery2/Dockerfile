### RELEASE ZIP
FROM 192.168.0.2:5050/dedyms/pigallery2:build AS ziprelease

### FFMPEG
FROM 192.168.0.2:5050/dedyms/ffmpeg-static:latest AS ffmpeg

#-----------------BUILDER-----------------
#-----------------------------------------
FROM 192.168.0.2:5050/dedyms/node:lts-dev AS builder
ENV NODE_ENV=production
RUN apt update && apt install -y --no-install-recommends python3 libsqlite3-dev && ln -sf /usr/bin/python3 /usr/bin/python
WORKDIR /home/$CONTAINERUSER
COPY --from=ziprelease --chown=$CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER/pigallery2-master/release /home/$CONTAINERUSER/pigallery2
USER $CONTAINERUSER
WORKDIR /home/$CONTAINERUSER/pigallery2
RUN npm install --only=prod

#-----------------MAIN--------------------
#-----------------------------------------
FROM 192.168.0.2:5050/dedyms/node:lts
ENV NODE_ENV=production \
    # overrides only the default value of the settings (the actualy value can be overwritten through config.json)
    default-Server-Database-dbFolder=/home/$CONTAINERUSER/pigallery2/data/db \
    default-Server-Media-folder=/home/$CONTAINERUSER/pigallery2/data/images \
    default-Server-Media-tempFolder=/home/$CONTAINERUSER/pigallery2/data/tmp \
    # flagging dockerized environemnt
    PI_DOCKER=true
EXPOSE 80
RUN apt update && apt install -y --no-install-recommends wget && apt clean && rm -rf /var/lib/apt/lists/*
COPY --from=builder --chown=$CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER/pigallery2 /home/$CONTAINERUSER/pigallery2
COPY --from=ffmpeg --chown=$CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER/.local/bin /home/$CONTAINERUSER/.local/bin
WORKDIR /home/$CONTAINERUSER/pigallery2
USER $CONTAINERUSER
RUN mkdir -p /home/$CONTAINERUSER/pigallery2/data/config && \
    mkdir -p /home/$CONTAINERUSER/pigallery2/data/db && \
    mkdir -p /home/$CONTAINERUSER/pigallery2/data/images && \
    mkdir -p /home/$CONTAINERUSER/pigallery2/data/tmp
VOLUME ["/home/$CONTAINERUSER/pigallery2/data/config", "/home/$CONTAINERUSER/pigallery2/data/db", "/home/$CONTAINERUSER/pigallery2/data/images", "/home/$CONTAINERUSER/pigallery2/data/tmp"]
HEALTHCHECK --interval=40s --timeout=30s --retries=3 --start-period=60s \
  CMD wget --quiet --tries=1 --no-check-certificate --spider \
  http://localhost:80/heartbeat || exit 1
# after a extensive job (like video converting), pigallery calls gc, to clean up everthing as fast as possible
# Exec form entrypoint is need otherwise (using shell form) ENV variables are not properly passed down to the app
CMD ["node", "./src/backend/index", "--expose-gc",  "--config-path=./data/config/config.json"]
