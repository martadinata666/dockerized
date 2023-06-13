FROM 192.168.0.2:5050/dedyms/debian:dev as tukang
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends python3-minimal python3-setuptools python3-distlib python3-wheel python3-pip python3-dev libcurl4-gnutls-dev libgnutls28-dev git build-essential
# Build in user
USER $CONTAINERUSER
RUN git clone -b master --depth=1 https://github.com/sherlock-project/sherlock.git sherlock
RUN pip3 install --break-system-packages --user --no-cache-dir -r $HOME/sherlock/requirements.txt && rm -rf $HOME/.cache/pip && rm -rf $HOME/pyload-git


# Extract Home Debian to New Container
FROM 192.168.0.2:5050/dedyms/debian:latest
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends python3-minimal python3-setuptools python3-distlib python3-pip python3-wheel libcurl3-gnutls && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*
LABEL build-date=$BUILDDATE
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local $HOME/.local
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/sherlock/sherlock $HOME/sherlock
WORKDIR $HOME/sherlock
# switchback
USER $CONTAINERUSER
ENTRYPOINT ["/usr/bin/tini", "-g", "--", "python3","sherlock.py"]
