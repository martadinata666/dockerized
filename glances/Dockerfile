FROM 192.168.0.2:5050/dedyms/debian:dev as tukang
ARG RELEASE
ARG PIP_BREAK_SYSTEM_PACKAGES=1
#ARG PIP_RELEASE=echo "$RELEASE" | tr -d v
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends python3-pip build-essential python3-dev python3-setuptools lm-sensors wireless-tools iputils-ping curl
RUN pip3 install --user --no-cache-dir --pre glances[all]==$RELEASE

FROM 192.168.0.2:5050/dedyms/debian:latest
ARG RELEASE
ENV GLANCES_RELEASE=$RELEASE
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends python3-setuptools python3-psutil python3-minimal curl lm-sensors wireless-tools iputils-ping python3-dateutil && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo apt clean
ENV WEBPORT=61208
ENV ADDITIONAL_OPT=-d
RUN  sudo groupadd -g 999 docker && \
     sudo gpasswd -a  $CONTAINERUSER docker && \
     mkdir -p $HOME/glances && \
     chown $CONTAINERUSER:$CONTAINERUSER $HOME/glances
COPY --from=tukang $HOME/.local $HOME/.local
COPY glances.conf $HOME/glances/glances.conf
WORKDIR $HOME/glances
USER $CONTAINERUSER
VOLUME $HOME/glances
CMD ["bash", "-c", "glances -C $HOME/glances/glances.conf -w -p $WEBPORT $ADDITIONAL_OPT"]
