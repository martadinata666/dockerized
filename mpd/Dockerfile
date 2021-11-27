FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && apt install -y --no-install-recommends mpd mpc && apt clean && rm -rf /var/lib/apt/lists/* 
#&& setcap -r /usr/bin/mpd #only in alpine
COPY --chown=$CONTAINERUSER:$CONTAINERUSER mpd.conf /home/$CONTAINERUSER/mpd/mpd.conf

USER $CONTAINERUSER
WORKDIR /home/$CONTAINERUSER/mpd
RUN mkdir -p /home/$CONTAINERUSER/mpd/playlists
VOLUME /home/$CONTAINERUSER/mpd
EXPOSE 6600
EXPOSE 8800
CMD ["mpd", "--stdout", "--no-daemon", "./mpd.conf"]
