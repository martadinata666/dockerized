FROM 192.168.0.2:5050/dedyms/pyload-ng:dev AS tukang
# Build in user
USER $CONTAINERUSER
WORKDIR /home/$CONTAINERUSER/
RUN mkdir -p /home/$CONTAINERUSER/pyload/downloads/ && mkdir -p /home/$CONTAINERUSER/pyload/config/settings/
COPY --chown=$CONTAINERUSER:$CONTAINERUSER pyload.cfg /home/$CONTAINERUSER/pyload/config/settings/pyload.cfg
RUN git clone -b develop --depth=1 https://github.com/pyload/pyload pyload-git
RUN pip3 install --user --no-cache-dir /home/$CONTAINERUSER/pyload-git && rm -rf /home/$CONTAINERUSER/.cache/pip && rm -rf /home/$CONTAINERUSER/pyload-git


# Extract Home Debian to New Container
FROM 192.168.0.2:5050/dedyms/debian:latest
LABEL build-date=$BUILDDATE
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER /home/$CONTAINERUSER
RUN apt update && apt install -y --no-install-recommends python3-minimal python3-setuptools libcurl3-gnutls && apt clean && rm -rf /var/lib/apt/lists/*
WORKDIR /home/$CONTAINERUSER/pyload
# switchback
USER $CONTAINERUSER
VOLUME /home/$CONTAINERUSER/pyload/config /home/$CONTAINERUSER/pyload/downloads
CMD ["bash", "-c", "pyload --userdir /home/$CONTAINERUSER/pyload/config --storagedir /home/$CONTAINERUSER/pyload/downloads"]
