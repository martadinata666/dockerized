FROM 192.168.0.2:5050/dedyms/debian:latest
COPY entrypoint.sh /entrypoint.sh
RUN apt update && apt install -y --no-install-recommends deluged deluge-web deluge-console && apt clean && rm -rf /var/lib/apt/lists/*
EXPOSE 8112 58846 58946 58946/udp
USER $CONTAINERUSER
CMD ["/entrypoint.sh"]
