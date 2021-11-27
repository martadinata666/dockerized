FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && apt install -y python3-minimal && \
    mkdir /data && \
    chown $CONTAINERUSER:$CONTAINERUSER /data
WORKDIR /data
USER $CONTAINERUSER
CMD ["python3","-m","http.server"]