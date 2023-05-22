FROM 192.168.0.2:5050/dedyms/node:lts-dev as node
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends libasound2-dev cmake
RUN npm -d --prefix noVNC/ install ws && \
    npm -d --prefix noVNC/ install audify

FROM 192.168.0.2:5050/dedyms/debian:dev AS tukang
ARG RELEASE
#RUN apt update && apt install --no-install-recommends -y ssl-cert && apt clean && rm -rf /var/lib/apt/lists/*
RUN git clone --depth=1 https://github.com/novnc/noVNC.git noVNC && \
    git clone --depth=1 https://github.com/novnc/websockify noVNC/utils/websockify && \
    rm -rf noVNC/.git && \
    rm -rf noVNC/utils/websockify/.git && \
    curl -L https://raw.githubusercontent.com/novaspirit/Alpine_xfce4_noVNC/dev/script.js -o noVNC/audio.js && \
    curl -L https://raw.githubusercontent.com/novaspirit/Alpine_xfce4_noVNC/dev/audify.js -o noVNC/audify.js

COPY vnc_lite.html noVNC/index.html
COPY openbox/xstartup noVNC/xstartup
COPY pcm-player.js noVNC/pcm-player.js
COPY --from=node $HOME/noVNC/node_modules $HOME/noVNC/node_modules

FROM 192.168.0.2:5050/dedyms/node:lts
ENV REMOTE_HOST=localhost
ENV REMOTE_PORT=5902
ENV NOVNC_PORT=13000
ENV VNC_WIDTH=1280
ENV VNC_HEIGHT=720
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends procps python3-minimal libpython3-stdlib python3-numpy pulseaudio apulse libasound2 pavucontrol tigervnc-standalone-server openbox openbox-menu xterm dbus-x11 supervisor && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/noVNC /noVNC
COPY --chown=$CONTAINERUSER:$CONTAINERUSER supervisor /supervisor
USER $CONTAINERUSER
WORKDIR $HOME/noVNC
CMD ["supervisord","-c","/supervisor/supervisord.conf"]
#CMD ["bash", "-c", "$HOME/noVNC/utils/novnc_proxy --vnc $REMOTE_HOST:$REMOTE_PORT --listen $NOVNC_PORT --ssl-only --key /etc/ssl/localcerts/novnc.key --cert /etc/ssl/localcerts/novnc.pem"]
