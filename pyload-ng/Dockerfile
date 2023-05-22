FROM 192.168.0.2:5050/dedyms/debian:dev as tukang
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends python3-minimal python3-setuptools python3-distlib python3-wheel python3-pip python3-dev libcurl4-gnutls-dev libgnutls28-dev git build-essential
# Build in user
USER $CONTAINERUSER
RUN mkdir -p $HOME/pyload/downloads/ && mkdir -p $HOME/pyload/config/settings/
COPY --chown=$CONTAINERUSER:$CONTAINERUSER pyload.cfg $HOME/pyload/config/settings/pyload.cfg
RUN git clone -b develop --depth=1 https://github.com/pyload/pyload pyload-git
RUN pip3 install --break-system-packages --user --no-cache-dir $HOME/pyload-git && rm -rf $HOME/.cache/pip && rm -rf $HOME/pyload-git


# Extract Home Debian to New Container
FROM 192.168.0.2:5050/dedyms/debian:latest
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends python3-minimal python3-setuptools python3-distlib python3-pip python3-wheel libcurl3-gnutls && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*
LABEL build-date=$BUILDDATE
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME $HOME
WORKDIR /home/$CONTAINERUSER/pyload
# switchback
USER $CONTAINERUSER
VOLUME $HOME/pyload/config $HOME/pyload/downloads
CMD ["bash", "-c", "pyload --userdir $HOME/pyload/config --storagedir $HOME/pyload/downloads"]
