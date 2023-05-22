
FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && apt install -y --no-install-recommends python3-pip git && apt clean && rm -rf /var/lib/apt/lists/* && apt clean
USER $CONTAINERUSER
WORKDIR /home/$CONTAINERUSER/
RUN git clone --depth=1 https://github.com/barrycarey/Plex-Data-Collector-For-InfluxDB.git plexdatacollector
RUN pip3 install --no-cache-dir --user -r /home/$CONTAINERUSER/plexdatacollector/requirements.txt
WORKDIR /home/$CONTAINERUSER/plexdatacollector/
CMD ["python3", "-u", "plexcollector.py"]
VOLUME /home/$CONTAINERUSER/plexdatacollector/
