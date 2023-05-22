FROM 192.168.0.2:5050/dedyms/debian:latest
RUN sudo apt update && \
    sudo apt install -y python3-minimal && \
    sudo apt clean && \ 
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo mkdir /data && \
    sudo chown $CONTAINERUSER:$CONTAINERUSER /data
USER $CONTAINERUSER
WORKDIR /data
CMD ["python3","-m","http.server"]
