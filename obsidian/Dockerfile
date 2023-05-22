FROM 192.168.0.2:5050/dedyms/debian:latest

RUN \
    echo "**** install packages ****" && \
        # Update and install extra packages.
        sudo apt-get update && \
        sudo apt-get install -y --no-install-recommends libglib2.0-0 libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libgbm1 libgtk-3-0 libasound2 openbox supervisor && \
        sudo apt-get autoclean && \
        sudo rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

# set version label
ARG OBSIDIAN_VERSION=0.15.9

RUN \
    echo "**** download obsidian ****" && \
        curl \
        https://github.com/obsidianmd/obsidian-releases/releases/download/v$OBSIDIAN_VERSION/Obsidian-$OBSIDIAN_VERSION.AppImage \
        -L \
        -o obsidian.AppImage && \
        chmod +x ./obsidian.AppImage && \
        ./obsidian.AppImage --appimage-extract && \
        rm ./obsidian.AppImage && \
        mkdir $HOME/vaults

#RUN \
#    echo "**** extract obsidian ****" && \
#        chmod +x /obsidian.AppImage && \
#        /obsidian.AppImage --appimage-extract

ENV \
    CUSTOM_PORT="8080" \
    GUIAUTOSTART="true"


#    HOME="/vaults" \
#    TITLE="Obsidian v$OBSIDIAN_VERSION"
# add local files
#COPY root/ /

COPY --chown=$CONTAINERUSER:$CONTAINERUSER supervisor /supervisor
#EXPOSE 8080
#EXPOSE 27123
#EXPOSE 27124
VOLUME ["$HOME/vaults"]
#CMD ["obsidian.AppImage"]
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["supervisord","-c","/supervisor/supervisord.conf"]
