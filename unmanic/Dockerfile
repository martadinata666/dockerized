
# Build app 
FROM 192.168.0.2:5050/dedyms/unmanic:dev AS tukang
ARG RELEASE
USER $CONTAINERUSER
RUN git clone --recursive -b $RELEASE https://github.com/Unmanic/unmanic.git $HOME/unmanic #app clone
WORKDIR $HOME/unmanic
RUN npm install @quasar/cli && \
    pip3 install --no-cache-dir -r requirements.txt && \
    python3 ./setup.py install --user


FROM 192.168.0.2:5050/dedyms/debian:vaapi
ARG RELEASE
ENV UNMANIC_RELEASE=$RELEASE
RUN apt update && \
    apt install -y --no-install-recommends python3-minimal python3-pip python3-setuptools libgomp1 libharfbuzz0b libmediainfo0v5 libv4l-0 nano sqlite3 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local/ $HOME/.local/
USER $CONTAINERUSER
RUN mkdir $HOME/.unmanic /tmp/unmanic
WORKDIR $HOME/.unmanic
VOLUME $HOME/.unmanic
VOLUME /tmp/unmanic
HEALTHCHECK CMD curl --fail http://localhost:8888/unmanic/api/v2/version/read || exit 1 
CMD ["bash", "-c", "unmanic --dev"]
