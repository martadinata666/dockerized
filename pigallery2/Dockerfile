
### FFMPEG
FROM 192.168.0.2:5050/dedyms/ffmpeg-static:latest AS ffmpeg

#-----------------BUILDER-----------------
#-----------------------------------------
FROM 192.168.0.2:5050/dedyms/node:lts-dev AS builder
ARG DATE
ARG RELEASE
ENV NODE_ENV=production
#RUN apt update && apt install -y --no-install-recommends python3 libsqlite3-dev && ln -sf /usr/bin/python3 /usr/bin/python
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends libvips-dev unzip
COPY --from=ffmpeg --chown=$CONTAINERUSER:$CONTAINERUSER /usr/local/bin /usr/local/bin
#RUN npm -g install npm && \
#    curl -L http://192.168.0.2:10000/api/v4/projects/47/packages/generic/$DATE/pigallery2/pigallery2.zip -o pigallery2.zip && \
#    unzip pigallery2.zip -d pigallery2
RUN curl -o $HOME/release.zip -L https://github.com/bpatrik/pigallery2/releases/download/$RELEASE/pigallery2-release.zip && unzip $HOME/release.zip -d $HOME/pigallery2 && ls -al $HOME/pigallery2
#COPY --chown=$CONTAINERUSER:$CONTAINERUSER pigallery2/release pigallery2
WORKDIR $HOME/pigallery2
RUN rm package-lock.json
RUN npm -d install --only=prod --no-audit --no-optional --cache=/dev/shm 
#RUN npm ci --prod

#-----------------MAIN--------------------
#-----------------------------------------
FROM 192.168.0.2:5050/dedyms/node:lts
ARG RELEASE
ENV PIGALLERY2_VERSION=$RELEASE
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends netcat-openbsd wget libvips42 && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*
ENV NODE_ENV=production
ENV PI_DOCKER=true
COPY --from=builder --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/pigallery2 $HOME/pigallery2
COPY --from=ffmpeg --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local/bin $HOME/.local/bin
RUN sudo mkdir -p $HOME/pigallery2/data && \
    sudo mkdir -p /images && \
    sudo mkdir -p /preview && \
    sudo chown -R $CONTAINERUSER:$CONTAINERUSER /preview /images $HOME/pigallery2/data
COPY wait-for /usr/local/bin/wait-for
WORKDIR $HOME/pigallery2
USER $CONTAINERUSER
VOLUME ["$HOME/pigallery2/data", "/images", "/preview"]
ENV default-Database-type=mysql \
    default-Media-folder=/images \
    default-Media-tempFolder=/preview \
    default-Preview-Sorting=[4] \
    default-Gallery-defaultPhotoSortingMethod=descDate
CMD ["bash","-c","wait-for $MYSQL_HOST:3306 -- node ./src/backend/index --expose-gc --config-path=./data/config.json --Database-type=mysql --Media-folder=/images --Media-tempFolder=/preview --Preview-Sorting=[4] --Gallery-defaultPhotoSortingMethod=descDate"]
#CMD ["bash","-c","wait-for $MYSQL_HOST:3306 -- node ./src/backend/index --expose-gc --config-path=./data/config.json"]
